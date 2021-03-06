package Filesystem::HFS::FileInfo;

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
  has 'fileType' => (is => 'rw', isa => 'Str');
  has 'fileCreator' => (is => 'rw', isa => 'Str');
  has 'finderFlags' => (is => 'rw', isa => 'Int');
  has 'location' => (is => 'rw', isa => 'Filesystem::HFS::Point');
  has 'reservedField' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->fileType($dr->OSType());
  $self->fileCreator($dr->OSType());
  $self->finderFlags($dr->UInt16());
  my $t_location = new Filesystem::HFS::Point;
  $t_location->load_from_datareader($dr);
  $self->location($t_location);
  $self->reservedField($dr->UInt16());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "fileType: ".$self->fileType()."\n";
  $r .= "fileCreator: ".$self->fileCreator()."\n";
  $r .= "finderFlags: ".$self->finderFlags()."\n";
  $r .= "location: ".$self->location()->toString()."\n";
  $r .= "reservedField: ".$self->reservedField()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius