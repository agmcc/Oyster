#!/usr/bin/perl

package Oyster::Border;

use strict;
use warnings;

use constant {
	LEFT => "\x{2502}",
	RIGHT => "\x{2502}",
	TOP => "\x{2500}",
	BOTTOM => "\x{2500}",
	TOP_LEFT => "\x{250C}",
	TOP_RIGHT => "\x{2510}",
	BOTTOM_LEFT => "\x{2514}",
	BOTTOM_RIGHT => "\x{2518}"
};

# Constructor

sub new {
	my ($class) = @_;
	my $self = {
		width => 1,
		left => LEFT,
		right => RIGHT,
		top => TOP,
		bottom => BOTTOM,
		topLeft => TOP_LEFT,
		topRight => TOP_RIGHT,
		bottomLeft => BOTTOM_LEFT,
		bottomRight => BOTTOM_RIGHT
	};
	bless ($self, $class);
	return $self;
}

# Instance methods

sub setWidth {
	my ($self, $width) = @_;
	$self->{width} = sprintf("%.0f", $width);
}

sub setChars {
	my ($self, $left, $right, $top, $bottom, 
		$topLeft, $topRight, $bottomLeft, $bottomRight) = @_;

	$self->{left} = $left;
	$self->{right} = $right;
	$self->{top} = $top;
	$self->{bottom} = $bottom;
	$self->{topLeft} = $topLeft;
	$self->{topRight} = $topRight;
	$self->{bottomLeft} = $bottomLeft;
	$self->{bottomRight} = $bottomRight;
}

1;