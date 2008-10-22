package Filesystem::HFS::Rect;

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
  has 'top' => (is => 'rw', isa => 'Int');
  has 'left' => (is => 'rw', isa => 'Int');
  has 'bottom' => (is => 'rw', isa => 'Int');
  has 'right' => (is => 'rw', isa => 'Int');

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  my $pos = shift;
  
  if ($pos) {
    $dr->pos($pos);
  }

  $self->top($dr->SInt16());
  $self->left($dr->SInt16());
  $self->bottom($dr->SInt16());
  $self->right($dr->SInt16());
};

sub toString
{
  my $self = shift;
  my $r = "";
  $r .= "top: ".$self->top()."\n";
  $r .= "left: ".$self->left()."\n";
  $r .= "bottom: ".$self->bottom()."\n";
  $r .= "right: ".$self->right()."\n";
  return $r;
};
no Moose;
68; # The age of Aquarius