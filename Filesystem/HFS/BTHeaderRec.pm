package Filesystem::HFS::BTHeaderRec;

import Filesystem::HFS::DataReader;


#struct BTHeaderRec {
#    UInt16    treeDepth;
#    UInt32    rootNode;
#    UInt32    leafRecords;
#    UInt32    firstLeafNode;
#    UInt32    lastLeafNode;
#    UInt16    nodeSize;
#    UInt16    maxKeyLength;
#    UInt32    totalNodes;
#    UInt32    freeNodes;
#    UInt16    reserved1;
#    UInt32    clumpSize;      // misaligned
#    UInt8     btreeType;
#    UInt8     keyCompareType;
#    UInt32    attributes;     // long aligned again
#    UInt32    reserved3[16];
#};
#typedef struct BTHeaderRec BTHeaderRec;

use Moose;

has 'treeDepth'=> (is => 'rw', isa => 'Int');
has 'rootNode'=> (is => 'rw', isa => 'Int');
has 'leafRecords'=> (is => 'rw', isa => 'Int');
has 'firstLeafNode'=> (is => 'rw', isa => 'Int');
has 'lastLeafNode'=> (is => 'rw', isa => 'Int');
has 'nodeSize'=> (is => 'rw', isa => 'Int');
has 'maxKeyLength'=> (is => 'rw', isa => 'Int');
has 'totalNodes'=> (is => 'rw', isa => 'Int');
has 'freeNodes'=> (is => 'rw', isa => 'Int');
has 'reserved1'=> (is => 'rw', isa => 'Int');
has 'clumpSize'=> (is => 'rw', isa => 'Int');      # misaligned
has 'btreeType'=> (is => 'rw', isa => 'Int');
has 'keyCompareType'=> (is => 'rw', isa => 'Int');
has 'attributes'=> (is => 'rw', isa => 'Int');     # long aligned again
has 'reserved3'=> (is => 'rw', isa => 'ArrayRef'); 

my $size = 2+4+4+4+4+2+2+4+4+2+4+1+1+4+(4*16);

sub toString
{
  my $self = shift;
  my $r;
  
  $r = "treeDepth: ".$self->treeDepth()."\n";
  $r .= "rootNode: ".$self->rootNode()."\n";
  $r .= "leafRecords: ".$self->leafRecords() ."\n";
  $r .= "firstLeafNode: ".$self->firstLeafNode() ."\n";
  $r .= "lastLeafNode: ".$self->lastLeafNode() ."\n";
  $r .= "nodeSize: ".$self->nodeSize() ."\n";
  $r .= "maxKeyLength: ".$self->maxKeyLength() ."\n";
  $r .= "totalNodes: ".$self->totalNodes() ."\n";
  $r .= "freeNodes: ".$self->freeNodes() ."\n";
  $r .= "reserved1: ".$self->reserved1() ."\n";
  $r .= "clumpSize: ".$self->clumpSize() ."\n";
  $r .= "btreeType: ".$self->btreeType() ."\n";
  $r .= "keyCompareType: ".$self->keyCompareType() ."\n";
  $r .= "attributes: ".$self->attributes() ."\n";
  $r .= "reserved3: ".join(",",@{$self->reserved3()}) ."\n"; 
  return $r;
  
}

sub sane
{
  my $self = shift;
  my $btnd = shift;
  my $r = 1;
  
  if ($self->treeDepth() != $btnd->height()) {
    # warn "depth != height (".$self->treeDepth().", ".$btnd->height().")\n";
  }
  # The current depth of the B-tree. Always equal to the height field of the root node.
  
  
  # The size, in bytes, of a node. This is a power of two, from 512 through 32,768, inclusive.
  # check that nodeSize is a power of two
  my %ok = ( '512' => 1,
          '1024'=> 1,
          '2048'=> 1,
          '4096'=> 1,
          '8192'=> 1,
          '16384'=>1,
          '32768'=>1
        );
  unless ($ok{$self->nodeSize()}) {
    # warn "nodesize: ".$self->nodeSize()." is not a power of two.";
    $r = 0;
  }
  
  my $bt = $self->btreeType();
  if (($bt != 0)&&($bt != 128)&&($bt!=255)) {
    # warn "BTreeType illegal: $bt\n";
    $r = 0;
  }
  
  if ($self->attributes() > 7) {
    # warn "attributes: ".$self->attributes()." illegal.\n";
    $r = 0;
  }
  
  foreach my $a (@{$self->reserved3}) {
    $r = 0 if ($a > 0);
  }
  
  return $r;
}

sub load_from_file
{
  my $self = shift;
  my $fh =  shift;
  
  my $buf;
  $fh->read($buf,$size);
  my $dr = Filesystem::HFS::DataReader->new('buffer' => $buf);
  $self->load_from_datareader($dr);
}


sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  
  $self->treeDepth($dr->UInt16);
  $self->rootNode($dr->UInt32);
  $self->leafRecords($dr->UInt32);
  $self->firstLeafNode($dr->UInt32);
  $self->lastLeafNode($dr->UInt32);
  $self->nodeSize($dr->UInt16);
  $self->maxKeyLength($dr->UInt16);
  $self->totalNodes($dr->UInt32);
  $self->freeNodes($dr->UInt32);
  $self->reserved1($dr->UInt16);
  $self->clumpSize($dr->UInt32);
  $self->btreeType($dr->UInt8);
  $self->keyCompareType($dr->UInt8);
  $self->attributes($dr->UInt32);
  my @r3;
  for (my $i=0;$i<16;$i++) 
  {
    push(@r3,$dr->UInt32);
  }
  $self->reserved3(\@r3);
  
  return $size;
  
}



no Moose;

42;