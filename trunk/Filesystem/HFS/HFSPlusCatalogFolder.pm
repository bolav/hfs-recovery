package Filesystem::HFS::HFSPlusCatalogFolder;

use Filesystem::HFS::HFSPlusBSDInfo;
use Filesystem::HFS::FolderInfo;
use Filesystem::HFS::ExtendedFolderInfo;

#struct HFSPlusCatalogFolder {
#    SInt16              recordType;
#    UInt16              flags;
#    UInt32              valence;
#    HFSCatalogNodeID    folderID;
#    UInt32              createDate;
#    UInt32              contentModDate;
#    UInt32              attributeModDate;
#    UInt32              accessDate;
#    UInt32              backupDate;
#    HFSPlusBSDInfo      permissions;
#    FolderInfo          userInfo;
#    ExtendedFolderInfo  finderInfo;
#    UInt32              textEncoding;
#    UInt32              reserved;
#};
#typedef struct HFSPlusCatalogFolder HFSPlusCatalogFolder;                

use strict;

use Moose;

    has 'recordType'=> (is => 'rw', isa => 'Int');
    has 'flags'=> (is => 'rw', isa => 'Int');
    has 'valence'=> (is => 'rw', isa => 'Int');
    has 'folderID'=> (is => 'rw', isa => 'Int');
    has 'createDate'=> (is => 'rw', isa => 'Int');
    has 'contentModDate'=> (is => 'rw', isa => 'Int');
    has 'attributeModDate'=> (is => 'rw', isa => 'Int');
    has 'accessDate'=> (is => 'rw', isa => 'Int');
    has 'backupDate'=> (is => 'rw', isa => 'Int');
    has 'permissions' => (is => 'rw', isa => 'Filesystem::HFS::HFSPlusBSDInfo');
    has 'userInfo' => (is => 'rw', isa => 'Filesystem::HFS::FolderInfo');
    has 'finderInfo' => (is => 'rw', isa => 'Filesystem::HFS::ExtendedFolderInfo');
    has 'textEncoding'=> (is => 'rw', isa => 'Int');
    has 'reserved'=> (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }
  $self->recordType($dr->SInt16());
  $self->flags($dr->UInt16());
  $self->valence($dr->UInt32());
  $self->folderID($dr->HFSCatalogNodeID());
  $self->createDate($dr->UInt32());
  $self->contentModDate($dr->UInt32());
  $self->attributeModDate($dr->UInt32());
  $self->accessDate($dr->UInt32());
  $self->backupDate($dr->UInt32());

  my $p = new Filesystem::HFS::HFSPlusBSDInfo;
  $p->load_from_datareader($dr);
  $self->permissions($p);
  
  my $fi = new Filesystem::HFS::FolderInfo;
  $fi->load_from_datareader($dr);
  $self->userInfo($fi);

  my $efi = new Filesystem::HFS::ExtendedFolderInfo;
  $efi->load_from_datareader($dr);
  $self->finderInfo($efi);

  $self->textEncoding($dr->UInt32());
  $self->reserved($dr->UInt32());
  
}

sub ls_string
{
  my $self = shift;
  my $r = "[folder]";
}

sub toString 
{
  my $self = shift;
  
  my $r = "recordType: ".$self->recordType()."\n";
  $r .= "flags: ".$self->flags()."\n";
  $r .= "valence: ".$self->valence()."\n";
  $r .= "folderID: ".$self->folderID()."\n";
  $r .= "createDate: ".$self->createDate()."\n";
  $r .= "contentModDate: ".$self->contentModDate()."\n";
  $r .= "attributeModDate: ".$self->attributeModDate()."\n";
  $r .= "accessDate: ".$self->accessDate()."\n";
  $r .= "backupDate: ".$self->backupDate()."\n";
  $r .= "permissions: ".$self->permissions()->toString()."\n";
  $r .= "userInfo: ".$self->userInfo()->toString()."\n";
  $r .= "finderInfo: ".$self->finderInfo()->toString()."\n";
  $r .= "textEncoding: ".$self->textEncoding()."\n";
  $r .= "reserved: ".$self->reserved()."\n";
}


no Moose;

42;
