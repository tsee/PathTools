#!/usr/bin/perl

# A script to check a local copy against bleadperl, generating a blead
# patch if they're out of sync.  An optional directory argument will
# be chdir()-ed into before comparing.

use strict;
chdir shift() if @ARGV;

my $blead = "~/Downloads/perl/bleadperl";


diff( "$blead/lib/File/Spec.pm", "lib/File/Spec.pm");

diff( "$blead/lib/File/Spec", "lib/File/Spec",
      qw(t) );

diff( "$blead/lib/File/Spec/t", "t",
      qw(cwd.t lib taint.t win32.t) );

diff( "$blead/lib/Cwd.pm", "Cwd.pm" );

diff( "$blead/ext/Cwd/Cwd.xs", "Cwd.xs" );

diff( "$blead/ext/Cwd/t", "t",
       qw(Functions.t Spec.t lib crossplatform.t rel2abs2rel.t tmpdir.t) );

######################
sub diff {
  my ($first, $second, @skip) = @_;
  local $_ = `diff -ur $first $second`;

  for my $x ('.svn', @skip) {
    s/^Only in .* $x\n//m;
  }
  print;
}
