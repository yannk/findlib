package MyLib;

use Test::More;

our %imported = ();

sub import {
    my $class = shift;
    %imported = @_;
}

ok 1, __PACKAGE__ . " loaded";

1;
