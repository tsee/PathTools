#!./perl -w

BEGIN {
    if ($ENV{PERL_CORE}) {
        chdir 't';
        @INC = '../lib';
    }
}
use Cwd;
chdir 't';

use strict;
use Config;
use File::Spec;
use File::Path;

use lib File::Spec->catdir('t', 'lib');
require VMS::Filespec if $^O eq 'VMS';

use Test::More;

# Set up the environment.
my $starting_wd = Cwd::abs_path();
my $x_but_no_r = 'x_but_no_r';
my $test_dir   = 'testdir';
my $sub_dir    = 'subdir';
my $test_path  = File::Spec->catdir($x_but_no_r, $test_dir);
my $sub_path   = File::Spec->catdir($test_path, $sub_dir);

eval {
    mkpath($sub_path)               or die;
    chmod 0100, $x_but_no_r         or die;

    !opendir(my $dh, $x_but_no_r)   or die;
    chdir $x_but_no_r               or die;
    chdir $test_dir                 or die;
};
if( $@ ) {
    plan skip_all => 
            "restricted permission test environment could not be made"
}
else {
    plan tests => 16;
}


my %funcs = (
    abs_path        => \&Cwd::abs_path,
    _perl_abs_path  => \&Cwd::_perl_abs_path,
);
for my $name (sort keys %funcs) {
    my $func = $funcs{$name};

    TODO: {
        local $TODO = 'Perl abs_path() doesn\'t pass tests yet';
	like $func->(),         qr{\Q$test_path\E$}, "$name w/no args";
	like $func->($sub_dir), qr{\Q$sub_path\E$},  "$name w/subdir";
    }
    
    # All but the last component of pathname must exist when realpath()
    # is called. -- BSD realpath man page.
    my $dne_path = File::Spec->catdir($test_path, "dne");
    TODO: {
        local $TODO = 'Perl abs_path() does not work with a bogus sub file';
        like $func->("dne"), qr{\Q$dne_path\E$}, 
             "$name w/non-existant filename";
    }

    my $double_dne = File::Spec->catdir("dne", "sub_dne");
    ok !$func->($double_dne), "$name w/non-existant sub dir";
    
    ok chdir $starting_wd;
    ok chdir $x_but_no_r, 'chdir to the unreadable directory';
    like $func->(), qr{\Q$x_but_no_r\E$}, "$name when cwd unreadable";
    ok chdir $test_dir,   'chdir back to the test dir';
}


END {
    chdir $starting_wd;
    chmod 0700, $x_but_no_r;
    rmtree $x_but_no_r;
}
