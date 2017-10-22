#!/usr/bin/perl

package Oyster::Sprite;

use strict;
use warnings;

use Vector;

# Constructor

sub new {
	my ($class, $name, @data) = @_;
	my $self = {
		name => $name,
		data => \@data
	};
	bless ($self, $class);
	$self->calculateMax();
	return $self;
}

# Instance methods

sub getData {
	my ($self) = @_;
	return @{$self->{data}};
}

sub calculateMax {
	my ($self) = @_;
	# Calc max width
	my $maxW = 0;
	for my $line (@{$self->{data}}) {
		my $l = length $line;
		if ($l > $maxW) {
			$maxW = $l;
		}
	}
	$self->{maxW} = Oyster::Vector->new($maxW, scalar @{$self->{data}});
	$self->{maxH} = scalar @{$self->{data}};
}

1;