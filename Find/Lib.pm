package Find::Lib;
use strict;
use warnings;

use File::Spec::Functions qw( catpath splitpath rel2abs catdir );
sub import {
    my $class = shift;
    return unless @_;
    my $script = catpath( (splitpath( rel2abs $0 ))[ 0, 1 ], '' );
    my $use_libs = '';
    for (@_) {
        my $libdir = catdir($script, $_);
        $use_libs .= "use lib '$libdir';";
    }
    eval $use_libs;
    warn $@ if $@;
}

1;
