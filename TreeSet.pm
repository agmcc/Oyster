#!/usr/bin/perl

package Oyster::TreeSet;

use strict;
use warnings;
use Data::Dumper;

# Constructor

sub new {
	my ($class, $comparator) = @_;
	my $self = {
		contents => [],
		comparator => $comparator
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub add {
	my ($self, $item) = @_;
	# Sorts by comparator
	my $length = scalar @{$self->{contents}};

	if ($length < 1) {
		# Empty - add first element
		push @{$self->{contents}}, $item;
	} else {
		# At least 1 element in array
		for (my $i = 0; $i < $length; $i++) {
			# Attempt to add immediately before bigger number
			if ($self->{comparator}->($item, ${$self->{contents}}[$i]) >= 0) {
				splice @{$self->{contents}}, $i, 0, $item;
				return;
			}
		}
		# No items bigger - add to end
		splice @{$self->{contents}}, $length, 0, $item;
	}
}

sub print {
	my ($self) = @_;
	print "TreeSet: ";
	for my $e (@{$self->{contents}}) {
		print $e.", ";
	}
	print "\n";
}

1;