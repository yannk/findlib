use strict;
use Test::More tests => 3;

require 'testutils.pl';

use Find::Lib 'mylib';
use_ok 'MyLib';

in_inc( 'mylib' );
