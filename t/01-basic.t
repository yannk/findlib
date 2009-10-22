use strict;
use Test::More tests => 8;

require 't/testutils.pl';

use File::Spec qw(catfile catdir);
use Find::Lib 'mylib';
use_ok 'MyLib';

in_inc( 'mylib' );

my $base = Find::Lib->base;
ok $base, 'base() returns the directory of your script';
is $base, $Find::Lib::Base, "It's accessible from outside";

is Find::Lib->catfile('something'), catfile($base, 'something');
is Find::Lib->catdir('dir'), catdir($base, 'dir');
is Find::Lib->catdir('..', 'dir'), catdir($base, '..', 'dir');
