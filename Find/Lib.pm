package Find::Lib;
use strict;
use warnings;
use lib;

use File::Spec::Functions qw( catpath splitpath rel2abs catdir );
sub import {
    my $class = shift;
    return unless @_;
    my %param;
    if ($_[0] ne 'paths' or $_[0] ne 'pkgs') {
        $param{paths} = [ $_[0] ];
        if ($_[1]) {
            $param{pkgs}  = { $_[1] => [ splice @_, 2 ] }
        }
    }
    else {
        %param = @_;
    }
    use YAML; warn Dump \%param;
    my $script = catpath( (splitpath( rel2abs $0 ))[ 0, 1 ], '' );

    lib->import( catdir($script, $_) ) for @{ $param{paths} || [] };

    while (my ($pkg, $args) = each %{ $param{pkgs} || {} }) { 
        eval "require $pkg";
        if ($@) {
            die $@;
        }
        $pkg->import( @{ $args || [] } );
    }
}

1;
