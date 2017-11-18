#!/usr/bin/perl

package Oyster::View;

use strict;
use warnings;

use Time::HiRes;

use utf8;
binmode STDOUT, ":utf8";

use TreeSet;
use Data::Dumper;

# Constructor

sub new {
	my ($class) = @_;
	my $self = {

	};
	bless ($self, $class);
	return $self;
}

sub drawWorld {
	my ($self, $world) = @_;
	if (!$self->{blank}) {
		$self->{blank} = $self->newFrame($world);
	}
	# Create new frame from blank template
	@{$self->{frame}} = @{$self->{blank}};

	for my $entity (@{$world->{entities}->{contents}}) {
		if ($self->{debug}) {
			# Draw collider for entity
			if ($entity->getCollider()) {
				$self->drawBoxCollider($entity, 'X');
			}
		} else {
			my $drawCoord = $self->worldToView($entity->getLocation());
			$self->drawSprite($drawCoord, $entity->getSprite());
		}
	}
	$self->printFrame();
}

sub newFrame {
	my ($self, $world) = @_;
	my @frame;
	my $bw = $self->getBorderW();
	# No border
	if ($bw < 1) {
		for (my $y = 0; $y < $world->{height}; $y++) {
			$frame[$y] = ' ' x $world->{width};
		}
		return \@frame;
	}
	my $rows = $world->{height} + $bw * 2;
	my $cols = $world->{width} + $bw * 2;
	my $b = $self->{border};

	for (my $y = 0; $y < $rows; $y++) {
		if ($y < $bw) {
			# Top rows
			$frame[$y] = $b->{left} x $y.$b->{topLeft}
							.$b->{top} x ($world->{width} + 2 * ($bw - $y - 1))
							.$b->{topRight}.$b->{right} x $y;
		} elsif ($y > $rows - $bw - 1) {
			# Bottom rows
			$frame[$y] = $b->{left} x ($rows - $y - 1).$b->{bottomLeft}
							.$b->{bottom} x ($world->{width} + 2 * ($bw - ($rows - $y - 1) - 1))
							.$b->{bottomRight}.$b->{right} x ($rows - $y - 1);
		} else {
			# Middle rows
			$frame[$y] = $self->{border}->{left} x $bw.' ' x $world->{width}.$self->{border}->{right} x $bw;
		}
	}
	return \@frame;
}

sub printFrame {
	my ($self) = @_;
	moveCursor(Oyster::Vector->new(0, 0));
	for my $line (@{$self->{frame}}) {
		print $line."\n";
	}
}

sub setBorder {
	my ($self, $border) = @_;
	$self->{border} = $border;
}

sub getBorderW {
	my ($self) = @_;
	return $self->{border}->{width} ? $self->{border}->{width} : 0;
}

sub drawSprite {
	my ($self, $origin, $sprite) = @_;
	my $bw = $self->getBorderW();
	# For each row in the sprite
	for (my $y = 0; $y < scalar $sprite->getData(); $y++) {
		my $drawY = $origin->{y} + $y;
		# Only draw sprite rows inside frame
		if ($drawY < scalar @{$self->{frame}} - $bw) {
			# Get reference current frame row to modify
			my $frameRowRef = \${$self->{frame}}[$drawY];
			# Split current sprite row into array of chars
			my @spriteRow = split //, ${$sprite->{data}}[$y];
			for (my $x = 0; $x < scalar @spriteRow; $x++) {
				# Position to on frame to draw
				my $drawX = $origin->{x} + $x;
				# Add non-transparent sprite row chars to frame row and
				# ensure chars aren't drawn outside frame
				if ($spriteRow[$x] ne ' ' && $drawX < (length $$frameRowRef) - $bw) {
					substr($$frameRowRef, $drawX, 1) = $spriteRow[$x];
				}
			}
		}
	}
}

sub moveCursor {
	my ($coord) = @_;
	print "\e[".$coord->{y}.";".$coord->{x}."f";
}

sub worldToView {
	my ($self, $pos) = @_;
	my $bw = $self->getBorderW();
	my $x = sprintf("%.0f", $pos->{x}) + $bw;
	my $y = sprintf("%.0f", $pos->{y}) + $bw; 
	return Oyster::Vector->new($x, $y);
}

