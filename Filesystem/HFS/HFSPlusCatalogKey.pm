package Filesystem::HFS::HFSPlusCatalogKey;

#    This file is part of hfs-recovery.
#
#    hfs-recovery is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    hfs-recovery is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with hfs-recovery.  If not, see <http://www.gnu.org/licenses/>.
#
#    Bjorn-Olav Strand <bo@startsiden.no>

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

