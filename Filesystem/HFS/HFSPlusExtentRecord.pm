package Filesystem::HFS::HFSPlusExtentRecord;

use Filesystem::HFS::HFSPlusExtentDescriptor;

use strict;
use Moose;
  has 'extentDescriptors' => (is => 'rw', isa => 'ArrayRef');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }
  
  my @t_eds;
  for (my $i=0;$i<8;$i++) {
    my $t_ed = new Filesystem::HFS::HFSPlusExtentDescriptor;
    $t_ed->load_from_datareader($dr);
    push(@t_eds,$t_ed);
  }
  $self->extentDescriptors(\@t_eds);
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "extentDescriptors: ";
  foreach my $t_ed (@{$self->extentDescriptors()}) {
    $r .= $t_ed->toString().",";
  }
  $r .= "\n";
  return $r;
};
no Moose;
68; # The age of Aquarius
