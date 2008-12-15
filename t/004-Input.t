#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 64;
use Data::Dumper;

use vars qw/ $tmp $one /;

use_ok( 'Term::TransKeys' );

$one = Term::TransKeys->new;

diag "Will timeout in 30 seconds \n";
diag "Do you want to run the complete keystroke test? [y/n]: ";
my $key = $one->TransKey( 30 );
if ( $key and $key =~ m/^y/i ) {
    diag "\nTesting all keys";
    no warnings;
    for my $human ( sort values %$Term::TransKeys::KEYMAP ) {
        diag "Press the $human key(s): ";
        my $key = $one->TransKey;
        is( $key, $human, "\nGot the correct responce: $human\n" );
    }
}
else {
    SKIP: {
        skip "Decided not to test all keys", 51;
    }
}

$one->_PushBuffer( qw/ a b c d e /);
is( $one->TransKey, 'a', "Got 'a'" );
is( $one->TransKey, 'b', "Got 'b'" );
is( $one->TransKey, 'c', "Got 'c'" );
is( $one->TransKey, 'd', "Got 'd'" );
is( $one->TransKey, 'e', "Got 'e'" );

$one->_PushBuffer( qw/ a b c d e <ENTER>/);
is( $one->ActionRead, "abcde", "Got Line" );

$one->_PushBuffer( qw/ a b c d e <ENTER> a b c d e <CONTROL+D> /);
is(
    $one->ActionRead(
        end => '__TERM__',
    ),
    "abcde\nabcde",
    "Got Line"
);
$one->_PushBuffer( qw/ a b c d e <F1> <ESCAPE> <CONTROL+D>/);
is(
    $one->ActionRead(
        actions => {
            '<F1>' => sub {
                my ( $self, $keys ) = @_;
                push @$keys => 'X';
            },
            '<ESCAPE>' => sub {
                my ( $self, $keys ) = @_;
                push @$keys => 'Y';
            },
        }
    ),
    "abcdeXY",
    "Added F1 and overrode ESCAPE"
);
is_deeply( $one->GetHistory->[0], [ qw/ a b c d e X Y /], "Recorded to history" );

$one->_PushBuffer( qw/ a b c d e /);
is( my $position = $one->_BufferPosition( 0, $one->_GetBuffer ), 5 );
$one->_PushBuffer( qw/ <LEFT> <LEFT> <LEFT> /);
$one->ActionRead( mode => -1 );
is( $one->BufferPosition, 2, "Buffer position moving left works" );
$one->ActionRead( mode => -1 );
is( $one->BufferPosition, 2, "Buffer position moving left stayed" );
