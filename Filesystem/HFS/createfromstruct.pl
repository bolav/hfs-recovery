#!/usr/bin/perl

while (<>) {

  if (/struct (.*) \{/) {
    $name = $1;
  } elsif (
           (/UInt8\s+(\w+)\;/) ||
           (/UInt16\s+(\w+)\;/) ||
           (/UInt32\s+(\w+)\;/) ||
           (/UInt64\s+(\w+)\;/) ||
           (/SInt16\s+(\w+)\;/) ||
           (/SInt32\s+(\w+)\;/) ||
           (/Rect\s+(\w+)\;/) ||
           (/Point\s+(\w+)\;/) ||
           (/OSType\s+(\w+)\;/) ||
           (/SInt16\s+(\w+)\[\d+\]\;/) 
           
          ) {
    push(@v,$_);
  } else {
    print "Dont understand $_";
  }
  
}

print "package Filesystem::HFS::$name;\n\n";


foreach $_ (@v) {
  if (
      (/(Rect)\s+(\w+)\;/) ||
      (/(Point)\s+(\w+)\;/)
     ) { 
    print "use Filesystem::HFS::$1;\n";
  } elsif (
           (/UInt64\s+(\w+)\;/)
          ) {
    print "use Math::BigInt;\n";
  }
}

print "use strict;\n";
print "use Moose;\n";

foreach $_ (@v) {
  if (
      (/UInt8\s+(\w+)\;/) ||
      (/UInt16\s+(\w+)\;/) ||
      (/UInt32\s+(\w+)\;/) ||
      (/SInt16\s+(\w+)\;/) ||
      (/SInt32\s+(\w+)\;/) 
     ) {
    print "  has '$1' => (is => 'rw', isa => 'Int');\n";
  } elsif (/SInt16\s+(\w+)\[\d\]\;/) {
    print "  has '$1' => (is => 'rw', isa => 'ArrayRef');\n";
  } elsif (/UInt64\s+(\w+)\;/) {
    print "  has '$1' => (is => 'rw', isa => 'Math::BigInt');\n";
  } elsif (/OSType\s+(\w+)\;/) {
    print "  has '$1' => (is => 'rw', isa => 'Str');\n";
  } elsif (
           (/(Rect)\s+(\w+)\;/) ||
           (/(Point)\s+(\w+)\;/) 
          ) {
    print "  has '$2' => (is => 'rw', isa => 'Filesystem::HFS::$1');\n";
  }
  
}

print "
sub load_from_datareader
{
  my \$self = shift;
  my \$dr = shift;
  my \$pos = shift;
  
  if (\$pos) {
    \$dr->pos(\$pos);
  }

";

foreach $_ (@v) {
  if (
      (/(UInt8)\s+(\w+)\;/)||
      (/(UInt16)\s+(\w+)\;/)||
      (/(UInt32)\s+(\w+)\;/)||
      (/(UInt64)\s+(\w+)\;/)||
      (/(SInt16)\s+(\w+)\;/)||
      (/(SInt32)\s+(\w+)\;/)||
      (/(OSType)\s+(\w+)\;/)
     ) {
    print "  \$self->$2(\$dr->$1());\n";
  } elsif (/(SInt16)\s+(\w+)\[(\d+)\]\;/) {
    print "  my \@t_$2;\n";
    print "  for (my \$i=0;\$i<$3;\$i++) {\n";
    print "    push(\@t_$2,\$dr->$1());\n";
    print "  }\n";
    print "  \$self->$2(\\\@t_$2);\n";
  } elsif (
           (/(Rect)\s+(\w+)\;/)||
           (/(Point)\s+(\w+)\;/)
          ) {
    print "  my \$t_$2 = new Filesystem::HFS::$1;\n";
    print "  \$t_$2->load_from_datareader(\$dr);\n";
    print "  \$self->$2(\$t_$2);\n";
  }
  
}

print "};\n";

print "
sub toString
{
  my \$self = shift;
  my \$r = \"\";
";

foreach $_ (@v) {
  if ((/UInt32\s+(\w+)\;/)||
      (/UInt8\s+(\w+)\;/)||
      (/UInt16\s+(\w+)\;/)||
      (/UInt64\s+(\w+)\;/)||
      (/SInt16\s+(\w+)\;/)||
      (/SInt32\s+(\w+)\;/)||
      (/OSType\s+(\w+)\;/)
     ) {
    print "  \$r .= \"$1: \".\$self->$1().\"\\n\";\n";
  } elsif (/(SInt16)\s+(\w+)\[(\d+)\]\;/) {
    print "  \$r .= \"$2: \".join(\",\",\@{\$self->$2}).\"\\n\";\n";
  } elsif (
           (/(Rect)\s+(\w+)\;/) ||
           (/(Point)\s+(\w+)\;/) 
          ) {
    print "  \$r .= \"$2: \".\$self->$2()->toString().\"\\n\";\n";
  }
  
}
print "  return \$r;\n";
print "};\n";

print "no Moose;\n";
print "68; # The age of Aquarius";
