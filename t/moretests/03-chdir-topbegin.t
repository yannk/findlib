use strict;
use Test::More tests => 1;

BEGIN { chdir '/tmp' };

use FindLib;

eval { 
    FindLib->import('../mylib', 'MyLib', a => 1, b => 42);
};
ok $@, "we died, because chdir occured before FindLib... we're lost";
