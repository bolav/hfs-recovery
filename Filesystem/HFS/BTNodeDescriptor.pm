package Filesystem::HFS::BTNodeDescriptor;

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

import Filesystem::HFS::DataReader;

#struct BTNodeDescriptor {
#    UInt32    fLink;
#    UInt32    bLink;
#    SInt8     kind;
#    UInt8     height;
#    UInt16    numRecords;
#    UInt16    reserved;
#};
#typedef struct BTNodeDescriptor BTNodeDescriptor;

use constant BT_HEADER_NODE => 1;
use constant BT_LEAF_NODE => -1;

use strict;

use Moose;

has 'fLink' => (is => 'rw', isa => 'Int'); # Use UInt32 or Int?
has 'bLink' => (is => 'rw', isa => 'Int');
has 'kind' => (is => 'rw', isa => 'Int');
has 'height' => (is => 'rw', isa => 'Int');
has 'numRecords' => (is => 'rw', isa => 'Int');
has 'reserved' => (is => 'rw', isa => 'Int');

my $size = 14;

sub toString
{
  my $self = shift;
  my $r;
  
  $r = "fLink: ".$self->fLink()."\n";
  $r .= "bLink: ".$self->bLink()."\n";
  $r .= "kind: ".$self->kind()."\n";
  $r .= "height: ".$self->height()."\n";
  $r .= "numRecords: ".$self->numRecords()."\n";
  $r .= "reserved: ".$self->reserved()."\n";
  return $r;  
}

sub sane 
{
  my $self = shift;
  my $r = 1;
  
  if (($self->kind() > 2)||($self->kind() < -1))
  {
    # warn "kind is not legal. ".$self->kind();
    $r = 0;
  }
  
  if (($self->kind() == 1) && ($self->height() != 0))
  {
    # warn "height must be zero on headernodes";
    $r = 0;
  }
  
  if (($self->kind() == -1) && ($self->height() != 1)) 
  {
    # warn "height must be one on leafnodes";
    $r  = 0;
  }
  
  return $r;
    
}

sub load_from_file
{
  my $self = shift;
  my $fh =  shift;
  
  my $buf;
  $fh->read($buf,$size);
  my $dr = Filesystem::HFS::DataReader->new('buffer' => $buf);
  $self->load_from_datareader($dr);
}

sub load_from_datareader
{
  my $self = shift;
  my $dr = shift;
  
  $self->fLink($dr->UInt32);
  $self->bLink($dr->UInt32);
  $self->kind($dr->SInt8);
  $self->height($dr->UInt8);
  $self->numRecords($dr->UInt16);
  $self->reserved($dr->UInt16);
  
  return $size;
  
}

no Moose;

42;

