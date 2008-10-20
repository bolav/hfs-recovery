#!/usr/bin/perl

use strict;
use IO::File;
use Filesystem::HFS::BTNodeDescriptor;
use Filesystem::HFS::BTHeaderRec;
use Filesystem::HFS::DataReader;
use Filesystem::HFS::HFSPlusCatalogIndexNode;
use Filesystem::HFS::HFSPlusCatalogKey;
use Filesystem::HFS::HFSPlusCatalogFolder;
use Filesystem::HFS::HFSPlusCatalogFile;

  my $nodeSize = 8192;
  my $blockSize = 4096;

my $fh = new IO::File;
$fh->open("/root/bo-backup/bolav-mac-fuck-disk-sdb2") || die "Couldnt open";

# Todo: read threads?

# my $offset = 209735680; # Partition starts there - for full dump
my $offset = 0;


# read APM
# my $length = filelength
# test / browse / fragcheck / fileinfo
#my $user_seek = 0x02C6D000;

my %folder_id;
my %files_folder;
my %key_cnid;
my %rec_cnid;
my @error_nodes;

my $maxseen = 0;
my $maxread = 0;
my $maxtried = 0;

#my $user_seek = 0x02C6D000-(8192*4010);
# 4010 
# -> 115
my $catalogfile = 0x02C6D000-(8192*(4010+12));
my $user_seek = 0x02C6D000-(8192*(4010-1));
print "seek: $user_seek\n";

if (1) {
  #&read_catalog($user_seek,1,1,15945,1);
  &read_catalog($user_seek,1,15946,28672-15946,2);

  # 39131

  &print_vars;
  exit(0);
}

while (<>) {
  if (/^lsxxxx$/) {
    &read_catalog($user_seek);
#  } elsif (/^cat (.*)$/) {
#    &cat_file($user_seek,$1);
  } elsif (/^init\s*(\d*)\s*(\d*)$/) {
    &read_catalog($user_seek,1,$1,$2);
  } elsif (/^dinit\s*(\d*)\s*(\d*)$/) {
    &read_catalog($user_seek,0,$1,$2);
  } elsif (/^lsid (.*)$/) {
    &show_dirid($1);
  } elsif (/^catid (.*)$/) {
    &cat_id($1);
  } elsif (/^cpid (\d+)\s*(.*)$/) {
    &cp_id($1,$2);
  } elsif (/^treeid (.*)$/) {
    &treeid($1);
  } elsif (/^savedir (\d+)$/) {
    &savedir($1);
  } elsif (/^showdirids/) {
    &show_dirids();
  } elsif (/^showorphans/) {
    &show_orphans();
  } elsif (/^search (.*)$/) {
    &search($1,1);
  } elsif (/^rsearch (.*)$/) {
    &search($1,2);
  } elsif (/^up (\d+)$/) {
    &up($1);
  } elsif (/^free$/) {
    print "memory freed\n";
    %folder_id = ();
    %files_folder = ();
    %key_cnid = ();
    %rec_cnid = ();
  } elsif (/^errors$/) {
    print "errors: ",join(",",@error_nodes),"\n";
  } elsif (/^vars$/) {
    &print_vars;
  }
  # cp
  # set seek
  # set nodesize
  print "\n> ";
}

sub print_vars 
{
    print "maxseen: $maxseen\n";
    print "maxread: $maxread\n";
    print "maxtried: $maxtried\n";
    print "fhtell: ",$fh->tell(),"\n";

}

sub up 
{
  my $cnid = shift;
  
  if ($key_cnid{$cnid}) {
      print "$cnid ";
      print $key_cnid{$cnid}->ls_string," ";
      print $rec_cnid{$cnid}->ls_string;
      if (($rec_cnid{$cnid}->recordType == 0x0001)&&($files_folder{$cnid})) {
        print " files: ",scalar(@{$files_folder{$cnid}});
      }
      print "\n";
      &up($key_cnid{$cnid}->parentID());
  }
}

