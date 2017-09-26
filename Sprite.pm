#!/usr/bin/perl

package Oyster::Sprite;

use strict;
use warnings;

# Constructor

sub new {
	my ($class, $name, $data) = @_;
	my $self = {
		name => $name,
		data => $data
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub getData {
	my ($self) = @_;
	return @{$self->{data}};
}

1;