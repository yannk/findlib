package Find::Lib;
use strict;
use warnings;
use lib;

use File::Spec::Functions qw( catpath splitpath rel2abs catdir );
sub import {
    my $class = shift;
    return unless @_;
    my %param = @_;
    my $script = catpath( (splitpath( rel2abs $0 ))[ 0, 1 ], '' );

    lib->import( catdir($script, $_) ) for @{ $param{paths} || [] };

    while (my ($pkg, $args) = each %{ $param{pkgs} || {} }) { 
        eval "require $pkg";
        $pkg->import( @{ $args || [] } );
    }
}

1;
