#!/usr/bin/perl

use strict;
use warnings;

##A: Calculate the factorial of x

sub get_factorial(){
	print "Calculate the factorial of: ";
	my $num = <STDIN>; 
	chomp $num;

	my $fact = $num;

	while ($num > 1) {
		$num--;
		$fact *= $num;
	};

	print "The result is $fact\n";
}

##B: ##Count the observed frequency of a given dinucleotide and print the nucleotide position 

sub nucleotide_frequency(){
	#Initialize variables
	my ($dna,$dinucl,$freq,$pos);

	$dna = "ATCAGTCACGTTCGACTGATTCGATCGATTTCGATCAGCTACGTACG".
		"CGATCGACTTTACGTACGTACGTTCAGCTAGCTAGCTTCGATCGAT";

	print "Give a dinucleotide: ";
	$dinucl = <STDIN>;
	chomp $dinucl;

	$freq = 0;

	my $seqlen = length($dna);

	#Compute frequency and position
	for (my $i = 0; $i < $seqlen; $i = $i +2) {
		my $pair;
		$pair = substr($dna,$i,2);
		if ($pair eq $dinucl) {
			$freq++;
			$pos = $i;
			print "Position $freq : $pos\n";
		};
	};

	#Printing the results
	print STDOUT "\nTotal dinucleotides of $dinucl = $freq\n";
	print STDOUT "Frequency of $dinucl = ".($freq/($seqlen/2))*100,"\%\n";
}