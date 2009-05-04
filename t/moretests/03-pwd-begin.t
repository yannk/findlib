use strict;
use Test::More tests => 1;

BEGIN { $ENV{PWD} = '/tmp'; chdir '/tmp' };

use Find::Lib;

eval {
    Find::Lib->import('../mylib', 'MyLib', a => 1, b => 42);
};
ok $@, "we die because chdir  and PWD are changed";
