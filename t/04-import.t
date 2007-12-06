use strict;
use Test::More tests => 3;

require 'testutils.pl';

use Find::Lib 'mylib', 'MyLib', a => 1, b => 42;

ok $MyLib::imported{'a'};
is $MyLib::imported{'b'}, 42;
