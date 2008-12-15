#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 35;
use Data::Dumper;

use vars qw/ $tmp $one /;

use_ok( 'Term::TransKeys' );

like( $Term::TransKeys::KEYMAP->{ $_ }, qr/<CONTROL\+[A-Z]>|<ENTER>/ ,"Check control key: $_ : " . $Term::TransKeys::KEYMAP->{ $_ } ) for ( 1 .. 26 );

sub MyAction {
    return 'MyAction';
}

$one = Term::TransKeys->new(
    history_length => 25,
    history => [ 'aaaa', 'bbbb' ],
    actions => {
        '<F1>' => \&MyAction,
        '<ENTER>' => \&MyAction,
    }
);

isa_ok( $one, 'Term::TransKeys', "Created correct object type" );

ok( defined $one->Actions->{ '<ESCAPE>' }, "Did not remove defaults" );
is( $one->Actions->{ '<F1>' }->(), 'MyAction', "Added F1 Action" );
is( $one->Actions->{ '<ENTER>' }->(), 'MyAction', "Overrode <ENTER>" );
is( $one->HistoryLength, 25, "History Length Saved" );
is_deeply(
    $one->GetHistory,
    [
        'aaaa',
        'bbbb',
    ],
    "History recorded"
);

ok( $one->Actions->{ '<F2>' } = \&MyAction, "Override action" );
is( $one->Actions->{ '<F2>' }->(), 'MyAction', "Added F2 Action" );
