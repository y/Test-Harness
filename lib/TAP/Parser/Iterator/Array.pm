package TAP::Parser::Iterator::Array;

use strict;
use vars qw($VERSION @ISA);

use TAP::Parser::Iterator ();

@ISA = 'TAP::Parser::Iterator';

=head1 NAME

TAP::Parser::Iterator::Array - Internal TAP::Parser array Iterator

=head1 VERSION

Version 3.12

=cut

$VERSION = '3.12';

=head1 SYNOPSIS

  # see TAP::Parser::IteratorFactory for preferred usage

  # to use directly:
  use TAP::Parser::Iterator::Array;
  my $it = TAP::Parser::Iterator::Array->new(\@array);

  my $line = $it->next;

Originally ripped off from L<Test::Harness>.

=head1 DESCRIPTION

B<FOR INTERNAL USE ONLY!>

This is a simple iterator wrapper for arrays.

=head2 Class Methods

=head3 C<new>

Create an iterator.

=head2 Instance Methods

=head3 C<next>

Iterate through it, of course.

=head3 C<next_raw>

Iterate raw input without applying any fixes for quirky input syntax.

=head3 C<wait>

Get the wait status for this iterator. For an array iterator this will always
be zero.

=head3 C<exit>

Get the exit status for this iterator. For an array iterator this will always
be zero.

=cut

# new() implementation supplied by TAP::Object

sub _initialize {
    my ( $self, $thing ) = @_;
    chomp @$thing;
    $self->{idx}   = 0;
    $self->{array} = $thing;
    $self->{exit}  = undef;
    return $self;
}

sub wait { shift->exit }

sub exit {
    my $self = shift;
    return 0 if $self->{idx} >= @{ $self->{array} };
    return;
}

sub next_raw {
    my $self = shift;
    return $self->{array}->[ $self->{idx}++ ];
}

1;

=head1 SEE ALSO

L<TAP::Object>,
L<TAP::Parser>,
L<TAP::Parser::Iterator>,
L<TAP::Parser::IteratorFactory>,

=cut

