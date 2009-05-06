use strict;
use Test::More tests => 1;

BEGIN {
    if ($^O eq 'MSWin32' or $^O eq 'os2') {
        plan skip_all => "irrelevant on dosish OS";
    }
    $ENV{PWD} = '/tmp'; chdir '/tmp';
};

use Find::Lib;

eval {
    Find::Lib->import('../mylib', 'MyLib', a => 1, b => 42);
};
ok $@, "we die because chdir and PWD are changed";
