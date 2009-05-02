#!/usr/bin/perl -w
## this is not a test in itself, don't execute
## this is a script that is executed by a test

use Find::Lib '../../mylib', 'MyLib';
warn $ENV{PWD};
exit 0;
