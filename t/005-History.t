#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 19;
use Data::Dumper;

use vars qw/ $tmp $one /;

use_ok( 'Term::TransKeys' );

$one = Term::TransKeys->new;

is_deeply(
    $one->GetHistory,
    [],
    "History is empty"
);

ok(
    $one->AddHistory(
        [ 'a' .. 'e' ],
        [ 'f' .. 'j' ],
        [ 'k' .. 'p' ],
    ),
    "Adding History"
);

is_deeply(
    $one->GetHistory,
    [
        [ 'a' .. 'e' ],
        [ 'f' .. 'j' ],
        [ 'k' .. 'p' ],
    ],
    "History"
);

is_deeply(
    $one->_GetHistBuff,
    [
        $one->_GetBuffer,
        [ 'a' .. 'e' ],
        [ 'f' .. 'j' ],
        [ 'k' .. 'p' ],
    ],
    "History Buffer",
);

is( $one->_HistPos, 0, "Starts at 0" );
is( $one->_HistPos( 1 ), 1, "Moved by 1" );
is( $one->_HistPos( 1 ), 2, "Moved by 1 again" );
is( $one->_HistPos( -2 ), 0, "Moved by -2" );
is( $one->_HistPos( -100 ), 0, "First" );
is( $one->_HistPos( 100 ), 3, "Last" );
ok( $one->_ClearHistBuff, "Clear the history" );

ok( $one->HistoryLength, "History has a length" );
is( $one->HistoryLength( 0 ), 1, "History has a length" );
is( $one->HistoryLength( -1 ), 1, "History has a length" );
is( $one->HistoryLength( 3 ), 3, "History has a length of 3" );
ok(
    $one->AddHistory(
        [ 'a' .. 'e' ],
        [ 'f' .. 'j' ],
        [ 'k' .. 'p' ],
        [ 'l' .. 'o' ],
        [ 'x' .. 'z' ],
    ),
    "Adding History"
);
is( @{ $one->GetHistory }, 3, "History Length enforced" );
is_deeply(
    $one->GetHistory,
    [
        [ 'a' .. 'e' ],
        [ 'f' .. 'j' ],
        [ 'k' .. 'p' ],
    ],
    "History is correct"
);
