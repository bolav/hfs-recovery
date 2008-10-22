package Filesystem::HFS::HFSPlusForkData;

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

use Math::BigInt;
use Filesystem::HFS::HFSPlusExtentRecord;
use strict;
use Moose;
  has 'logicalSize' => (is => 'rw', isa => 'Math::BigInt');
  has 'clumpSize' => (is => 'rw', isa => 'Int');
  has 'totalBlocks' => (is => 'rw', isa => 'Int');
  has 'extents' => (is => 'rw', isa => 'Filesystem::HFS::HFSPlusExtentRecord');
  

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->logicalSize($dr->UInt64());
  $self->clumpSize($dr->UInt32());
  $self->totalBlocks($dr->UInt32());
  my $t_extents = new Filesystem::HFS::HFSPlusExtentRecord;
  $t_extents->load_from_datareader($dr);
  $self->extents($t_extents);
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "logicalSize: ".$self->logicalSize()."\n";
  $r .= "clumpSize: ".$self->clumpSize()."\n";
  $r .= "totalBlocks: ".$self->totalBlocks()."\n";
  $r .= "extents: ".$self->extents()->toString()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius