#!/usr/bin/perl -w
## this is not a test in itself, don't execute
## this is a script that is executed by a test

use Test::More 'no_plan';
use Find::Lib '../t/mylib', 'MyLib';
exit 0;
