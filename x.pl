use Find::Lib paths => [ 'x', 'x/y', 'x/../lib', 'unexistent' ], 
              pkgs  => { 'Boot' => [ test => 1 ] }; 

=cut
My onliner goal is achieved but is ugly now:

use Find::Lib paths => [ "../core/lib "], pkgs => { "TypeCore::Bootstrap" => [ test => 1 ] }

I want, simplified: one path + one bootstrap module
use Find::Lib '../core/lib' => 'TypeCore::Bootstrap', tests => 1;
=cut

use Foo;
use Bar;
use Baz;
my ($unexistent) = grep { /unexistent/ } @INC;
print STDERR $unexistent ? "not ok\n" : "ok\n";

#use YAML; warn Dump \@INC;
warn "done";
