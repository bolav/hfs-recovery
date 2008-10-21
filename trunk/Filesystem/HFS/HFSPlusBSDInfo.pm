package Filesystem::HFS::HFSPlusBSDInfo;

use strict;
use Moose;
  has 'ownerID' => (is => 'rw', isa => 'Int');
  has 'groupID' => (is => 'rw', isa => 'Int');
  has 'adminFlags' => (is => 'rw', isa => 'Int');
  has 'ownerFlags' => (is => 'rw', isa => 'Int');
  has 'fileMode' => (is => 'rw', isa => 'Int');
  has 'special' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->ownerID($dr->UInt32());
  $self->groupID($dr->UInt32());
  $self->adminFlags($dr->UInt8());
  $self->ownerFlags($dr->UInt8());
  $self->fileMode($dr->UInt16());
  $self->special($dr->UInt32());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "ownerID: ".$self->ownerID()."\n";
  $r .= "groupID: ".$self->groupID()."\n";
  $r .= "adminFlags: ".$self->adminFlags()."\n";
  $r .= "ownerFlags: ".$self->ownerFlags()."\n";
  $r .= "fileMode: ".sprintf("%o",$self->fileMode())."\n";
  $r .= "special: ".$self->special()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius