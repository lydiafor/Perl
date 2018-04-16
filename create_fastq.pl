#!/usr/bin/perl

#MERGING FASTA AND QUAL FILES INTO FASTQ

use strict;
use warnings;
use Data::Dumper;

#Declare and initialize variables

our ($name, @fasta, @qual, %seqs, %quals, %ascii_code, %ascii_quals);

open(FASTA, "< $ARGV[0]") or die "Introduce FASTA file\n";
@fasta = <FASTA>;

#Store the name of the file for the required inputs

$name = $ARGV[0];
$name =~ s/.fa.*$//;

close(FASTA);

#Store fasta information intp a hash

%seqs = &get_fasta(@fasta);

#Store qual information into a hash 
#if there is not qual file provided, create a fake scoring for the sequences

if (scalar(@ARGV) < 2) {
	print STDOUT "<< CREATING FAKE SCORING\n";
	%quals = &get_fake_quals(%seqs);
} else {
	open(QUAL, "< $ARGV[1]");
	@qual = <QUAL>;
	%quals = &get_quals(@qual);
}

close(QUAL);

# Convert quality scores into ascii code

%ascii_quals = &get_ascii_score(%quals);


#Create FASTQ file

print STDOUT ">> CREATING FASTQ\n";
&create_fastq($name, \%seqs, \%ascii_quals);

#Compute statistics analysis for sequences and qualities

&get_statitics($name, \%seqs, \%quals);

exit(0);

##FUNCTIONS DECLARATION

#Subroutine to get fasta information

sub get_fasta() {
	
	my (@input, %seqs, $id, $seq);
	@input = @_;

	for (my $i=0; $i < scalar(@input); $i++) {
		chomp $input[$i];
		if ($input[$i] =~ /^>/) {
			$id = $input[$i];
			$id =~ s/>//;
			$id =~ s/\s.*bp$//;
			$seqs{$id} = "";
		}
		else {
			$seq = $input[$i];
			$seqs{$id} .= $seq;
		}
	}
	return %seqs;
}

#Subroutine to qet qual information

sub get_quals() {

	my (@input, %quals, $id, $qual);
	@input = @_;

	for (my $i=0; $i<scalar(@input); $i++) {
		chomp $input[$i];
		if ($input[$i] =~ />/) {
			$id = $input[$i];
			$id =~ s/^>//;
			$id =~ s/\s.*bp$//; 
			$quals{$id} = "";
		}
		else {
			$qual = $input[$i];
			$quals{$id} .= $qual." ";
		}
	}
	return %quals;
}

#Subrutine to create a fake scoring qualities

sub get_fake_quals() {

	my (%seqs, %quals, $max, $min, $id, $qual, @fake_quals);
	%seqs = @_;
	$max = 50;
	$min = 20;

	foreach $id (sort keys %seqs) {
		$quals{$id} = "";
		my @basis = split//, $seqs{$id};
		for (my $i=0; $i < scalar(@basis); $i++) {
			$qual = $min + int(rand($max - $min + 1));
			push @fake_quals, $qual;
		}
		$quals{$id} = join(" ", @fake_quals);
		undef @fake_quals;
	}
	return %quals;
}

#Subroutine to convert numeric quality into asii code

sub get_ascii_score() {
	my (%quals, %code, %ascii_quals, $id, $qual);
	%quals = @_;

	open(ASCII, "<ASCII_code.txt") or die "Could not open ascci file";

	while (<ASCII>) {
		chomp;
		my @elements = split /\t/, $_;
		$code{$elements[0]} = $elements[1];
	} 

	foreach $id (sort keys %quals) {
		$ascii_quals{$id} = "";
		$qual = $quals{$id};
		my @scores = split /\s/, $qual;
		my @ascii_scores;
		my $n = scalar(@scores);
	
		for (my $i=0; $i<$n; $i++) {
			my $ascii_score = $code{$scores[$i]};
			push @ascii_scores, $ascii_score;
		}
	$ascii_quals{$id} = join(" ", @ascii_scores);
	}
	return %ascii_quals;
	close(ASCII);
}

#Subroutine to create FASTQ file

sub create_fastq() {
	my $name = $_[0];
	my %seqs = %{$_[1]};
	my %scores = %{$_[2]};

	open(FASTQ, ">$name.fastq");

	foreach my $id (sort keys %seqs) {
		foreach my $id2 (sort keys %scores) {
			if ($id eq $id2) {
				print FASTQ "\@$id\n$seqs{$id}\n+\n$ascii_quals{$id2}\n";
			}
		}
	}
}

#Subroutine to compute statistics for each sequence and its quality

sub get_statitics() {
	my ($id, %stat, $name, %seqs, %quals);
	$name = $_[0];
	%seqs = %{$_[1]};
	%quals = %{$_[2]};

	#Compute sequence statistics

	my ($len, @basis, $Ac, $Cc, $Gc, $Tc, $Ap, $Cp, $Gp, $Tp, $CGp);

	foreach $id (sort keys %seqs) {
		$stat{$id} = {};
		$len = length($seqs{$id});
		@basis = split//, $seqs{$id};
		$Ac = $Cc = $Gc = $Tc = 0;

		for (my $i =0; $i < scalar(@basis); $i++) {
			my $char = $basis[$i];

			SWITCH: {
				($char =~/A/) && do {
					$Ac++;
					last SWITCH;
				};
				($char =~/C/) && do {
					$Cc++;
					last SWITCH;
				};
				($char =~/T/) && do {
					$Tc++;
					last SWITCH;
				};
				($char =~/G/) && do {
					$Gc++;
				};
			}
		}

		$Ap = $Ac / $len * 100;
		$Cp = $Cc / $len * 100;
		$Tp = $Tc / $len * 100;
		$Gp = $Gc / $len * 100;
		$CGp = ($Cc + $Gc) / $len * 100;
		$stat{$id}{"A"} = $Ap;
		$stat{$id}{"C"} = $Cp;
		$stat{$id}{"T"} = $Tp;
		$stat{$id}{"G"} = $Gp;
		$stat{$id}{"CG"} = $CGp;
	}

	#Compute quality statistics
	my (@nums, $num, $min, $max, $sum, $sum2, $mean, $var, $stdev);
	
	foreach $id (sort keys %quals) {
		@nums = split/\s+/, $quals{$id};
		$min = $max = $sum =0;
		$len = scalar(@nums);

		for (my $i=0; $i< $len; $i++) {
			$num = int($nums[$i]);
			$sum += $num;
			$sum2 += $num ** 2;
			if ($num > $max) {
				$max = $num;
			}
			if ($min == 0) {
				$min = $num;
			}
			elsif ($num < $min) {
				$min = $num;
			}
		}
		$mean = $sum / $len;
		$var = ($sum2 - ($sum ** 2 / $len)) / ($len -1);
		$stdev = sqrt($var);
		$stat{$id}{"mean"} = $mean;
		$stat{$id}{"stdev"} = $stdev;
		$stat{$id}{"max"} = $max;
		$stat{$id}{"min"} = $min;
	}

	print STDERR ">> STATISTICS\n".
				"id\t%A\t%C\t%T\t%G\t%CG\t".
				"mean coverage\tstandard deviation\tmaximum\tminumum\n";
	
	foreach $id (sort keys %stat) {
		printf STDERR "%s\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n",
					$id, $stat{$id}{A}, $stat{$id}{C}, $stat{$id}{T}, $stat{$id}{G}, $stat{$id}{CG},
					$stat{$id}{mean}, $stat{$id}{stdev}, $stat{$id}{max}, $stat{$id}{min};
	}
}
