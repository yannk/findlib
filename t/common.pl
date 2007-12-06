use Test::More;

sub loaded {
    ok 1, shift() . " loaded";
}

1;
