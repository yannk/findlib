package Find::Lib;
use strict;
use warnings;
use lib;

use File::Spec::Functions qw( catpath splitpath rel2abs catdir );

=head1 NAME

Find::Lib - Helper to find and 'use lib' in the filesystem

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    #!/usr/bin/perl -w;
    use strict;
    
    ## simple usage
    use base Find::Lib '../mylib' => 'My::BootStrap';

    ## pass import parameters to your Bootstrap module
    use base Find::Lib '../mylib' => 'My::Bootstrap', test => 1, dbi => 'sqlite';

    ## If you like verbose or if you don't have a Bootstrap module
    use Find::Lib paths => [ 'lib', '../lib', 'devlib' ], 
                  pkgs  => { 'Test::More' => [ tests => 10 ], 
                             'My::Module' => [ ],
                  }; 

=head1 DESCRIPTION

The purpose of this module is to replace

    use FindBin;
    use lib "$FindBin::Bin/../bootstrap/lib";
    use My::Bootstrap %param;

with something shorter. This is specially useful if your project has a lot of scripts
(For instance tests scripts).

    use base Find::Lib '../bootstrap/lib' => 'My::Bootstrap', %param;

does exactly that without using L<FindBin> module.

Note that the role of a Bootstrap module is actually to install more library paths in
C<@INC> and to use more modules necessary to your application. It keeps your scripts
nice and clean. 

On the otherhand, if you don't want/need/have a Bootstrap module, you can still use
L<Find::Lib> to automatically identify the relative locations of your libraries and
add them to your C<@INC>; just use the expanded version of the SYNOPSIS.

=head1 DISCUSSION

=head2 Installation and availability of this module

The usefulness of this module is seriously reduced if L<Find::Lib> is not already in
your @INC / $ENV{PERL5LIB} -- Chicken and egg problem. This is the big disavantage of 
L<Find::Lib> over L<FindBin> so you need to be sure of global availability of the module
in the system (installed thru your favorite package managment system for intance).

=head2 BEGIN{ } vs import()

On the contrary of L<FindBin>, L<Find::Lib> uses an import() to do its job, so you
need to be aware of $0 modifiations XXX

=head1 USAGE

=head2 import

All the work is done in import. So you need to 'use Find::Lib' and pass arguments
to it.

Recognized arguments are:

=over 4

=item C<paths>, a reference to a list of path to add to C<@INC>. The paths given
are (should) be relative to the location of the current script. The paths won't be
added unless the path actually exists on disk

=item C<pkgs>, a reference to a hash containing package name as keys and arrayref
of arguments (to import) as values.

=back

The short forms implies that the first argument passed to import is not C<paths>
or C<pkgs>. An example of usage is given in the SYNOPSIS section.

=cut

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

    for ( reverse @{ $param{paths} || [] } ) {
        my $dir = catdir($script, $_);
        next unless -d $dir;
        lib->import( $dir );
    }

    while (my ($pkg, $args) = each %{ $param{pkgs} || {} }) { 
        eval "require $pkg";
        if ($@) {
            die $@;
        }
        $pkg->import( @{ $args || [] } );
    }
}


=head1 SEE ALSO

L<FindBin>, L<FindBin::libs>, L<lib>, L<require>, L<use>

=head1 AUTHOR

Yann Kerherve, C<< <yann.kerherve at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-find-lib at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Find-Lib>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENT

Six Apart hackers nourrished the discussion that led to this module creation.
 
=head1 SUPPORT

You can find documentation for this module with the perldoc command.
    
    perldoc Find::Lib
    
You can also look for information at:
        
=over 4 

=item * AnnoCPAN: Annotated CPAN documentation
        
L<http://annocpan.org/dist/Find-Lib>
        
=item * CPAN Ratings
        
L<http://cpanratings.perl.org/d/Find-Lib>
        
=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Find-Lib>
        
=item * Search CPAN
    
L<http://search.cpan.org/dist/Find-Lib>
        
=back   
        
=head1 COPYRIGHT & LICENSE
    
Copyright 2007 Yann Kerherve, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
