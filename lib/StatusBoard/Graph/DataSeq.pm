package StatusBoard::Graph::DataSeq;

use strict;
use warnings;
use utf8;

use Carp;

my $true = 1;
my $false = '';

sub new {
    my ($class, %opts) = @_;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub set_title {
    my ($self, $title) = @_;

    $self->{__title} = $title;

    return $false;
}

sub has_color {
    my ($self) = @_;

    return defined($self->{__color}) ? $true : $false;
}

sub set_color {
    my ($self, $color) = @_;

    $self->{__color} = $color;

    return $false;
}

sub get_color {
    my ($self) = @_;

    croak "No color. Stopped" if not $self->has_color();

    return $self->{__color};
}

sub set_values {
    my ($self, $values) = @_;

    if (ref $values ne 'ARRAY') {
        croak "Incorrect values. Stopped";
    }

    $self->{__values} = $values;

    return $false;
}

sub get_values {
    my ($self) = @_;

    my $v = $self->{__values};

    if (not defined $v) {
        croak "No values in StatusBoard::Graph::DataSeq. Stopped";
    }

    return $self->{__values};
}


1;