sub search
{
  my $filename = shift;
  my $searchtype = shift;
  # 1 - exact
  # 2 - regexp /i
  # 3 - regexp
  
  foreach my $k (keys %key_cnid) {
    if (
        (($searchtype == 1)&&($key_cnid{$k}->nodeName() eq $filename)) ||
        (($searchtype == 2)&&($key_cnid{$k}->nodeName() =~ /$filename/i)) 
       ) {
      print "$k ";
      print $key_cnid{$k}->ls_string," ";
      print $rec_cnid{$k}->ls_string;
      if (($rec_cnid{$k}->recordType == 0x0001)&&($files_folder{$k})) {
        print " files: ",scalar(@{$files_folder{$k}});
      }
      
      print "\n";
    }
    
  }
  
}

sub treeid
{
  my $cnid = shift;
  my $pad = shift;

  if ($rec_cnid{$cnid}) {
    print $pad,$cnid," ",$key_cnid{$cnid}->ls_string;
  } else {
    print $pad,$cnid;
  }

  if ($files_folder{$cnid}) {
    print " files: ",scalar(@{$files_folder{$cnid}});
  }
  print "\n";
  
  foreach my $k (@{$files_folder{$cnid}}) {
    if ($rec_cnid{$k}->recordType == 0x0001) {
      &treeid($rec_cnid{$k}->folderID(),$pad."  ");
    }
  }
  
}

sub show_orphans
{
  foreach my $k (keys %files_folder) {
    unless ($key_cnid{$k}) {
      print $k,",";
    }
  }
  print "\n";
}

sub show_dirids
{
  print join(",",keys %files_folder);
}

sub show_dirid 
{
  my $cnid = shift;
  
  print $cnid," ";
  if ($key_cnid{$cnid}) {
    print $key_cnid{$cnid}->ls_string(),"\n" 
  } else {
    print "\n";
  }
  
  foreach my $k (@{$files_folder{$cnid}}) {
    print $k," ";
    print $key_cnid{$k}->ls_string()," ";
    print $rec_cnid{$k}->ls_string()," ";
    if ($rec_cnid{$k}->recordType() == 0x0001) {
      # folder
      if ($files_folder{$k}) {
        print "files: ",scalar(@{$files_folder{$k}});
      }
    }
    print "\n";
    
#    print $k->ls_string(),"\n";
  }
}

sub savedir
{
  my $cnid = shift;
  my $dir = shift;
  if ($key_cnid{$cnid}) {
    $dir .= $key_cnid{$cnid}->nodeName()."/";
  } else {
    $dir .= $cnid."/";
  }
  mkdir $dir;
  foreach my $k (@{$files_folder{$cnid}}) {
    if ($rec_cnid{$k}->recordType() == 0x0001) {
      &savedir($k,$dir);
    } elsif ($rec_cnid{$k}->recordType() == 0x0002) {
      &cp_id($k,$dir.$key_cnid{$k}->nodeName());
    }
  }
}


sub cat_id
{
  my $cnid = shift;
  print &get_id($cnid);
}

sub cp_id
{
  my $cnid = shift;
  my $fn = shift;
  my $oldf = $fn;
  if ($key_cnid{$cnid}) {
    $oldf = $key_cnid{$cnid}->nodeName();
  }
  $fn = $oldf if (!$fn);
  print "Writing from $oldf to $fn\n";
  my $of;
  open($of,">$fn");
  print $of &get_id($cnid);
  close($of);
}

sub get_id
{
  my $cnid = shift;
  
  if (!$rec_cnid{$cnid}) {
    print "File not found.\n";
    return;
  }
  
  if ($rec_cnid{$cnid}->recordType() != 0x0002) {
    print "Can only cat files.",$rec_cnid{$cnid}->recordType(),"\n";
    return;
  }
  
  my $df = $rec_cnid{$cnid}->dataFork();
  print "Size: ",$df->logicalSize(),"\n";
  my $buf;
  my $ret;
  
  my $eds = $df->extents()->extentDescriptors();
  foreach my $ed (@{$eds}) {
    if ($ed->blockCount()>0) {
      print "Reading: ",$ed->blockCount()," from ",$ed->startBlock(),"\n";
      $fh->seek($ed->startBlock()*$blockSize,0);
      print "read ",$fh->read($buf,$blockSize*$ed->blockCount()),"\n";
      $ret .= $buf;
    }
  }
  return substr($ret,0,$df->logicalSize());
}

