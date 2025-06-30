#!perl
use 5.010;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Portable::BinPaths' ) || print "Bail out!\n";
}

diag( "Testing Portable::BinPaths $Portable::BinPaths::VERSION, Perl $], $^X" );


#  Not much here...
