#!/usr/bin/perl

package Oyster::Vector;

use strict;
use warnings;

sub new {
	my ($class, $x, $y) = @_;
	my $self = {
		x => $x,
		y => $y
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub print {
	my ($self) = @_;
	print "[$self->{x}, $self->{y}]\n";
}

sub add {
	my ($self, $other) = @_;
	$self->{x} += $other->{x};
	$self->{y} += $other->{y};
	return $self;
}

sub sub {
	my ($self, $other) = @_;
	$self->{x} -= $other->{x};
	$self->{y} -= $other->{y};
	return $self;
}



1;