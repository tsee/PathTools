#!./perl

BEGIN {
    chdir 't' if -d 't';
    if ($ENV{PERL_CORE}) {
        @INC = '../lib';
    }
}

use Test;
BEGIN {
    unless ($^O eq 'MSWin32') {
	print "1..0 # Skipped: this is not win32\n";
	exit;
    }
    plan tests => 3;
}

use Cwd;
ok 1;

my $cdir = getdcwd('C:');
ok $cdir, qr{^C:}i;

my $ddir = getdcwd('D:');
if (defined $ddir) {
  ok $ddir, qr{^D:}i;
} else {
  # May not have a D: drive mounted
  ok 1, 1;
}
