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
		$self->collisionDetection($e, @{$self->{entities}});
	}
}

sub collisionDetection {
	my ($self, $entity, @entities) = @_;
	for my $other (@entities) {
		# Hack - fix Entity::ne
		if ($other->{name} ne $entity->{name}) {
			if ($entity->intersects($other)) {
				$entity->onCollision($other);
			}
		}
	}
}

sub checkBounds {
	my ($self, $e) = @_;
	
	if ($self->{bounds} == WRAP) {
		if ($e->{velocity}->{x} > 0 &&
			$e->{location}->{x} > $self->{width} - $e->{bounds}->{x2}) {
			$e->{location}->{x} = -$e->{bounds}->{x1};
		}

		if ($e->{velocity}->{x} < 0 &&
			$e->{location}->{x} < -$e->{bounds}->{x1}) {
			$e->{location}->{x} = $self->{width} - $e->{bounds}->{x2};
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

sub removeEntity {
	my ($self, $e) = @_;
	@{$self->{entities}} = grep {$_->{name} ne $e->{name}} @{$self->{entities}};
}

1;