use strict;
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
plan tests => 3;

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
    chdir $link;
    ## execute from there, if all is ok, succeeds
    my $ret = system 'perl', $script;
    ok !$ret, "our script worked, meaning that compilation with symlink worked";
}
