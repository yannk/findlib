use strict;
use Test::More tests => 3;

require 'testutils.pl';

use Find::Lib paths => [ '../unexistent', 'mylib' ],
              pkgs  => { MyLib => [ a => 1, b => 42+42 ],
                         'Test::More' => [],
                       };

ok $MyLib::imported{'a'};
is $MyLib::imported{'b'}, 84;
