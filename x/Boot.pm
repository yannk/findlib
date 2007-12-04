package Boot;
use strict;
use warnings;

warn "Boot compiled";

sub import {
    my $class = shift;
    my %param = @_;
    warn "import Boot";
    warn "imported Boot with args" if $param{test};
}

1;
