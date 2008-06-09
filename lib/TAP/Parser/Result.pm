package TAP::Parser::Result;

use strict;
use vars qw($VERSION @ISA);

use TAP::Object ();

@ISA = 'TAP::Object';

BEGIN {
    # make is_* methods
    my @attrs = qw( plan pragma test comment bailout version unknown yaml );
    no strict 'refs';
    for my $token ( @attrs ) {
        my $method = "is_$token";
        *$method = sub { return $token eq shift->type };
    }
}

##############################################################################

=head1 NAME

TAP::Parser::Result - Base class for TAP::Parser output objects

=head1 VERSION

Version 3.12

=cut

$VERSION = '3.12';

=head2 DESCRIPTION

This is a base class for objects representing the current bit of test data from
TAP (usually a line).

=cut

##############################################################################

=head2 METHODS

=head3 C<new>

  # see TAP::Parser::ResultFactory for preferred usage

  # to use directly:
  my $result = TAP::Parser::Result->new($token);

Returns an instance the appropriate class for the test token passed in.

=cut

# new() implementation provided by TAP::Object

=head2 Boolean methods

The following methods all return a boolean value and are to be overridden in
the appropriate subclass.

=over 4

=item * C<is_plan>

Indicates whether or not this is the test plan line.

 1..3

=item * C<is_pragma>

Indicates whether or not this is a pragma line.

 pragma +strict

=item * C<is_test>

Indicates whether or not this is a test line.

 ok 1 Is OK!

=item * C<is_comment>

Indicates whether or not this is a comment.

 # this is a comment

=item * C<is_bailout>

Indicates whether or not this is bailout line.

 Bail out! We're out of dilithium crystals.

=item * C<is_version>

Indicates whether or not this is a TAP version line.

 TAP version 4

=item * C<is_unknown>

Indicates whether or not the current line could be parsed.

 ... this line is junk ...

=item * C<is_yaml>

Indicates whether or not this is a YAML chunk.

=back

=cut

##############################################################################

=head3 C<raw>

  print $result->raw;

Returns the original line of text which was parsed.

=cut

sub raw { shift->{raw} }

##############################################################################

=head3 C<type>

  my $type = $result->type;

Returns the "type" of a token, such as C<comment> or C<test>.

=cut

sub type { shift->{type} }

##############################################################################

=head3 C<as_string>

  print $result->as_string;

Prints a string representation of the token.  This might not be the exact
output, however.  Tests will have test numbers added if not present, TODO and
SKIP directives will be capitalized and, in general, things will be cleaned
up.  If you need the original text for the token, see the C<raw> method.

=cut

sub as_string { shift->{raw} }

##############################################################################

=head3 C<is_ok>

  if ( $result->is_ok ) { ... }

Reports whether or not a given result has passed.  Anything which is B<not> a
test result returns true.  This is merely provided as a convenient shortcut.

=cut

sub is_ok {1}

##############################################################################

=head3 C<passed>

Deprecated.  Please use C<is_ok> instead.

=cut

sub passed {
    warn 'passed() is deprecated.  Please use "is_ok()"';
    shift->is_ok;
}

##############################################################################

=head3 C<has_directive>

  if ( $result->has_directive ) {
     ...
  }

Indicates whether or not the given result has a TODO or SKIP directive.

=cut

sub has_directive {
    my $self = shift;
    return ( $self->has_todo || $self->has_skip );
}

##############################################################################

=head3 C<has_todo>

 if ( $result->has_todo ) {
     ...
 }

Indicates whether or not the given result has a TODO directive.

=cut

sub has_todo { 'TODO' eq ( shift->{directive} || '' ) }

##############################################################################

=head3 C<has_skip>

 if ( $result->has_skip ) {
     ...
 }

Indicates whether or not the given result has a SKIP directive.

=cut

sub has_skip { 'SKIP' eq ( shift->{directive} || '' ) }

=head3 C<set_directive>

Set the directive associated with this token. Used internally to fake
TODO tests.

=cut

sub set_directive {
    my ( $self, $dir ) = @_;
    $self->{directive} = $dir;
}

1;
