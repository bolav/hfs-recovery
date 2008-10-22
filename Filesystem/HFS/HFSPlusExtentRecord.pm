package Filesystem::HFS::HFSPlusExtentRecord;

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
