package Filesystem::HFS::ExtendedFolderInfo;

use Filesystem::HFS::Point;
use strict;
use Moose;
  has 'scrollPosition' => (is => 'rw', isa => 'Filesystem::HFS::Point');
  has 'reserved1' => (is => 'rw', isa => 'Int');
  has 'extendedFinderFlags' => (is => 'rw', isa => 'Int');
  has 'reserved2' => (is => 'rw', isa => 'Int');
  has 'putAwayFolderID' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  my $t_scrollPosition = new Filesystem::HFS::Point;
  $t_scrollPosition->load_from_datareader($dr);
  $self->scrollPosition($t_scrollPosition);
  $self->reserved1($dr->SInt32());
  $self->extendedFinderFlags($dr->UInt16());
  $self->reserved2($dr->SInt16());
  $self->putAwayFolderID($dr->SInt32());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "scrollPosition: ".$self->scrollPosition()->toString()."\n";
  $r .= "reserved1: ".$self->reserved1()."\n";
  $r .= "extendedFinderFlags: ".$self->extendedFinderFlags()."\n";
  $r .= "reserved2: ".$self->reserved2()."\n";
  $r .= "putAwayFolderID: ".$self->putAwayFolderID()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius