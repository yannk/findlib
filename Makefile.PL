use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'FindLib',
    AUTHOR              => 'Yann Kerherve <yannk@cpan.org>',
    VERSION_FROM        => 'lib/FindLib.pm',
    ABSTRACT_FROM       => 'lib/FindLib.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'File::Spec' => 0,
    },
    test                => { TESTS => 't/*.t t/moretests/*t' },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'FindLib-*' },
);
