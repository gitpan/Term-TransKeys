#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 27;
use Data::Dumper;

use vars qw/ $tmp $one /;

use_ok( 'Term::TransKeys' );

$one = Term::TransKeys->new;

ok( $one->BufferEmpty, "Buffer is empty" );
is( $one->_ShiftBuffer, undef, "Empty buffer gives us no key." );
ok( $one->_PushBuffer( qw/ a b c d e f g h i j k l /), "Add to the buffer");
ok(( not $one->BufferEmpty ), "Buffer is not empty" );
is( $one->BufferString, 'abcdefghijkl', "Buffer is right" );

is( $one->_ShiftBuffer, 'a', "Got first key in buffer." );
is( $one->BufferString, 'bcdefghijkl', "Buffer is right" );
is_deeply( $one->_GetBuffer, [ qw/ b c d e f g h i j k l /], "Check GetBuffer" );

$one->{ _buff_pos_inv } = 100;
$one->{ _buff_pos } = 100;
ok( $one->_ResetBuffer, "Resetting the buffer" );
is( $one->{ _buff_pos_inv }, undef, "No position" );
is( $one->{ _buff_pos }, undef, "No position" );
is_deeply( $one->_GetBuffer, [ ], "Empty Buffer" );
ok( $one->BufferEmpty, "Buffer is empty" );

is( $one->BufferPosition, 0, "Buffer position is 0" );
is( $one->_BufferPosition, 0, "_BufferPosition no args" );

my $buff = [ qw/ a b c d /];
is( $one->_BufferPosition( 0, $buff ), 4, "Start at end" );
is( $one->_BufferPosition( 1, $buff ), 3, "Move left by 1" );
is( $one->_BufferPosition( 2, $buff ), 1, "Move left by 2" );
is( $one->_BufferPosition( -1, $buff ), 2, "Move right by 1" );
is( $one->_BufferPosition( -2, $buff ), 4, "Move right by 2" );
is( $one->_BufferPosition( -100, $buff ), 4, "Move left by too many" );
is( $one->_BufferPosition( 100, $buff ), 0, "Move right by too many" );
is( $one->_BufferPosition( -2, $buff ), 2, "Move right by too many" );
is( $one->_BufferPosition( 0, [ @$buff, 'z' ]), 3, "same place, added char." );
is( $one->_BufferPosition( 0, $buff ), 2, "same place, deleted char." );
is( $one->BufferPosition, 2, "Buffer position is 2" );
