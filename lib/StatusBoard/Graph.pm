package StatusBoard::Graph;

# ABSTRACT: create JSON with graph data for Status Board iPad App

=head1 SYNOPSIS

    use StatusBoard::Graph;
    use StatusBoard::Graph::DataSeq;

    my $sg = StatusBoard::Graph->new();
    $sg->set_title("Soft Drink Sales");

    my $ds1 = StatusBoard::Graph::DataSeq->new();
    $ds1->set_title("X-Cola");
    $ds1->set_values(
        [
            2008 => 22,
            2009 => 24,
            2010 => 25.5,
            2011 => 27.9,
            2012 => 31,
        ]
    );

    $sg->add_data_seq($ds1);

    my $ds2 = StatusBoard::Graph::DataSeq->new();
    $ds2->set_title("Y-Cola");
    $ds2->set_values(
        [
            2008 => 18.4,
            2009 => 20.1,
            2010 => 24.8,
            2011 => 26.1,
            2012 => 29,
        ]
    );

    $sg->add_data_seq($ds2);

    $sg->write_json("cola.json");

Here is the screenshot of how this JSON file looks in the Status Board App
(the screenshot is clickable):

=begin HTML

<p>
<a href="http://upload.bessarabov.ru/bessarabov/031VBX4pHw_ALPcxRTVjflnAWuc.png">
<img src="http://upload.bessarabov.ru/bessarabov/VdagpUXEQdMslOqUyOAzwa-DOaU.png" width="500" height="125" alt="Status board graph sample" />
</a>
</p>

=end HTML

=head1 DESCRIPTION

There is a great iPad App called Status Board
L<http://www.panic.com/statusboard/>. It can show differect types of
information. One type is a Graph. To create that Graph one can use CSV format,
or use more powerfull JSON format.

This module simplifies the process of creation JSONs for Status Board App.
Here is the specification of JSON format:
L<http://www.panic.com/statusboard/docs/graph_tutorial.pdf>

=cut

use strict;
use warnings;
use utf8;

use Carp;
use JSON;
use File::Slurp;
use Clone qw(clone);

my $true = 1;
my $false = '';

=method new

=cut

sub new {
    my ($class, %opts) = @_;

    croak "Constructor new() does not need any parameters." if %opts;

    my $self = {};
    bless $self, $class;

    return $self;
}

=method get_json

=cut

sub get_json {
    my ($self) = @_;

    my $json = to_json(
        $self->__get_data()
    );

    return $json;
}

=method get_pretty_json

=cut

sub get_pretty_json {
    my ($self) = @_;

    my $pretty_json = to_json(
        $self->__get_data(),
        {
            pretty => 1,
        },
    );

    return $pretty_json;
}

=method write_json

=cut

sub write_json {
    my ($self, $file_name) = @_;

    write_file(
        $file_name,
        {binmode => ':utf8'},
        $self->get_pretty_json(),
    );

    return $false;
}

=method set_title

=cut

sub set_title {
    my ($self, $title) = @_;

    $self->{__title} = $title;

    return $false;
}

=method has_title

=cut

sub has_title {
    my ($self) = @_;

    return defined($self->{__title}) ? $true : $false;
}

=method get_title

=cut

sub get_title {
    my ($self) = @_;

    croak "No title. Stopped" if not $self->has_title();

    return $self->{__type};
}

=method set_type

=cut

sub set_type {
    my ($self, $type) = @_;

    $self->{__type} = $type;

    return $false;
}

=method has_type

=cut

sub has_type {
    my ($self) = @_;

    return defined($self->{__type}) ? $true : $false;
}

=method get_type

=cut

sub get_type {
    my ($self) = @_;

    croak "No type. Stopped" if not $self->has_type();

    return $self->{__type};
}

=method add_data_seq

=cut

sub add_data_seq {
    my ($self, $data_seq) = @_;

    push @{$self->{__data_seqs}}, $data_seq;

    return $false;
}

=method set_min_y_value

=cut

sub set_min_y_value {
    my ($self, $number) = @_;

    $self->{__min_y_value} = $number;

    return $false;
}

=method has_min_y_value

=cut

sub has_min_y_value {
    my ($self) = @_;

    return defined($self->{__min_y_value}) ? $true : $false;
}

=method get_min_y_value

=cut

sub get_min_y_value {
    my ($self) = @_;

    croak "No min y value. Stopped" if not $self->has_min_y_value();

    return $self->{__min_y_value};
}

=method set_max_y_value

=cut

sub set_max_y_value {
    my ($self, $number) = @_;

    $self->{__max_y_value} = $number;

    return $false;
}

=method has_max_y_value

=cut

sub has_max_y_value {
    my ($self) = @_;

    return defined($self->{__max_y_value}) ? $true : $false;
}

=method get_max_y_value

=cut

sub get_max_y_value {
    my ($self) = @_;

    croak "No max y value. Stopped" if not $self->has_max_y_value();

    return $self->{__max_y_value};
}

sub __get_data {
    my ($self) = @_;

    my $data = {
        graph => {
            title => $self->{__title},
            ( $self->has_type() ? ( type => $self->get_type() ) : () ),
            datasequences => $self->__get_datasequences(),
        }
    };

    if ($self->has_min_y_value()) {
        $data->{graph}->{yAxis}->{minValue} = $self->get_min_y_value() + 0;
    }

    if ($self->has_max_y_value()) {
        $data->{graph}->{yAxis}->{maxValue} = $self->get_max_y_value() + 0;
    }

    return $data;
}

sub __get_datasequences {
    my ($self) = @_;

    my $datasequences = [];

    foreach my $ds (@{$self->{__data_seqs}}) {
        my $values = clone $ds->get_values();

        my $datapoints;
        while (@{$values}) {
            my $title = shift @{$values};
            my $value = shift @{$values};
            push @{$datapoints}, {
                title => $title . "",
                value => $value,
            };
        }

        push @{$datasequences}, {
            title => $ds->{__title},
            ( $ds->has_color ? ( color => $ds->get_color() ) : ()  ),
            datapoints => $datapoints,
        };
    }

    return $datasequences;
}

1;
