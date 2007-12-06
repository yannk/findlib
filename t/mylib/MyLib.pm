package MyLib;

require 'common.pl';

our %imported = ();

sub import {
    my $class = shift;
    %imported = @_;
}

loaded( __PACKAGE__ );

1;
