use strict;
use warnings;
use Test::More;
use File::Copy;
use File::Spec;

our $PWD;
our @dirs = ("testdir_$$", "testdir");
our $link = "symlink_$$";
my $script = 'symlink_test.pl';
my $dirs = File::Spec->catdir(@dirs);
my $srcfile = File::Spec->catfile('t', 'moretests', $script);
my $dstfile = File::Spec->catfile(@dirs, $script);

BEGIN {
    $PWD = $ENV{PWD};
    if ($^O eq 'MSWin32' or $^O eq 'os2') {
        plan skip_all => "irrelevant on dosish OS";
    }
    unless (eval { symlink(".", "symlinktest$$") } ) {
        plan 'skip_all' => "symlink support is missing on this FS";
    }
}
plan tests => 2;

END {
    chdir $PWD; ## restore original directory
    unlink "symlinktest$$";
    unlink $link;
    unlink $dstfile;
    rmdir $dirs;
    rmdir $dirs[0];
}

## let's create some stuff
mkdir $dirs[0];
mkdir $dirs;
symlink $dirs, $link
    or die "Couldn't symlink the test directory '$dirs $link': $!";

copy $srcfile, $dstfile;

## this is where we do the real test;
{
    ## Go into the symlinked directory
    chdir $link or die "coudn't chdir to $link";
    ## damn chdir doesn't update PWD unless comming from non-core Cwd
    local $ENV{PWD} = File::Spec->catdir( $ENV{PWD}, $link );
    ## execute from there, if all is ok, succeeds
    my $ret = system $^X, $script;
    ok !$ret, "script succeeded, meaning that compilation with symlink worked"
        or diag "PWD=$ENV{PWD}, script=$script";

    $ret = system $^X, ".///$script";
    ok !$ret, "crufty path doesn't make it blow up";
}
