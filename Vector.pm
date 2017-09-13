#!/usr/bin/perl

package Oyster::Vector;

use strict;
use warnings;

use Math::Complex;

# Constructor

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

sub mult {
	my ($self, $scalar) = @_;
	$self->{x} *= $scalar;
	$self->{y} *= $scalar;
	return $self;
}

sub div {
	my ($self, $scalar) = @_;
	$self->{x} /= $scalar;
	$self->{y} /= $scalar;
	return $self;
}

sub mag {
	my ($self) = @_;
	return sqrt($self->{x} * $self->{x} + $self->{y} * $self->{y});
}

sub sqrMag {
	my ($self) = @_;
	return $self->{x} * $self->{x} + $self->{y} * $self->{y};
}

sub setMag {
	my ($self, $mag) = @_;
	$self->normalize()
		 ->mult($mag);
	 return $self;
}

sub dot {
	my ($self, $other) = @_;
	return $self->{x} * $other->{x} + $self->{y} * $other->{y};
}

sub normalize {
	my ($self) = @_;
	my $m = $self->mag();
	if ($m != 0) {
		$self->div($m);
	}
	return $self;
}

sub limit {
	my ($self, $max) = @_;
	if ($self->mag() > $max) {
		$self->setMag($max);
	}
	return $self;
}

sub eq {
	my ($self, $other) = @_;
	if (!$other) {
		return 0;
	}
	if ($self eq $other) {
		return 1;
	}
	return $self->{x} == $other->{x} && $self->{y} == $other->{y};
}

sub print {
	my ($self) = @_;
	print "[$self->{x}, $self->{y}]\n";
}

1;