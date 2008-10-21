package Filesystem::HFS::HFSPlusExtentDescriptor;

use strict;
use Moose;
  has 'startBlock' => (is => 'rw', isa => 'Int');
  has 'blockCount' => (is => 'rw', isa => 'Int');

use constant size => 8;

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->startBlock($dr->UInt32());
  $self->blockCount($dr->UInt32());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "startBlock: ".$self->startBlock()."\n";
  $r .= "blockCount: ".$self->blockCount()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius
