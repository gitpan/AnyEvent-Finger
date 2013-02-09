package AnyEvent::Finger;

use strict;
use warnings;
use v5.10;
BEGIN { our @ISA; push @ISA, 'Exporter' }

our @EXPORT_OK = qw( finger_client finger_server );

# ABSTRACT: Simple asynchronous finger client and server
our $VERSION = '0.03'; # VERSION


sub finger_client
{
  my($hostname) = shift;
  require AnyEvent::Finger::Client;
  AnyEvent::Finger::Client
    ->new( hostname => $hostname )
    ->finger(@_);
}


sub finger_server
{
  require AnyEvent::Finger::Server;
  my $server = AnyEvent::Finger::Server
    ->new
    ->start(@_);
  # keep the server object in scope so that
  # we don't unbind from the port.  If you 
  # don't want this, then use the OO interface
  # for ::Server instead.
  state $keep = [];
  push @$keep, $server;
  return $server;
}

1;

__END__

=pod

=head1 NAME

AnyEvent::Finger - Simple asynchronous finger client and server

=head1 VERSION

version 0.03

=head1 SYNOPSIS

client:

 use AnyEvent::Finger qw( finger_client );
 
 finger_client 'localhost', 'username', sub {
   my($lines) = @_;
   say "[response]";
   say join "\n", @$lines;
 };

server:

 use AnyEvent::Finger qw( finger_server );
 
 my %users = (
   grimlock => 'ME GRIMLOCK HAVE ACCOUNT ON THIS MACHINE',
   optimus  => 'Freedom is the right of all sentient beings.',
 );
 
 finger_server sub {
   my $tx = shift;
   if($tx->req->listing_request)
   {
     # respond if remote requests list of users
     $tx->res->say('users: ', keys %users);
   }
   else
   {
     # respond if user exists
     if(defined $users{$tx->req->username})
     {
       $tx->res->say($users{$request});
     }
     # respond if user does not exist
     else
     {
       $tx->res->say('no such user');
     }
   }
   $tx->res->done;
 };

=head1 FUNCTIONS

=head2 finger_client( $server, $request, $callback, [ \%options ] )

Send a finger request to the given server.  The callback will
be called when the response is complete.  The options hash may
be passed in as the optional forth argument to override any
default options (See L<AnyEvent::Finger::Client> for details).

=head2 finger_server( $callback, [ \%options ] )

Start listening to finger callbacks and call the given callback
for each request.  See L<AnyEvent::Finger::Server> for details
on the options and the callback.

=head1 CAVEATS

Finger is an oldish protocol and almost nobody uses it anymore.

Most finger clients do not have a way to configure an alternate port.  
Binding to the default port 79 on Unix usually requires root.  Running 
L<AnyEvent::Finger::Server> as root is not recommended.

Under Linux you can use C<iptables> to forward requests to port 79 to
an unprivileged port.  I was able to use this incantation to forward port 79
to port 8079:

 # iptables -t nat -A PREROUTING -p tcp --dport 79 -j REDIRECT --to-port 8079
 # iptables -t nat -I OUTPUT -p tcp -d 127.0.0.1 --dport 79 -j REDIRECT --to-port 8079

The first rule is sufficient for external clients, the second rule was required
for clients connecting via the loopback interface (localhost).

=head1 SEE ALSO

L<RFC1288|http://tools.ietf.org/html/rfc1288>,
L<AnyEvent::Finger::Client>,
L<AnyEvent::Finger::Server>

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut