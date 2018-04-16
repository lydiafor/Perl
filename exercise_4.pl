#!/usr/bin/perl

use strict;
use warnings;

##A: counting every feature for each gene in the gff file

sub gff_features(){
	#Initialize variables
	our(@featus, %hash, @info);

	open (DATA, "<feats.gff") or die "Could not open that file!\n";

	@featus = <DATA>;
	chomp @featus;

	#Extract features
	for my $line (@featus) {	
		@info = split /\t/, $line;
		my $gene = $info[8];
		my $feat = $info[2];
		(!exists $hash{$gene}) && do {
			$hash{$gene} = {};
			};
		if(!exists ${$hash{$gene}}{$feat}) {
			${$hash{$gene}}{$feat} = 1;
		}else {
			${$hash{$gene}}{$feat}++;
		}
	};

	my @keys1 = sort keys %hash;

	#Priniting the results
	for (my $i=0; $i< scalar(@keys1); $i++) {
		print "$keys1[$i] ";
		my @keys2 = sort keys %{$hash{$keys1[$i]}};
		for (my $j=0; $j < scalar(@keys2); $j++) {
			print "$keys2[$j] ";
			print "${$hash{$keys1[$i]}}{$keys2[$j]} ";
		}
			print "\n";
	}
}

##B: two file with same kind of data, merge the file into an output with three columns. NO value = NA

sub merge_files(){
	#Initialize variables
	my ($fileA, $fileB, @valuesA, @valuesB, %hashA, %hashB, $idA, $idB);

	open ($fileA, "<fileA.tbl") or die "Could not open that file!\n";
	open ($fileB, "<fileB.tbl") or die "Could not open that file!\n";

	#Store the values
	while (<$fileA>) {
		chomp;
		@valuesA = split/\t/;
		$hashA{$valuesA[0]} = $valuesA[1];
	};

	while (<$fileB>) {
		chomp;
		@valuesB = split/\t/;
		$hashB{$valuesB[0]} = $valuesB[1];
	};

	close($fileA);
	close($fileB);

	#Merge files
	foreach $idA (keys %hashA){
		foreach $idB (keys %hashB){
			if (not defined($hashA{$idB})){
				$hashA{$idB} = "NA";
			} elsif (not defined($hashB{$idA})){
				$hashB{idA} = "NA";
			} else {
				next;
			}
		}
	};

	#Printing the results
	foreach $idB (sort {$a <=> $b} keys %hashB){
		print STDOUT $idB,"\t",$hashA{$idB},"\t",$hashB{$idB};
		print "\n";
	};
}
	