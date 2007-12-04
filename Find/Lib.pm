package Find::Lib;
use strict;
use warnings;
use lib;

use File::Spec::Functions qw( catpath splitpath rel2abs catdir );

sub import {
    my $class = shift;
    return unless @_;
    my %param;
    if ($_[0] ne 'paths' and $_[0] ne 'pkgs') {
        ## enters simple bootstrap mode:
        ## 'libpath' => 'bootstrap package' => @arguments
        $param{paths} = [ $_[0] ];
        if ($_[1]) {
            $param{pkgs}  = { $_[1] => [ splice @_, 2 ] }
        }
    }
    else {
        %param = @_;
    }
    my $script = catpath( (splitpath( rel2abs $0 ))[ 0, 1 ], '' );

    for ( @{ $param{paths} || [] } ) {
        next unless -d $_;
        lib->import( catdir($script, $_) );
    }

    while (my ($pkg, $args) = each %{ $param{pkgs} || {} }) { 
        eval "require $pkg";
        if ($@) {
            die $@;
        }
        $pkg->import( @{ $args || [] } );
    }
}

1;
