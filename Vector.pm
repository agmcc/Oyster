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

# Static methods

sub sAdd {
	my ($class, $a, $b) = @_;
	return $class->new($a->{x} + $b->{x}, $a->{y} + $b->{y});
}

sub sSub {
	my ($class, $a, $b) = @_;
	return $class->new($a->{x} - $b->{x}, $a->{y} - $b->{y});
}

sub sMult {
	my ($class, $a, $b) = @_;
	return $class->new($a->{x} * $b, $a->{y} * $b);
}

sub sDiv {
	my ($class, $a, $b) = @_;
	return $class->new($a->{x} / $b, $a->{y} / $b);
}

sub sClone {
	my ($class, $a) = @_;
	return $class->new($a->{x}, $a->{y});
}

sub sDist {
	my ($class, $a, $b) = @_;
	my $diff = $class->sSub($a, $b);
	return $diff->mag();
}

sub sNormalize {
	my ($class, $a) = @_;
	my $c = $class->sClone($a);
	return $c->normalize();
}

1;