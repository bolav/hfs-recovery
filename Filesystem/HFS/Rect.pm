package Filesystem::HFS::Rect;

use strict;
use Moose;
  has 'top' => (is => 'rw', isa => 'Int');
  has 'left' => (is => 'rw', isa => 'Int');
  has 'bottom' => (is => 'rw', isa => 'Int');
  has 'right' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->top($dr->SInt16());
  $self->left($dr->SInt16());
  $self->bottom($dr->SInt16());
  $self->right($dr->SInt16());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "top: ".$self->top()."\n";
  $r .= "left: ".$self->left()."\n";
  $r .= "bottom: ".$self->bottom()."\n";
  $r .= "right: ".$self->right()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius