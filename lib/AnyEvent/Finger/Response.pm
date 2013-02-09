package AnyEvent::Finger::Response;

use strict;
use warnings;
use v5.10;

# ABSTRACT: Simple asynchronous finger response
our $VERSION = '0.03'; # VERSION


sub say
{
  shift->(\@_);
}


sub done
{
  shift->();
}

1;

__END__

=pod

=head1 NAME

AnyEvent::Finger::Response - Simple asynchronous finger response

=head1 VERSION

version 0.03

=head1 METHODS

=head2 $response-E<gt>say( @lines )

Send the lines to the client.  Do not include new line characters (\r, 
\n or \r\n), these will be added by L<AnyEvent::Finger::Server>.

=head2 $response-E<gt>done

Close the connection with the client.  This signals that the response is
complete.  Do not forget to call this!

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
