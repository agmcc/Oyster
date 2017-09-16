#!/usr/bin/perl

package Oyster::World;

use strict;
use warnings;

use Time::HiRes;

use Data::Dumper;

use constant {
	WRAP => 0
};

# Constructor

sub new {
	my ($class, $w, $h, $bounds) = @_;
	my $self = {
		width => $w,
		height => $h,
		entities => [],
		tickRate => 1,
		bounds => $bounds
	};
	bless ($self, $class);
	return $self;
}

sub tick {
	my ($self) = @_;
	# print "Tick\n";
	for my $e (@{$self->{entities}}) {
		$e->update();
		$self->checkBounds($e);
	}
}

sub checkBounds {
	my ($self, $e) = @_;
	# Configurable e.g. No border, wrap around, invert, callback?

	# Wrap around implementation
	if ($self->{bounds} == WRAP) {
		if ($e->{location}->{x} > $self->{width}) {
			$e->{location}->{x} = 0;
		}

		if ($e->{location}->{x} < 0) {
			$e->{location}->{x} = $self->{width};
		}

		if ($e->{location}->{y} > $self->{height}) {
			$e->{location}->{y} = 0;
		}

		if ($e->{location}->{y} < 0) {
			$e->{location}->{y} = $self->{height};
		}
	}
}

sub play {
	my ($self) = @_;
	while (1) {
		tick($self);
		sleep(1 / $self->{tickRate});
	}
}

sub addEntity {
	my ($self, $e) = @_;
	push (@{$self->{entities}}, $e);
}

1;