package Filesystem::HFS::ExtendedFileInfo;

use strict;
use Moose;
  has 'reserved1' => (is => 'rw', isa => 'ArrayRef');
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

  my @t_reserved1;
  for (my $i=0;$i<4;$i++) {
    push(@t_reserved1,$dr->SInt16());
  }
  $self->reserved1(\@t_reserved1);
  $self->extendedFinderFlags($dr->UInt16());
  $self->reserved2($dr->SInt16());
  $self->putAwayFolderID($dr->SInt32());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "SInt16: ".join(",",@{$self->reserved1})."\n";
  $r .= "extendedFinderFlags: ".$self->extendedFinderFlags()."\n";
  $r .= "reserved2: ".$self->reserved2()."\n";
  $r .= "putAwayFolderID: ".$self->putAwayFolderID()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius