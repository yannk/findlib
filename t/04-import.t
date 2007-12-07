use strict;
use Test::More tests => 3;

require 't/testutils.pl';

use FindLib 'mylib', 'MyLib', a => 1, b => 42;

ok $MyLib::imported{'a'};
is $MyLib::imported{'b'}, 42;
