use strict;
use Test::More tests => 2;

BEGIN { chdir '/tmp' };

use Find::Lib;

eval {
    Find::Lib->import('../mylib');
    use MyLib a => 1, b => 42;
};
ok !$@, "we didn't die because chdir doesn't change PWD, so we are safe";