sub clearScreen {
	# Clear
	print "\e[2J";
	# Home
	print "\e[H";
}

sub hideCursor {
	print "\e[?25l";
}

sub showCursor {
	print "\e[?25h";
}

sub setDebug {
	my ($self, $flag) = @_;
	$self->{debug} = $flag;
}

sub drawRect {
	my ($self, $x1, $y1, $x2, $y2, $pixel, $fill) = @_;
	for (my $x = $x1; $x <= $x2; $x++) {
		for (my $y = $y1; $y <= $y2; $y++) {
			if ($fill || (!$fill &&
				$x == $x1 || $x == $x2 || 
				$y == $y1 || $y == $y2)) {
				$self->drawPixel($x, $y, $pixel);
			}
		}
	}
}

sub drawPixel {
	my ($self, $x, $y, $pixel) = @_;
	my $bw = $self->getBorderW();
	if ($y < scalar @{$self->{frame}} - $bw) {
		my $frameRowRef = \${$self->{frame}}[$y];
		if ($x < (length $$frameRowRef) - $bw) {
			substr($$frameRowRef, $x, 1) = $pixel;
		}
	}
}

sub drawBoxCollider {
	my ($self, $entity, $pixel) = @_;
	my $off = $self->worldToView($entity->getLocation());
	$self->drawRect($off->{x} + $entity->getCollider()->{x1},
				    $off->{y} + $entity->getCollider()->{y1},
				    $off->{x} + $entity->getCollider()->{x2},
				    $off->{y} + $entity->getCollider()->{y2},
				    $pixel);
}

sub drawLine {
	my ($self, $x0, $y0, $x1, $y1, $pixel) = @_;
	# Bresenham's line algorithm
    my $steep = abs($y1 - $y0) > abs($x1 - $x0);
    if ($steep) {
		($y0, $x0) = ($x0, $y0);
		($y1, $x1) = ($x1, $y1);
    }
    if ($x0 > $x1) {
		($x1, $x0) = ($x0, $x1);
		($y1, $y0) = ($y0, $y1);
    }
    my $deltax = $x1 - $x0;
    my $deltay = abs($y1 - $y0);
    my $error = $deltax / 2;
    my $ystep;
    my $y = $y0;
    my $x;
    $ystep = $y0 < $y1 ? 1 : -1;
	for( $x = $x0; $x <= $x1; $x += 1 ) {
		if ( $steep ) {
			$self->drawPixel($y, $x, $pixel);
		} else {
			$self->drawPixel($x, $y, $pixel);
		}
		$error -= $deltay;
		if ( $error < 0 ) {
			$y += $ystep;
			$error += $deltax;
		}
	}
}

sub drawPolygonVerts {
	my ($self, $vertices, $pixel) = @_;
	my $n = 0;
	for my $v (@{$vertices}) {
		$self->drawPixel($v->{x}, $v->{y}, $n);
		$n++;
	}
}

sub drawPolygonEdges {
	my ($self, $vertices, $pixel) = @_;
	my @vertices = @{$vertices};

	# Connect points
	my $lastVertInd = (scalar @vertices) - 1;
	for (my $i = 0; $i < $lastVertInd; $i++) {
		$self->drawLine($vertices[$i]->{x},
						$vertices[$i]->{y},
		                $vertices[$i + 1]->{x},
						$vertices[$i + 1]->{y},
						$pixel);
	}

	# Close shape
	$self->drawLine($vertices[0]->{x},
					$vertices[0]->{y},
	                $vertices[$lastVertInd]->{x},
					$vertices[$lastVertInd]->{y},
					$pixel);
}

sub drawRect {
	my ($self, $x1, $y1, $x2, $y2, $pixel) = @_;
	my @verts = (
		Oyster::Vector->new($x1, $y1),
		Oyster::Vector->new($x2, $y1),
		Oyster::Vector->new($x2, $y2),
		Oyster::Vector->new($x1, $y2)
	);
	$self->drawPolygonEdges(\@verts, $pixel);
}

1;