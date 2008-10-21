package Filesystem::HFS::HFSPlusCatalogIndexNode;

use Moose;

extends 'Filesystem::HFS::BTIndexNode';

sub BUILD
{
  my $self = shift;
  my $o = shift;
  for (my $i = 0; $i < $self->nodeDescriptor()->numRecords(); $i++) {
    warn "Should be reading. Not implemented.";
    exit (0);
  }
}

no Moose;

42;