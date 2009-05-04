package Find::Lib;
use strict;
use warnings;
use lib;

use File::Spec::Functions qw( catpath splitpath rel2abs catdir splitdir );
use vars qw/$Base $VERSION @base/;
use vars qw/$Script/; # compat

=head1 NAME

Find::Lib - Helper to smartly find libs to use in the filesystem tree

=head1 VERSION

Version 0.02

=cut

$VERSION = '0.03';

=head1 SYNOPSIS

    #!/usr/bin/perl -w;
    use strict;

    ## simple usage
    use Find::Lib '../mylib';

    ## with a Bootstap module
    use Find::Lib '../mylib' => 'My::Bootstrap';

    ## pass import parameters to your Bootstrap module
    use Find::Lib '../mylib' => 'My::Bootstrap', test => 1, dbi => 'sqlite';

    ## If you like verbose, or if you don't have a Bootstrap module
    use Find::Lib libs => [ 'lib', '../lib', 'devlib' ];
    use My::Test tests => 10;
    use My::Module;

=head1 DESCRIPTION

The purpose of this module is to replace

    use FindBin;
    use lib "$FindBin::Bin/../bootstrap/lib";
    use My::Bootstrap %param;

with something shorter. This is specially useful if your project has a lot
of scripts (For instance tests scripts).

    use Find::Lib '../bootstrap/lib' => 'My::Bootstrap', %param;

does exactly that without using L<FindBin> module, and has the important
propriety to do what you mean regarding symlinks and '..'.

Note that the role of a Bootstrap module is actually to install more
library paths in C<@INC> and to use more modules necessary to your application.
It keeps your scripts nice and clean.

On the other hand, if you don't want/need/have a Bootstrap module, you can
still use L<Find::Lib> to automatically identify the relative locations of
your libraries and add them to your C<@INC>; just use the expanded version
as seen in the SYNOPSIS.

=head1 DISCUSSION

=head2 Installation and availability of this module

The usefulness of this module is seriously reduced if L<Find::Lib> is not
already in your @INC / $ENV{PERL5LIB} -- Chicken and egg problem. This is
the big disavantage of L<FindBin> over L<Find::Lib>: FindBin is distributed
with Perl. To mitigate that, you need to be sure of global availability of
the module in the system (You could install it via your favorite package
managment system for instance).

=head2 modification of $0 and chdir (BEGIN blocks, other 'use')

As soon as L<Find::Lib> is compiled it saves the location of the script and
the initial cwd (current working directory), which are the two pieces of
information the module relies on to interpret the relative path given by the
calling program.

If one of cwd, $ENV{PWD} or $0 is changed before Find::Lib has a chance to do
its job, then Find::Lib will most probably die, saying "The script cannot be
found". I don't know a workaround that. So be sure to load Find::Lib as soon
as possible in your script to minimize problems (you are in control!).

(some programs alter $0 to customize the diplay line of the process in
the system process-list (C<ps> on unix).

(Note, see L<perlvar> for explanation of $0)

=head1 USAGE

=head2 import

All the work is done in import. So you need to 'use Find::Lib' and pass
arguments to it.

Recognized arguments are:

=over 4

=item C<libs>, a reference to a list of path to add to C<@INC>. The paths given
are (should) be relative to the location of the current script. The paths won't
be added unless the path actually exists on disk

=item C<pkgs>, a reference to a hash containing package name as keys and
arrayref of arguments (to import) as values. This is not really useful in
itself, you'd better specify 'libs' in the import arguments and then use
on seperate lines after it.

=back

The short forms implies that the first argument passed to import is not C<libs>
or C<pkgs>. An example of usage is given in the SYNOPSIS section.

=cut

use Carp();

$Script = $Base = guess_base();

sub guess_base {
    my $base;
    $base = guess_shell_path();
    return $base if $base && -e $base;
    return guess_system_path();
}

sub guess_shell_path {
    my ($volume, $path, $file) = splitpath( $ENV{PWD} );
    my @path = splitdir $path;
    pop @path unless $path[-1];
    @base = (@path, $file);
    my @zero = splitdir $0;
    pop @zero; # get rid of the script
    ## a clean base is also important for the pop business below
    #@base = grep { $_ && $_ ne '.' } shell_resolve(\@base, \@zero);
    @base = shell_resolve(\@base, \@zero);
    return catpath( $volume, (catdir @base), '' );
}

## naive method, but really DWIM from a developer perspective
sub shell_resolve {
    my ($left, $right) = @_;
    while (@$right && $right->[0] eq '.') { shift @$right }
    while (@$right && $right->[0] eq '..') {
        shift @$right;
        ## chop off @left until we removed a significant path part
        my $part;
        while (@$left && !$part) {
            $part = pop @$left;
        }
    }

    return (@$left, @$right);
}

sub guess_system_path {
    return catpath( (splitpath( rel2abs $0 ))[ 0, 1 ], '' );
}

sub import {
    my $class = shift;
    return unless @_;
    my %param;

    Carp::croak("The script/base dir cannot be found") unless -e $Base;

    if ( ( $_[0] eq 'libs' or $_[0] eq 'pkgs' )
        and ref $_[1] && ref $_[1] ne 'SCALAR' ) {

        %param = @_;
    }
    else {
        ## enters simple bootstrap mode:
        ## 'libpath' => 'bootstrap package' => @arguments
        $param{libs} = [ $_[0] ];
        if ( $_[1] ) {
            $param{pkgs} = { $_[1] => [ splice @_, 2 ] };
        }
    }

    for ( reverse @{ $param{libs} || [] } ) {
        my @lib = splitdir $_;
        if (@lib && ! $lib[0]) {
            # '/abs/olute/' path
            lib->import($_);
            next;
        }
        my $dir = catdir( shell_resolve( [ @base ], \@lib ) );
        unless (-d $dir) {
            ## Try the old way (<0.03)
            $dir = catdir($Base, $_);
        }
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

Jonathan Steinert (hachi) for doing all the conception of 0.03 shell expansion
mode with me.

=head1 SUPPORT & CRITICS

I welcome feedback about this module, don't hesitate to contact me regarding this
module, usage or code.

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

Copyright 2007, 2009 Yann Kerherve, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
