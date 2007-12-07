use strict;
use Test::More tests => 3;

use FindLib libs => [ '../mylib', 'mytestlib' ],
              pkgs => { MyLib => [ a => 1, b => 42+42 ],
                        'Test::More' => [],
                      };

ok $MyLib::imported{'a'};
is $MyLib::imported{'b'}, 84;
