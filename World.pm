#!/usr/bin/perl

package Oyster::World;

use strict;
use warnings;

# Constructor

sub new {
	my ($class, $w, $h) = @_;
	my $self = {
		width => $w,
		height => $h,
		entities => []
	};
	bless ($self, $class);
	return $self;
}

sub updateAll {
	my ($self) = @_;
	for my $e ($self->{entities}) {
		
	}
}

1;