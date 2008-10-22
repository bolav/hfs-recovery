package Filesystem::HFS::Point;

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
  has 'v' => (is => 'rw', isa => 'Int');
  has 'h' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->v($dr->SInt16());
  $self->h($dr->SInt16());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "v: ".$self->v()."\n";
  $r .= "h: ".$self->h()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius