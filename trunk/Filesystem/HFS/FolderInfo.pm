package Filesystem::HFS::FolderInfo;

use Filesystem::HFS::Rect;
use Filesystem::HFS::Point;
use strict;
use Moose;
  has 'windowBounds' => (is => 'rw', isa => 'Filesystem::HFS::Rect');
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

  my $t_windowBounds = new Filesystem::HFS::Rect;
  $t_windowBounds->load_from_datareader($dr);
  $self->windowBounds($t_windowBounds);
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
  $r .= "windowBounds: ".$self->windowBounds()->toString()."\n";
  $r .= "finderFlags: ".$self->finderFlags()."\n";
  $r .= "location: ".$self->location()->toString()."\n";
  $r .= "reservedField: ".$self->reservedField()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius