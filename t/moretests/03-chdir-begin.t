use strict;
use Test::More tests => 2;

use Find::Lib;

BEGIN { chdir '/tmp' };

eval { 
    Find::Lib->import('../mylib', 'MyLib', a => 1, b => 42);
};
ok ! $@, "we didn't die, because initial Find::Lib compilation saved cwd";

