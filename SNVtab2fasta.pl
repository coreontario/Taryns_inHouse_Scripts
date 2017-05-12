#!/bin/perl
#######################################################################################################
#SNVtab2fasta.pl
#Author: Taryn Athey
#Date: May 11, 2017
#
#######################################################################################################

use warnings();
use strict();

#read in user input
my $input = $ARGV[0];
my $outname = $ARGV[1];

#if user requests help file, print help
if(($input eq "-h") or ($input eq "-help")){
	print "****************************************************************\nThis script converts tabulated SNV data into a multi-fasta file\n\nImplementation:perl SNVtab2fasta.pl SNVfile.txt output.fasta [optional]\n\nNOTE: If on output name is not specified, the final fasta file will be given the name SNVfile.txt.fasta\nThe Reference SNV data is expected to start in the third column and second row of the input file.\n****************************************************************\n";
	exit();
}

#open user input file
open my $file, "<$input" or die "Can't find input file!";

#open user output file
my $output;
if($outname eq ""){
	open $output, ">", "$input.fasta" or die $!;
}
else{
	open $output, ">", "$outname" or die $!;
}


my @table;
my $samples;
my $positions = 0;

#Read in input file and save in 2x2 array
foreach my $line (<$file>){
	$line =~ s/\r?\n//;

	my @split_line = split(/\s+/, $line);
	$samples = @split_line;

	push(@table, \@split_line);

	$positions++;
}

#print fasta file to output
for (my $i = 2; $i < $samples; $i++){
	print $output ">$table[0][$i]\n";
	for (my $n = 1; $n < $positions; $n++){
		if($table[$n][$i] eq "."){
			print $output $table[$n][2];
		}
		else{
			print $output $table[$n][$i];
		}
	}
	print $output "\n";
}
