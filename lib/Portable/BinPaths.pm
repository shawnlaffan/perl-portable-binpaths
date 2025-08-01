package Portable::BinPaths;

use 5.010;
use strict;
use warnings;
use Path::Tiny qw/path/;

BEGIN {
    use Config;
    if (($Config{myuname} // '') =~ /strawberry/i) {
        use Env qw /@PATH/;
        my $sbase = path($^X)->parent->parent->parent;
        my @non_null_paths = map {path($_)} grep {defined} @PATH; #  avoid undef path entries
        my %pexists;
        @pexists{@non_null_paths} = @non_null_paths;
        my @paths =
            grep {-e $_ && !exists $pexists{$_}}
                map {path($sbase, $_)}
                    ("/c/bin", "/perl/bin", "/perl/site/bin", "/perl/vendor/bin");
        if (@paths) {
            #  splice them in after the perl dir, or at the front
            my $idx = -1;
            my $perl_path = path($^X)->parent->stringify;
            #  we cannot depend on List::MoreUtils::first_idx as we try to be tiny-ish
            foreach my $path (@PATH) {
                $idx++;
                next if !defined $path;
                last if $perl_path eq path ($path)->stringify
            }
            #  Handle case where perl is not in the path
            #  and was called with a fully qualified path
            if ($idx < 0) {
                unshift @PATH, @paths;
            }
            else {
                splice @PATH, $idx + 1, 0, @paths;
            }
            if ($ENV{PORTABLE_BINPATHS_VERBOSE}) {
                say "Portable::BinPaths: portable perl detected, its bin dirs have been added to $ENV{PATH}";
                # say join "\n", @PATH;
            }
        }
    }
}


=head1 NAME

Portable::BinPaths - Add Strawberry Perl portable bin dirs to the path

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    #  within a script:
    use Portable::BinPaths;

    #  from the command line:
    perl -MPortable::BinPaths somescript.pl

    #  or:
    set PERL5OPT=-MPortable::BinPaths
    C:\perls\5.38.4.1\perl\bin\perl.exe -E"say $ENV{PATH}


=head1 DESCRIPTION

This module adds the Strawberry Perl portable bin directories to the path
when loaded.

It is a no-op on any other system.

A general nuisance when running some Strawberry Perl instances is that the user has neglected
to add the C<.../c/bin> and C<.../c/perl/site/bin> dirs to the path, for example by running
C<portableshell.bat> at the top of a Strawberry Perl Portable installation.
This can lead to obscure errors with DLLs failing to load.

This module adds these to the path on startup (and the C<.../perl/bin> dir if needed, such as when
perl is invoked using a full path but is not itself in the path).

It has no effect on the calling shell so will not suddenly fix calls to utilities such as C<gmake> and similar,
e.g. via a C<cpanm> call.

The bin dirs are spliced into C<$ENV{PATH}> immediately after the path containing perl.exe.
If perl is not in the path then they are appended to the end of C<$ENV{PATH}>.
Portable::BinPaths will not prepend to the front of C<$ENV{PATH}>.

A future version might be generalised to any perl on Windows, hence the general name.

=head1 EXPORT

None

=head1 SUBROUTINES/METHODS

None

=head1 AUTHOR

Shawn Laffan, C<< <shawnlaffan at gmail.com> >>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Portable::BinPaths


You can also look for information at:

=over 4

=item * Search CPAN

L<https://metacpan.org/release/Portable-BinPaths>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is copyright (c) 2025 by Shawn Laffan.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.


=cut

1; # End of Portable::BinPaths
