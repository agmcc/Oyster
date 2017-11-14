#!/usr/bin/perl

package Oyster::BoxCollider;

use strict;
use warnings;

# Constructor

sub new {
	my ($class, $x1, $y1, $x2, $y2) = @_;
	my $self = {
        x1 => $x1,
        y1 => $y1,
        x2 => $x2,
        y2 => $y2
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub getWidth {
    my ($self) = @_;
    return $self->{x2} - $self->{x1};
}

sub getHeight {
    my ($self) = @_;
    return $self->{y2} - $self->{y1};
}

1;