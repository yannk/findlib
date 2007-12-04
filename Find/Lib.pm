package Find::Lib;
use strict;
use warnings;

use File::Spec::Functions qw( catpath splitpath rel2abs catdir );
sub import {
    my $class = shift;
    return unless @_;
    my %param = @_;
    my $script = catpath( (splitpath( rel2abs $0 ))[ 0, 1 ], '' );
    my $use_libs = '';
    for (@{ $param{paths} }) {
        my $libdir = catdir($script, $_);
        $use_libs .= "use lib '$libdir';";
    }
    unless ($use_libs)  {
        warn "no library used";
    }
    if ($use_libs) {
        for (@{ $param
        eval $use_libs;
        warn $@ if $@;
    }
}

1;
