use strict;
use Test::More tests => 3;

## if $0 is renamed then we're screwed
$0 = "Renammed";
use Find::Lib 'mylib', 'MyLib', a => 1, b => 42;

ok $MyLib::imported{'a'};
is $MyLib::imported{'b'}, 42;
