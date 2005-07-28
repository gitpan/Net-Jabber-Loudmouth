package Net::Jabber::Loudmouth;

use strict;
use warnings;
use Glib;
require DynaLoader;

our @ISA = qw(DynaLoader);
our $VERSION = 0.01;

our $DefaultPort = 5222;
our $DefaultPortSSL = 5223;

sub dl_load_flags { 0x01 };

bootstrap Net::Jabber::Loudmouth $VERSION;

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Net::Jabber::Loudmouth - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::Jabber::Loudmouth;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::Jabber::Loudmouth, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Florian Ragwitz, E<lt>rafl@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Florian Ragwitz

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
