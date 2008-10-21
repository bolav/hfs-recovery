package Filesystem::HFS::BTNode;

use Moose;

has 'nodeDescriptor' => (is => 'rw', isa => 'Filesystem::HFS::BTNodeDescriptor');

sub BUILD
{
  my $self = shift;
  my $h = shift;
  
  unless ($h->{'nodeDescriptor'}) {
    warn "No nodedescriptor\n";
  }
}

no Moose;

42;