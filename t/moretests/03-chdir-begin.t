use strict;
use Test::More tests => 2;

use FindLib;

BEGIN { chdir '/tmp' };

eval { 
    FindLib->import('../mylib', 'MyLib', a => 1, b => 42);
};
ok ! $@, "we didn't die, because initial FindLib compilation saved cwd";

