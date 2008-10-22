package Filesystem::HFS::DataReader;

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

use Encode qw/encode decode/; 
use Math::BigInt;

use strict;

use Moose;

has 'pos' => (is => 'rw', isa => 'Int');
has 'buffer' => (is => 'rw', isa => 'Str');


sub BUILD
{
  my $self = shift;
  
  my $t = shift;
  $self->pos(0);
  
}

sub pos_inc 
{
  my $self = shift;
  my $inc = shift;
  $self->pos($self->pos()+$inc);
}

sub HFSUniStr255 {
  my $self = shift;
  my $n = $self->UInt16();
  if ($n > 255) {
    warn "Invalid stringlength $n\n";
    return "";
  }
  #print "$i: $n\n";
  my $v = substr($self->buffer(),$self->pos(),$n*2);
  my $utf8 = decode("UCS-2BE", $v);
  $self->pos_inc($n*2);
  return $utf8;
}

sub HFSCatalogNodeID {
  my $self = shift;
  return $self->UInt32();
}

sub OSType {
  my $self = shift;
  my $t = substr($self->buffer(),$self->pos(),4);
  $self->pos_inc(4);
  return $t;
}

sub SInt8()
{
  my $self = shift;
  my $t = substr($self->buffer(),$self->pos(),1);
  my $v = unpack("c",$t);
  $self->pos_inc(1);
  return $v;
}

sub UInt8() 
{
  my $self = shift;
  my $t = substr($self->buffer(),$self->pos(),1);
  my $v = unpack("C",$t);
  $self->pos_inc(1);
  return $v;
}

sub SInt16() {
  my $self = shift;
  my $t = substr($self->buffer(),$self->pos(),2);
  my $v = unpack("n",$t);
  $self->pos_inc(2);
  return $v;
}

sub UInt16() {
  my $self = shift;
  my $t = substr($self->buffer(),$self->pos(),2);
  my $v = unpack("n",$t);
  $self->pos_inc(2);
  return $v;
}

sub SInt32() {
  my $self = shift;
  my $t = substr($self->buffer(),$self->pos(),4);
  my $v = unpack("N",$t);
  $self->pos_inc(4);
  return $v;
}

sub UInt32() {
  my $self = shift;
  my $t = substr($self->buffer(),$self->pos(),4);
  my $v = unpack("N",$t);
  $self->pos_inc(4);
  return $v;
}

sub UInt64() {
  my $self = shift;
  my $t = substr($self->buffer(),$self->pos(),8);
  $self->pos_inc(8);

  my ($int1,$int2)=unpack('NN',$t);
  my $i=new Math::BigInt $int1;
  $i*=2**32;
  $i+=$int2;
  return $i;
}

sub UInt16_off {
  my $buf = shift;
  my $off = shift;
  my $t = substr($buf, $off, 2);
  my $v = unpack("n",$t);
  return $v;
}

no Moose;

42;

