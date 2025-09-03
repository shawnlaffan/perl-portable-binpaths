# perl-portable-binpaths
Add the respective bin dirs when running a strawberry perl instance

A general nuisance when running some Strawberry Perl instances is that the user has neglected
to add the `.../c/bin` and `.../c/perl/site/bin` dirs to the path. This can lead to obscure errors
with DLLs failing to load.

This module adds these to the path on startup (and the `.../perl/bin` dir if needed, such as when
perl is invoked using a full path but is not itself in the path).

It has no effect on your shell so will not suddenly fix calls to utilities such as C<gmake> and similar,
e.g. via a `cpanm` call.

Example usages:

```
perl -MPortable::BinPaths somescript.pl
```

```cmd
:: if perl is not in the path then the bin paths will be appended
set PERL5OPT=-MPortable::BinPaths
C:\perls\5.38.4.1\perl\bin\perl.exe -E"say $ENV{PATH}"
```
