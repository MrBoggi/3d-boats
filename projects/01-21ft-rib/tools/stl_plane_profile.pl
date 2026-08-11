#!/usr/bin/env perl
use strict;
use warnings;

die "usage: $0 FILE [normal_limit]\n" unless @ARGV;
my ($path, $normal_limit) = @ARGV;
$normal_limit //= 0.995;

open my $fh, '<:raw', $path or die "$path: $!\n";
read($fh, my $header, 80) == 80 or die "short STL header\n";
read($fh, my $count_raw, 4) == 4 or die "missing triangle count\n";
my $count = unpack('V', $count_raw);
my (%planes, @triangles);

for (1 .. $count) {
    read($fh, my $raw, 50) == 50 or die "short triangle record\n";
    my @v = unpack('f<12', substr($raw, 0, 48));
    my ($nx, $ny, $nz) = @v[0 .. 2];
    next unless abs($nz) >= $normal_limit;
    my @xyz = @v[3 .. 11];
    my @z = @xyz[2, 5, 8];
    next unless abs($z[0] - $z[1]) < 0.002 && abs($z[0] - $z[2]) < 0.002;
    my $key = sprintf('%.3f', ($z[0] + $z[1] + $z[2]) / 3);
    push @{$planes{$key}}, [@xyz];
}

for my $z (sort { $a <=> $b } keys %planes) {
    my @t = @{$planes{$z}};
    my (@x, @y, %edges);
    for my $tri (@t) {
        push @x, @$tri[0, 3, 6];
        push @y, @$tri[1, 4, 7];
        my @p = map { [sprintf('%.3f', $tri->[3 * $_]), sprintf('%.3f', $tri->[3 * $_ + 1])] } 0 .. 2;
        for my $edge ([$p[0], $p[1]], [$p[1], $p[2]], [$p[2], $p[0]]) {
            my @ends = sort { "$a->[0],$a->[1]" cmp "$b->[0],$b->[1]" } @$edge;
            $edges{"$ends[0][0],$ends[0][1]|$ends[1][0],$ends[1][1]"}++;
        }
    }
    my @boundary = grep { $edges{$_} == 1 } keys %edges;
    next unless @t >= 2;
    printf "z=%s triangles=%d bounds=[%.3f..%.3f, %.3f..%.3f] boundary_edges=%d\n",
        $z, scalar(@t), min(@x), max(@x), min(@y), max(@y), scalar(@boundary);

    my (%adj, %unused);
    for my $edge (@boundary) {
        my ($a, $b) = split /\|/, $edge;
        push @{$adj{$a}}, $b;
        push @{$adj{$b}}, $a;
        $unused{$edge} = 1;
    }
    my @loops;
    while (%unused) {
        my ($edge) = keys %unused;
        my ($start, $next) = split /\|/, $edge;
        my @loop = ($start, $next);
        delete $unused{$edge};
        my $prev = $start;
        my $cur = $next;
        for (1 .. scalar(@boundary) + 2) {
            last if $cur eq $start;
            my ($candidate) = grep { $_ ne $prev && exists $unused{canon($cur, $_)} } @{$adj{$cur} // []};
            last unless defined $candidate;
            delete $unused{canon($cur, $candidate)};
            push @loop, $candidate;
            ($prev, $cur) = ($cur, $candidate);
        }
        push @loops, \@loop if @loop >= 4 && $loop[-1] eq $start;
    }
    my @sorted_loops = sort { abs(loop_area($b)) <=> abs(loop_area($a)) } @loops;
    if (defined $ENV{STL_PROFILE_SCAD_Z} && abs($z - $ENV{STL_PROFILE_SCAD_Z}) < 0.0006 && @sorted_loops) {
        print "SCAD_POINTS=[\n";
        for my $point (@{$sorted_loops[0]}) {
            my ($px, $py) = split /,/, $point;
            printf "  [%.3f, %.3f],\n", $px, $py;
        }
        print "];\n";
    }
    my $index = 0;
    for my $loop (@sorted_loops) {
        my (@lx, @ly);
        for (@$loop) { my ($px, $py) = split /,/; push @lx, $px; push @ly, $py; }
        printf "  loop=%d vertices=%d area=%.2f centroid=[%.3f, %.3f] bounds=[%.3f..%.3f, %.3f..%.3f]\n",
            ++$index, scalar(@$loop) - 1, loop_area($loop), loop_centroid($loop),
            min(@lx), max(@lx), min(@ly), max(@ly);
    }
}

sub canon {
    my ($a, $b) = @_;
    return $a lt $b ? "$a|$b" : "$b|$a";
}

sub loop_area {
    my ($loop) = @_;
    my $sum = 0;
    for my $i (0 .. $#$loop - 1) {
        my ($x1, $y1) = split /,/, $loop->[$i];
        my ($x2, $y2) = split /,/, $loop->[$i + 1];
        $sum += $x1 * $y2 - $x2 * $y1;
    }
    return $sum / 2;
}

sub loop_centroid {
    my ($loop) = @_;
    my ($cross_sum, $cx, $cy) = (0, 0, 0);
    for my $i (0 .. $#$loop - 1) {
        my ($x1, $y1) = split /,/, $loop->[$i];
        my ($x2, $y2) = split /,/, $loop->[$i + 1];
        my $cross = $x1 * $y2 - $x2 * $y1;
        $cross_sum += $cross;
        $cx += ($x1 + $x2) * $cross;
        $cy += ($y1 + $y2) * $cross;
    }
    return (0, 0) if abs($cross_sum) < 1e-9;
    return ($cx / (3 * $cross_sum), $cy / (3 * $cross_sum));
}

sub min { my $m = shift; for (@_) { $m = $_ if $_ < $m; } return $m; }
sub max { my $m = shift; for (@_) { $m = $_ if $_ > $m; } return $m; }
