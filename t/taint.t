#!./perl -Tw
# Testing Cwd under taint mode.

BEGIN {
    chdir 't' if -d 't';
    if ($ENV{PERL_CORE}) {
	@INC = '../lib';
    }
}
use Cwd;

use strict;
use Test;
plan tests => 16;
use Scalar::Util qw/tainted/;

my @Functions = qw(getcwd cwd fastcwd fastgetcwd
                   abs_path fast_abs_path
                   realpath fast_realpath
                  );

foreach my $func (@Functions) {
    no strict 'refs';
    my $cwd;
    eval { $cwd = &{'Cwd::'.$func} };
    ok( $@, '',		  "$func() should not explode under taint mode" );
    ok( tainted($cwd), 1, "its return value should be tainted" );
}
