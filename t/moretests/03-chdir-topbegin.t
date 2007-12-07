use strict;
use Test::More tests => 1;

BEGIN { chdir '/tmp' };

use Find::Lib;

eval { 
    Find::Lib->import('../mylib', 'MyLib', a => 1, b => 42);
};
ok $@, "we died, because chdir occured before Find::Lib... we're lost";
