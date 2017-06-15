#!/bin/perl
use warnings;
use strict;
use File::Glob;

#######################################################################################################
#mlst_concat.pl
#Author: Taryn Athey
#Date: June 15th, 2017
#
#This script reads in MLST results and then concatenates MLST alleles into a single fasta
#
#Implementation: mlst_concat.pl results.txt MLST.fasta
#
#NOTE: There is hard coding in line 38.  Please alter script to point it to split_fasta.pl script
#######################################################################################################

#Get user input
my $input = $ARGV[0];
my $mlst_fasta = $ARGV[1];

#if user requests help file, print help
if(($input eq "-h") or ($input eq "-help")){
	print "****************************************************************\nThis script reads in MLST results and then concatenates MLST alleles into a single fasta\n\nImplementation: mlst_concat.pl results.txt MLST.fasta\n\nNOTE: There is hard coding in line 38.  Please alter script to point it to split_fasta.pl script.\n****************************************************************\n";
	exit();
}

#open input file, create warning file
open my $file, "<$input" or die "Can't find input file!";
open my $warning, ">", "warnings.txt" or die $!;

#make temporary directory
mkdir "split";
chdir "split";

#split mlst database fasta file
#Path to split_fasta.pl is hardcoded.  User must change this to their directory.
system("perl /NetDrive/Users/tathey/Script_fromZ820/split_fasta.pl $mlst_fasta");

chdir "..";


#Read in input file and create multifasta and single fasta
my $count = 0;
my @header;
my $nonMatch = 0;
foreach my $line (<$file>){
	$line =~ s/\r?\n//;

	#If not the first line, read MLST results
	if($count > 0){
		my @line_split = split(/\s+/, $line);

		#create multifasta file
		open my $multifasta, ">", "$line_split[0]_multi.fasta" or die $!;

		#for each allele, find fasta results
		for(my $i = 2; $i < 9; $i++){

			#remove * and ? from results
			my $clean = $line_split[$i];
			$clean =~ s/\*//;
			$clean =~ s/\?//;

			#If * of ? in results, print warning
			if($clean ne $line_split[$i]){
				print $warning "Strain $line_split[0] has a SNP or base uncertainty at gene $header[$i]\n";
				$nonMatch = 1;
			}
			#If allele is not found, print warning, if found, add sequence to multifasta
			if(($line_split[$i] eq "NF") or ($line_split[$i] eq "-")){
				print $warning "Strain $line_split[0] had no matching allele for gene $header[$i]\n";
				$nonMatch = 1;
			}
			else{
				system("cat split/$header[$i]-$clean.fa >> $line_split[0]_multi.fasta");
			}
		}
		close $multifasta;

		#Only create single fasta if perfect ST result
		if($nonMatch == 0){
			open my $multiRead, "<$line_split[0]_multi.fasta" or die $!;
			open my $singleFasta, ">", "$line_split[0]_single.fasta" or die $!;

			#print strain name to fasta header
			print $singleFasta ">$line_split[0]_MLST";

			#concatenate sequence then write to file 50bps at a time
			my $seq = "";
			foreach my $fastLine (<$multiRead>){
				$fastLine =~ s/\r?\n//;
				if(substr($fastLine, 0, 1) ne ">"){
					$seq = $seq . $fastLine;
				}
			}
			for(my $l = 0; $l < length($seq); $l = $l+50){
				print $singleFasta "\n" . substr($seq,$l,50);
			}
			close $singleFasta;
		}
	}
	else{
		@header = split(/\s+/, $line);
	}
	$count++;
	$nonMatch = 0;
}

#Remove temporary directory
unlink glob "split/*.fa";
rmdir "split";
