use Find::Lib paths => [ 'x', 'x/y', 'x/../lib' ], 
              pkgs  => { 'Boot' => [ test => 1 ] }; 

use Foo;
use Bar;
use Baz;
warn "done";
