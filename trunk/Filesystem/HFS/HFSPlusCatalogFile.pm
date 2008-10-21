package Filesystem::HFS::HFSPlusCatalogFile;

use Filesystem::HFS::HFSPlusBSDInfo;
use Filesystem::HFS::FileInfo;
use Filesystem::HFS::ExtendedFileInfo;
use Filesystem::HFS::HFSPlusForkData;

#struct HFSPlusCatalogFile {
#    SInt16              recordType;
#    UInt16              flags;
#    UInt32              reserved1;
#    HFSCatalogNodeID    fileID;
#    UInt32              createDate;
#    UInt32              contentModDate;
#    UInt32              attributeModDate;
#    UInt32              accessDate;
#    UInt32              backupDate;
#    HFSPlusBSDInfo      permissions;
#    FileInfo            userInfo;
#    ExtendedFileInfo    finderInfo;
#    UInt32              textEncoding;
#    UInt32              reserved2;
# 
#    HFSPlusForkData     dataFork;
#    HFSPlusForkData     resourceFork;
#};
#typedef struct HFSPlusCatalogFile HFSPlusCatalogFile;

use strict;

use Moose;

    has 'recordType'=> (is => 'rw', isa => 'Int');
    has 'flags'=> (is => 'rw', isa => 'Int');
    has 'reserved1'=> (is => 'rw', isa => 'Int');
    has 'fileID'=> (is => 'rw', isa => 'Int');
    has 'createDate'=> (is => 'rw', isa => 'Int');
    has 'contentModDate'=> (is => 'rw', isa => 'Int');
    has 'attributeModDate'=> (is => 'rw', isa => 'Int');
    has 'accessDate'=> (is => 'rw', isa => 'Int');
    has 'backupDate'=> (is => 'rw', isa => 'Int');
    has 'permissions'=> (is => 'rw', isa => 'Filesystem::HFS::HFSPlusBSDInfo');
    has 'userInfo'=> (is => 'rw', isa => 'Filesystem::HFS::FileInfo');
    has 'finderInfo'=> (is => 'rw', isa => 'Filesystem::HFS::ExtendedFileInfo');
    has 'textEncoding'=> (is => 'rw', isa => 'Int');
    has 'reserved2'=> (is => 'rw', isa => 'Int');
 
    has 'dataFork' => (is => 'rw', isa =>'Filesystem::HFS::HFSPlusForkData');
    has 'resourceFork' => (is => 'rw', isa =>'Filesystem::HFS::HFSPlusForkData');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }
  my $in = $dr->pos();
  
  $self->recordType($dr->SInt16());
  $self->flags($dr->UInt16());
  $self->reserved1($dr->UInt32());
  $self->fileID($dr->HFSCatalogNodeID());
  $self->createDate($dr->UInt32());
  $self->contentModDate($dr->UInt32());
  $self->attributeModDate($dr->UInt32());
  $self->accessDate($dr->UInt32());
  $self->backupDate($dr->UInt32());

  my $f = $dr->pos()-$in;
  my $p = new Filesystem::HFS::HFSPlusBSDInfo;
  $p->load_from_datareader($dr);
  $self->permissions($p);
  
  my $fi = new Filesystem::HFS::FileInfo;
  $fi->load_from_datareader($dr);
  $self->userInfo($fi);

  my $efi = new Filesystem::HFS::ExtendedFileInfo;
  $efi->load_from_datareader($dr);
  $self->finderInfo($efi);

  $self->textEncoding($dr->UInt32());
  $self->reserved2($dr->UInt32());

  
  my $df = new Filesystem::HFS::HFSPlusForkData;
  $df->load_from_datareader($dr);
  $self->dataFork($df);

  my $rf = new Filesystem::HFS::HFSPlusForkData;
  $rf->load_from_datareader($dr);
  $self->resourceFork($rf);

  my $used = $dr->pos()-$in;
  
}

sub ls_string
{
  my $self = shift;
  my $r = "[file] size: ".$self->dataFork()->logicalSize()." blocks: ".$self->dataFork()->totalBlocks();
}

sub toString 
{
  my $self = shift;
  
  my $r = "recordType: ".$self->recordType()."\n";
  $r .= "flags: ".$self->flags()."\n";
  $r .= "reserved1: ".$self->reserved1()."\n";
  $r .= "fileID: ".$self->fileID()."\n";
  $r .= "createDate: ".$self->createDate()."\n";
  $r .= "contentModDate: ".$self->contentModDate()."\n";
  $r .= "attributeModDate: ".$self->attributeModDate()."\n";
  $r .= "accessDate: ".$self->accessDate()."\n";
  $r .= "backupDate: ".$self->backupDate()."\n";
  $r .= "permissions: ".$self->permissions()->toString()."\n";
  $r .= "userInfo: ".$self->userInfo()->toString()."\n";
  $r .= "finderInfo: ".$self->finderInfo()->toString()."\n";
  $r .= "textEncoding: ".$self->textEncoding()."\n";
  $r .= "reserved2: ".$self->reserved2()."\n";
  $r .= "dataFork: ".$self->dataFork()->toString()."\n";
  $r .= "resourceFork: ".$self->resourceFork()->toString()."\n";

}


no Moose;

42;
