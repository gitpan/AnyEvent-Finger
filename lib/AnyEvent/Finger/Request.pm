package AnyEvent::Finger::Request;

use strict;
use warnings;
use v5.10;
use overload '""' => sub { shift->as_string };

# ABSTRACT: Simple asynchronous finger request
our $VERSION = '0.04'; # VERSION


sub new
{
  bless { raw => "$_[1]" // '' }, $_[0];
}


sub verbose
{
  my($self) = @_;
  $self->{verbose} //= ($self->{raw} =~ /^\/W/ ? 1 : 0);
}


sub username
{
  my($self) = @_;
  
  unless(defined $self->{username})
  {
    if($self->{raw} =~ /^(?:\/W\s*)?([^@]*)/)
    { $self->{username} = $1 }
  }
  
  $self->{username};
}


sub hostnames
{
  my($self) = @_;
  $self->{hostnames} //= ($self->{raw} =~ /\@(.*)$/ ? [split '@', $1] : []);
}


sub as_string
{
  my($self) = @_;
  join('@', ($self->username, @{ $self->hostnames }));
}


sub listing_request { shift->username eq '' ? 1 : 0 }



sub forward_request { @{ shift->hostnames } > 0 ? 1 : 0}

1;

__END__

=pod

=head1 NAME

AnyEvent::Finger::Request - Simple asynchronous finger request

=head1 VERSION

version 0.04

=head1 CONSTRUCTOR

 my $request = AnyEvent::Finger::Request->new("foo@localhost");

The constructor takes a string which is the raw finger request.

=head1 ATTRIBUTES

=head2 $request-E<gt>verbose

True if request is asking for a verbose response.  False
if request is not asking for a verbose response.

=head2 $request-E<gt>username

The username being requested.

=head2 $request-E<gt>hostnames

Returns a list of hostnames (as an array ref) in the request.

=head2 $request-E<gt>as_string

Converts just the username and hostnames fields into a string.

=head2 $request-E<gt>listing_request

Return true if the request is for a listing of users.

=head2 $request-E<gt>forward_request

Return true if the request is to query another host.

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
