package Filesystem::HFS::HFSPlusBSDInfo;

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

use strict;
use Moose;
  has 'ownerID' => (is => 'rw', isa => 'Int');
  has 'groupID' => (is => 'rw', isa => 'Int');
  has 'adminFlags' => (is => 'rw', isa => 'Int');
  has 'ownerFlags' => (is => 'rw', isa => 'Int');
  has 'fileMode' => (is => 'rw', isa => 'Int');
  has 'special' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->ownerID($dr->UInt32());
  $self->groupID($dr->UInt32());
  $self->adminFlags($dr->UInt8());
  $self->ownerFlags($dr->UInt8());
  $self->fileMode($dr->UInt16());
  $self->special($dr->UInt32());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "ownerID: ".$self->ownerID()."\n";
  $r .= "groupID: ".$self->groupID()."\n";
  $r .= "adminFlags: ".$self->adminFlags()."\n";
  $r .= "ownerFlags: ".$self->ownerFlags()."\n";
  $r .= "fileMode: ".sprintf("%o",$self->fileMode())."\n";
  $r .= "special: ".$self->special()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius