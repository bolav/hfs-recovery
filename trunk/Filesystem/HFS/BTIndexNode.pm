package Filesystem::HFS::BTIndexNode;

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
      