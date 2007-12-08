use strict;
use Test::More tests => 3;

require 't/testutils.pl';

use Find::Lib 'mylib';
use_ok 'MyLib';

in_inc( 'mylib' );
