package Filesystem::HFS::ExtendedFolderInfo;

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

use Filesystem::HFS::Point;
use strict;
use Moose;
  has 'scrollPosition' => (is => 'rw', isa => 'Filesystem::HFS::Point');
  has 'reserved1' => (is => 'rw', isa => 'Int');
  has 'extendedFinderFlags' => (is => 'rw', isa => 'Int');
  has 'reserved2' => (is => 'rw', isa => 'Int');
  has 'putAwayFolderID' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  my $t_scrollPosition = new Filesystem::HFS::Point;
  $t_scrollPosition->load_from_datareader($dr);
  $self->scrollPosition($t_scrollPosition);
  $self->reserved1($dr->SInt32());
  $self->extendedFinderFlags($dr->UInt16());
  $self->reserved2($dr->SInt16());
  $self->putAwayFolderID($dr->SInt32());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "scrollPosition: ".$self->scrollPosition()->toString()."\n";
  $r .= "reserved1: ".$self->reserved1()."\n";
  $r .= "extendedFinderFlags: ".$self->extendedFinderFlags()."\n";
  $r .= "reserved2: ".$self->reserved2()."\n";
  $r .= "putAwayFolderID: ".$self->putAwayFolderID()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius