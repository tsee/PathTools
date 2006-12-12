#!/usr/bin/perl


$_ = `diff -u lib/File/Spec.pm ~/Downloads/perl/bleadperl/lib/File/Spec.pm`;
s/^Only in .* t\n//m;
print;

$_ = `diff -u lib/File/Spec ~/Downloads/perl/bleadperl/lib/File/Spec`;
s/^Only in .* t\n//m;
print;

$_ = `diff -u t ~/Downloads/perl/bleadperl/lib/File/Spec/t`;
for my $x (qw{cwd.t lib taint.t win32.t}) {
  s/^Only in .* $x\n//m;
}
print;

print `diff -u Cwd.pm ~/Downloads/perl/bleadperl/lib/Cwd.pm`;

print `diff -u Cwd.xs ~/Downloads/perl/bleadperl/ext/Cwd/Cwd.xs`;

$_ = `diff -u t ~/Downloads/perl/bleadperl/ext/Cwd/t`;
for my $x (qw{Functions.t Spec.t lib crossplatform.t rel2abs2rel.t tmpdir.t}) {
  s/^Only in .* $x\n//m;
}
print;