sub cat_file 
{
  my $seek = shift;
  my $file = shift;
  
  my $v = &read_catalog($seek,1,$file);
  print "Found: ",$v->{'key'}->nodeName(),"\n";
  print "Size: ",$v->{'filerec'}->dataFork()->logicalSize(),"\n";
  my $buf;
  
  my $eds = $v->{'filerec'}->dataFork()->extents()->extentDescriptors();
  foreach my $ed (@{$eds}) {
    print "Reading: ",$ed->blockCount()," from ",$ed->startBlock(),"\n";
    if ($ed->blockCount()>0) {
      print "Reading!\n";
      $fh->seek($ed->startBlock()*$blockSize,0);
      print "read ",$fh->read($buf,$blockSize*$ed->blockCount()),"\n";
      print $buf;
    }
  }
}

sub read_catalog
{
  my $seek = shift;
  my $no_print = shift;
  my $start = shift;
  my $no = shift;
  my $store = shift;
  my $find_file = 0;
  $fh->seek($offset+$seek,0);
  my $nodeNumber = 13;
  # my $bytesRead = 
  
  my %seen;
  
  my %bad = ( 127 => 1,
              143 => 1,
              183 => 1,
              236 => 1,
              303 => 1,
              319 => 1,
              334 => 1,
              351 => 1,
            );
  my $cur = 13;
  $no = 10 unless ($no);
  $cur = $start if ($start);
  # my $cur = 2993; 512
  
  my $tree_offset = 0;
  if ($cur > 15945) {
    $tree_offset += 716097;
  }

  $fh->seek($catalogfile+(($tree_offset + $cur) * $nodeSize),0);
  print $catalogfile+($cur * $nodeSize),"\n";
  $nodeNumber = $cur;

  
for (my $jjj=0;$jjj<$no;$jjj++){
  my $buf;
  $fh->read($buf,$nodeSize);
  my $dr = new Filesystem::HFS::DataReader('buffer' => $buf);
  $maxtried = $nodeNumber;

  my $nodeDescriptor = new Filesystem::HFS::BTNodeDescriptor;
  $nodeDescriptor->load_from_datareader($dr);
  
  print "Reading node ".$nodeNumber."...\n";
  print $nodeDescriptor->toString()."\n";
   
  if (
      (($nodeDescriptor->kind() == -1)&&($nodeDescriptor->height() == 1)&&($nodeDescriptor->reserved() == 0))
      && (!$bad{$nodeNumber})
     )
  {
  my @off;
  for (my $i=0;$i<$nodeDescriptor->numRecords();$i++) {
    my $j = $nodeSize-(($i+1)*2);
    push(@off, 
      Filesystem::HFS::DataReader::UInt16_off($buf,$j)
    );
  }
  # read offsets backward (we need nodeSize)
  #177 	    int nodeSize = bthr.getNodeSize();
  #178 	    byte[] currentNode = new byte[nodeSize];
  
  #249 		for(int i = 0; i < offsets.length; ++i) {
  #250 		    offsets[i] = Util.readShortBE(currentNode, currentNode.length-((i+1)*2));
  #251 		}
  
  #253 		for(int i = 0; i < offsets.length; ++i) {
  #254 		    int currentOffset = Util2.unsign(offsets[i]);
  #255 
  #256 		    if(i < offsets.length-1) {
  for (my $i = 1; $i<$nodeDescriptor->numRecords();$i++) {
    if ($nodeDescriptor->kind() != Filesystem::HFS::BTNodeDescriptor::BT_HEADER_NODE) 
    {
      if ($off[$i] > $nodeSize) {
        push(@error_nodes,$nodeNumber);
        print "offsets: ",join(",",@off),"\n";
        last;
      }
      my $currentKey = new Filesystem::HFS::HFSPlusCatalogKey;
      $currentKey->load_from_datareader($dr,$off[$i]);
      if ($nodeDescriptor->kind() == Filesystem::HFS::BTNodeDescriptor::BT_LEAF_NODE) 
      {
        print "[".$nodeNumber."] ".$currentKey->ls_string() unless ($no_print);
        my $recordType = Filesystem::HFS::DataReader::UInt16_off($buf, $off[$i]+$currentKey->keyLength()+2);
        if ($recordType == 0x0001) {      print " [folder]" unless ($no_print);
        } elsif ($recordType == 0x0002) { print " [file]" unless ($no_print);
        } elsif ($recordType == 0x0003) { print " kHFSPlusFolderThreadRecord\n" unless ($no_print);
        } elsif ($recordType == 0x0004) { print " kHFSPlusFileThreadRecord\n" unless ($no_print);
        } else {                           print "UNKNOWN! $recordType\n" unless ($no_print);
        }
        
        if ($recordType == 0x0001) {      
          my $folderRec = new Filesystem::HFS::HFSPlusCatalogFolder;
          $folderRec->load_from_datareader($dr,$off[$i]+$currentKey->keyLength()+2);
          #print $folderRec->toString();
          print "\n" unless ($no_print);
          
          if (!$store) {
            push(@{$files_folder{$currentKey->parentID()}},$folderRec->folderID());
            $key_cnid{$folderRec->folderID()} = $currentKey;
            $rec_cnid{$folderRec->folderID()} = $folderRec;
          } elsif ($store == 1) { 
            print "[".$nodeNumber."] ",$folderRec->folderID()," ",$currentKey->ls_string()," ",$folderRec->ls_string(),"\n";
          }
        } elsif ($recordType == 0x0002) { 
          my $fileRec = new Filesystem::HFS::HFSPlusCatalogFile;
          $fileRec->load_from_datareader($dr,$off[$i]+$currentKey->keyLength()+2);
          print "\nid: ".$fileRec->fileID()." size: ".$fileRec->dataFork()->logicalSize()." blocks: ".$fileRec->dataFork()->totalBlocks()."\n" unless ($no_print);
          #if ($find_file eq $currentKey->nodeName()) {
          #  my %r;
          #  $r{'key'} = $currentKey;
          #  $r{'filerec'} = $fileRec;
          #  return \%r;
          #}
          if (!$store) {
            push(@{$files_folder{$currentKey->parentID()}},$fileRec->fileID());
            $key_cnid{$fileRec->fileID()} = $currentKey;
            $rec_cnid{$fileRec->fileID()} = $fileRec;
          } elsif ($store == 1) {
            print "[".$nodeNumber."] ",$fileRec->fileID()," ",$currentKey->ls_string()," ",$fileRec->ls_string(),"\n";
          }
          #print "extents: ".$fileRec->dataFork()->extents()->toString()."\n";
          #print $fileRec->toString();
        } elsif ($recordType == 0x0003) { 
        } elsif ($recordType == 0x0004) { 
        }
      }
      
    }
  }
  $maxread = $nodeNumber if ($nodeNumber > $maxread);
  $maxseen = $nodeNumber if ($nodeNumber > $maxseen);
  $maxseen = $nodeDescriptor->fLink() if ($nodeDescriptor->fLink() > $maxseen);
  $maxseen = $nodeDescriptor->bLink() if ($nodeDescriptor->bLink() > $maxseen);
  $nodeNumber++;
  my $flink = $nodeDescriptor->fLink();
  if (
      ($flink == 127)|| 
      ($flink == 143)
     ) {
    $flink++;
  }
    
#  print "Seeking to: ",$flink,"\n";
#  $fh->seek($catalogfile+($flink * $nodeSize),0);
#  $nodeNumber=$flink;
  } else { 
    push(@error_nodes,$nodeNumber);
    $nodeNumber++; } 
  }
}


