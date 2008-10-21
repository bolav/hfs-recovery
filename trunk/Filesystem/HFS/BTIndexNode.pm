package Filesystem::HFS::BTIndexNode;

use Moose;

extends 'Filesystem::HFS::BTNode';

has 'offsets' => (is => 'rw', isa => 'ArrayRef');

sub BUILD
{
  my $self = shift;
  my $o = shift;
  my @off;
  for (my $i = 0; $i < ($self->nodeDescriptor()->numRecords()+1); $i++) {
    push(@off,$o->{'datareader'}->UInt16());
  }
  $self->offsets(\@off);
}


no Moose;
      
42;
      