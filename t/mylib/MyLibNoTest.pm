package MyLib;

use vars '%imported';

sub import {
    my $class = shift;
    %imported = @_;
}

1;