sub read_header 
{
my $currentBlock;

$fh->seek($offset+1024,0);
$fh->read($currentBlock,512);

# 512 aligned
#8392704
#58113024
#132683264


$fh->seek(41223,0);

my $look = 1;
my $btnd;
my $bthr;
while ($look) {
my $pos = $fh->tell();
$btnd = new Filesystem::HFS::BTNodeDescriptor;
$btnd->load_from_file($fh);

$bthr = new Filesystem::HFS::BTHeaderRec;
$bthr->load_from_file($fh);
if (($bthr->sane($btnd))&&($btnd->sane())) {
  print $btnd->toString()."\n";
  print $bthr->toString();
  print "$pos!\n";
  $look = 0;
} else {
$fh->seek($pos+1,0);
}
}

$fh->seek($bthr->rootNode()*$bthr->nodeSize()-512,1);
print $fh->tell(),"\n";
my $currentNodeData;
$fh->read($currentNodeData,$bthr->nodeSize());
#print &debug($currentNodeData);
my $dr = new Filesystem::HFS::DataReader('buffer' => $currentNodeData);
my $nodeDescriptor = new Filesystem::HFS::BTNodeDescriptor;
$nodeDescriptor->load_from_datareader($dr);
print $nodeDescriptor->toString()."\n";
print $nodeDescriptor->sane();
my $currentNode = 
  new Filesystem::HFS::HFSPlusCatalogIndexNode
    ('nodeDescriptor' => $nodeDescriptor,
     'datareader' => $dr);

# $header = new Filesystem::HFS::HFSPlusVolumeHeader($currentBlock);

# long catalogFilePosition =
# header.getBlockSize()*
# header.getCatalogFile().getExtents().getExtentDescriptor(0).getStartBlock();

# isoRaf.seek(offset + catalogFilePosition);

#  155 	    byte[] nodeDescriptorData = new byte[14];
#  156 	    if(isoRaf.read(nodeDescriptorData) != nodeDescriptorData.length)
#  157 		System.out.println("ERROR: Did not read nodeDescriptor completely.");
#  158 	    BTNodeDescriptor btnd = new BTNodeDescriptor(nodeDescriptorData, 0);
#  159 	    btnd.print(System.out, "");

#  161 	    byte[] headerRec = new byte[BTHeaderRec.length()];
#  162 	    if(isoRaf.read(headerRec) != headerRec.length)
#  163 		System.out.println("ERROR: Did not read headerRec completely.");
#  164 	    BTHeaderRec bthr = new BTHeaderRec(headerRec, 0);
#  165 	    bthr.print(System.out, "");
#  166 
#  167 	    // Now we have the node size, so we could just list the nodes and see what types are there.
#  168 	    // Btw, does the length of the catalog file containing this b-tree align to the node size?
#  169 	    if(catalogFileLength % bthr.getNodeSize() != 0) {
#  170 		System.out.println("catalogFileLength is not aligned to node size! (" + catalogFileLength +
#  171 				   " % " + bthr.getNodeSize() + " = " + catalogFileLength % bthr.getNodeSize());
#  172 		return;
#  173 	    }
#  174 	    else
#  175 		System.out.println("Number of nodes in the catalog file: " + (catalogFileLength / bthr.getNodeSize()));
#  176 
#  177 	    int nodeSize = bthr.getNodeSize();
#  178 	    byte[] currentNode = new byte[nodeSize];
#  179 
#  180 
#  181 
#  182 	    // collect all records belonging to directory 1 (= ls)
#  183 	    System.out.println();
#  184 	    System.out.println();
#  185 	    ForkFilter catalogFile = new ForkFilter(header.getCatalogFile(),
#  186 						    header.getCatalogFile().getExtents().getExtentDescriptors(),
#  187 						    isoRaf, offset, header.getBlockSize());
#  188 	    HFSPlusCatalogLeafRecord[] f = HFSPlusFileSystemView.collectFilesInDir(new HFSCatalogNodeID(1), bthr.getRootNode(), isoRaf,
#  189 									       offset, header, bthr, catalogFile);
#  190 	    System.out.println("Found " + f.length + " items in subroot.");

#  188 	    HFSPlusCatalogLeafRecord[] f = HFSPlusFileSystemView.collectFilesInDir(new HFSCatalogNodeID(1), bthr.getRootNode(), isoRaf,
#  189 									       offset, header, bthr, catalogFile);
}



#print &debug($currentBlock);

sub debug {
  my $s = $_[0];
  my $p = 0;
  for (my $j=0;$j<32;$j++) {
    print sprintf("%04x ",$p);
    for (my $i=0;$i<0x10;$i++) {
      print sprintf ("%02x ",ord(substr($s,$p++,1)));
    }
    print "\n";
  }
}