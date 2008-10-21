package Filesystem::HFS::Point;

use strict;
use Moose;
  has 'v' => (is => 'rw', isa => 'Int');
  has 'h' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->v($dr->SInt16());
  $self->h($dr->SInt16());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "v: ".$self->v()."\n";
  $r .= "h: ".$self->h()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius