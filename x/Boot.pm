package Boot;
use strict;
use warnings;

warn "boot compiled";

sub import {
    my $class = shift;
    my %param = @_;
    warn "imported Boot" if $param{test};
}

1;
