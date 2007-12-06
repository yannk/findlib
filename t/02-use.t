use strict;
use Test::More tests => 3;

require 'testutils.pl';

use Find::Lib 'mylib', 'MyLib';

ok my $path = $INC{ 'MyLib.pm' }, "MyLib used";
like $path, qr/mylib/, "just to be sure :)";
