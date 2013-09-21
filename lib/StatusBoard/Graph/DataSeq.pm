package StatusBoard::Graph::DataSeq;

# ABSTRACT: datasequences representation for the StatusBoard::Graph

=head1 SYNOPSIS

    use StatusBoard::Graph::DataSeq;

    my $ds = StatusBoard::Graph::DataSeq->new();
    $ds->set_title("X-Cola");
    $ds->set_values(
        [
            2008 => 22,
            2009 => 24,
            2010 => 25.5,
            2011 => 27.9,
            2012 => 31,
        ]
    );

=head1 DESCRIPTION

This is and class StatusBoard::Graph::DataSeq that is used in
StatusBoard::Graph.

=cut

use strict;
use warnings;
use utf8;

use Carp;

my $true = 1;
my $false = '';

=method new

This a constuctor. It creates StatusBoard::Graph object. It don't need any
parameters.

    my $ds = StatusBoard::Graph::DataSeq->new();

=cut

sub new {
    my ($class, %opts) = @_;

    croak "Constructor new() does not need any parameters." if %opts;

    my $self = {};
    bless $self, $class;

    return $self;
}

=method set_title

Sets title for the datasequences. This parameter is mandatory.

    $ds->set_title("X-Cola");

=cut

sub set_title {
    my ($self, $title) = @_;

    $self->{__title} = $title;

    return $false;
}

=method get_title

Returns the title of the object or dies if there is no title.

=cut

sub get_title {
    my ($self) = @_;

    croak "No title. Stopped" if not defined $self->{__title};

    return $self->{__title};
}

=method set_color

Sets the color for the datasequence. Color values can be yellow, green, red,
purple, blue, mediumGray, pink, aqua, orange, or lightGray.

If the color is not set then StatusBoard App will choose the color randomly.

=cut

sub set_color {
    my ($self, $color) = @_;

    $self->{__color} = $color;

    return $false;
}

=method has_color

Returns bool value if the color is set.

=cut

sub has_color {
    my ($self) = @_;

    return defined($self->{__color}) ? $true : $false;
}

=method get_color

Returns the color or dies if no color is set.

=cut

sub get_color {
    my ($self) = @_;

    croak "No color. Stopped" if not $self->has_color();

    return $self->{__color};
}

=method set_values

Sets the values for the datasequence. The method shuold recieve arrayref with
pairs of values. First element in the pair will be used for the title and the
second will be used for the value.

    $ds->set_values(
        [
            2008 => 22,
            2009 => 24,
            2010 => 25.5,
            2011 => 27.9,
            2012 => 31,
        ]
    );

=cut

sub set_values {
    my ($self, $values) = @_;

    if (ref $values ne 'ARRAY') {
        croak "Incorrect values. Stopped";
    }

    $self->{__values} = $values;

    return $false;
}

=method get_values

Returns the values or dies if there are no values.

=cut

sub get_values {
    my ($self) = @_;

    my $v = $self->{__values};

    if (not defined $v) {
        croak "No values in StatusBoard::Graph::DataSeq. Stopped";
    }

    return $self->{__values};
}

=head1 TODO

Several move things should be done.

=over

=item * Check that color is one of yellow, green, red, purple, blue,
mediumGray, pink, aqua, orange, or lightGray

=item * Die if the title is not set

=item * has_values()

=back

=cut

1;
