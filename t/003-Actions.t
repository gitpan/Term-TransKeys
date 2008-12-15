#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 48;
use Data::Dumper;

use vars qw/ $tmp $one /;

use_ok( 'Term::TransKeys' );

$one = Term::TransKeys->new;
$one->_PushBuffer( qw/ a b c d e f g /);
$one->_BufferPosition( 0, $one->_GetBuffer );
ok( $one->ActionBS( $one->_GetBuffer ), "Backspace" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a b c d e f /],
    "Last character removed"
);

$one->_ResetBuffer;
$one->_PushBuffer( qw/ a b c d e f g /);
$one->_BufferPosition( 2, $one->_GetBuffer );
ok( $one->ActionBS( $one->_GetBuffer ), "Backspace" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a b c d f g/],
    "Middle Character removed"
);

$one->_ResetBuffer;
$one->_PushBuffer( qw/ a b c d e f g /);
$one->_BufferPosition( 100, $one->_GetBuffer );
ok(( not $one->ActionBS( $one->_GetBuffer )), "Backspace at end" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a b c d e f g/],
    "No Character Removed"
);

$one->_ResetBuffer;
$one->_PushBuffer( qw/ a b c d e f g /);
ok( $one->ActionEsc( $one->_GetBuffer, "__TERM__" ), "Terminate" );
is_deeply(
    $one->_GetBuffer,
    [ '__TERM__' ],
    "Only term character"
);

$one->_ResetBuffer;
$one->_PushBuffer( qw/ a b c d e f g /);
ok( $one->ActionCD( $one->_GetBuffer, "__TERM__", \$tmp ), "Terminate" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a b c d e f g /],
    "Buffer unchanged"
);
is( $tmp, "__TERM__", "Key changed to term" );

$one->AddHistory([ qw/ a a a a /]);
$one->_ResetBuffer;
$one->_PushBuffer( qw/ a b c d e f g /);
ok( $one->ActionUp( $one->_GetBuffer ), "History Up" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a a a a /],
    "History"
);
is( $one->BufferPosition, 4, "Cursor at end" );
$one->ActionBS( $one->_GetBuffer );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a a a /],
    "History"
);
ok( $one->ActionDown( $one->_GetBuffer ), "History Down" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a b c d e f g /],
    "We're back"
);
is( $one->BufferPosition, 7, "Cursor at end" );
ok( $one->ActionUp( $one->_GetBuffer ), "History Up" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a a a /],
    "Remembered history changes"
);

$one->_ResetBuffer;
$one->_PushBuffer( qw/ a b c d e f g /);
is( $one->_BufferPosition( 0, $one->_GetBuffer ), 7, "Cursor at end" );
ok( $one->ActionLeft( $one->_GetBuffer ), "Left Arrow" );
is( $one->BufferPosition, 6, "Cursor Left" );
ok( $one->ActionLeft( $one->_GetBuffer ), "Left Arrow" );
is( $one->BufferPosition, 5, "Cursor Left more" );
ok( $one->ActionLeft( $one->_GetBuffer ), "Left Arrow" );
is( $one->BufferPosition, 4, "Cursor Left more" );
ok( $one->ActionRight( $one->_GetBuffer ), "Right Arrow" );
is( $one->BufferPosition, 5, "Cursor Right" );
ok( $one->ActionRight( $one->_GetBuffer ), "Right Arrow" );
is( $one->BufferPosition, 6, "Cursor Right" );
ok( $one->ActionRight( $one->_GetBuffer ), "Right Arrow" );
is( $one->BufferPosition, 7, "Cursor Right" );
ok( $one->ActionHome( $one->_GetBuffer ), "Home" );
is( $one->BufferPosition, 0, "Cursor Home" );
ok( $one->ActionEnd( $one->_GetBuffer ), "End" );
is( $one->BufferPosition, 7, "Cursor End" );

ok(( not $one->ActionDel( $one->_GetBuffer )), "Cannot delete from end" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a b c d e f g /],
    "Nothing Deleted"
);

ok( $one->ActionHome( $one->_GetBuffer ), "Home" );
is( $one->BufferPosition, 0, "Cursor Home" );
is( $one->ActionDel( $one->_GetBuffer ), 'a', "Delete from Start" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ b c d e f g /],
    "Deleted 'a'"
);

$one->_ResetBuffer;
$one->_PushBuffer( qw/ a b c d e f g /);
ok( $one->ActionEnter( $one->_GetBuffer, '__TERM__', \"<ENTER>" ), "Add Newline" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a b c d e f g /, "\n" ],
    "Added newline"
);

$one->_ResetBuffer;
$one->_PushBuffer( qw/ a b c d e f g /);
ok( $one->ActionEnter( $one->_GetBuffer, '<ENTER>', \"<ENTER>" ), "Add Newline" );
is_deeply(
    $one->_GetBuffer,
    [ qw/ a b c d e f g / ],
    "Did not Add newline"
);
