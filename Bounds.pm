#!/usr/bin/perl

package Oyster::Bounds;

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

sub setBounds {
	my ($self, $x1, $y1, $x2, $y2) = @_;
	$self->{x1} = $x1;
	$self->{y1} = $y1;
	$self->{x2} = $x2;
	$self->{y2} = $y2;
}

sub print {
	my ($self) = @_;
	print "[x1: $self->{x1}, y1: $self->{y1}, x2: $self->{x2}, y2: $self->{y2}]\n";
}

1;