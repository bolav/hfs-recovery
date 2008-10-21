package Filesystem::HFS::HFSPlusCatalogKey;

#struct HFSPlusCatalogKey {
#    UInt16              keyLength;
#    HFSCatalogNodeID    parentID;
#    HFSUniStr255        nodeName;
#};
#typedef struct HFSPlusCatalogKey HFSPlusCatalogKey;

import Filesystem::HFS::DataReader;

use strict;

use Moose;

has 'keyLength' => (is => 'rw', isa => 'Int');
has 'parentID' => (is => 'rw', isa => 'Int');
has 'nodeName' => (is => 'rw', isa => 'Str');

sub toString
{
}

sub ls_string
{
  my $self = shift;
  return "p:".$self->parentID().
         ", \"".$self->nodeName()."\"";

}

sub load_from_file
{
  my $self = shift;
  my $fh =  shift;
  
  die "Not implemented.";
  #my $buf;
  #$fh->read($buf,$size);
  #my $dr = Filesystem::HFS::DataReader->new('buffer' => $buf);
  #$self->load_from_datareader($dr);
}

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }
  $self->keyLength($dr->UInt16());
  $self->parentID($dr->HFSCatalogNodeID());
  $self->nodeName($dr->HFSUniStr255());
  
  return $self->keyLength;
  
}

no Moose;

42;

