use Find::Lib paths => [ 'x', 'x/y', 'x/../lib' ], 
              pkgs  => { 'Boot' => [ test => 1 ] }; 

=cut
Ugly now:

use Find::Lib paths => [ "../core/lib "], pkgs => { "TypeCore::Bootstrap" => [ test => 1 ] }


I want, simplified: one path + one bootstrap module
Find::Lib '../core/lib' => 'TypeCore::Bootstrap' => [ tests => 1 ]

Find::Lib '../core/lib' => 'TypeCore::Bootstrap', tests => 1;
=cut

use Foo;
use Bar;
use Baz;
warn "done";
