package Filesystem::HFS::FileInfo;

use Filesystem::HFS::Point;
use strict;
use Moose;
  has 'fileType' => (is => 'rw', isa => 'Str');
  has 'fileCreator' => (is => 'rw', isa => 'Str');
  has 'finderFlags' => (is => 'rw', isa => 'Int');
  has 'location' => (is => 'rw', isa => 'Filesystem::HFS::Point');
  has 'reservedField' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->fileType($dr->OSType());
  $self->fileCreator($dr->OSType());
  $self->finderFlags($dr->UInt16());
  my $t_location = new Filesystem::HFS::Point;
  $t_location->load_from_datareader($dr);
  $self->location($t_location);
  $self->reservedField($dr->UInt16());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "fileType: ".$self->fileType()."\n";
  $r .= "fileCreator: ".$self->fileCreator()."\n";
  $r .= "finderFlags: ".$self->finderFlags()."\n";
  $r .= "location: ".$self->location()->toString()."\n";
  $r .= "reservedField: ".$self->reservedField()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius