#!/bin/perl
use warnings();
use strict();

###################################################################
#format_mega_distances.pl
#By: Taryn Athey
#
#Script to format mega distance file in to a triangular matrix

#Implementation: perl format_mega_distances.pl megFile
##################################################################

#Get user input
my $meg = $ARGV[0];

#open input and output files
open my $meg_file, "<$meg" or die "Can't find input file!";
open my $outfile, ">", "$meg.new.txt" or die $!;

my $header_lines = 0;
my @headers;
my $line_count = -1;
#Go through each line of the file
foreach my $line (<$meg_file>){
	#remove carriage returns and new lines
	$line =~ s/\r?\n//;

	#When we find out first header, record it and parse the header
	if($header_lines == 0){
		if(substr($line, 0, 1) eq "["){
			$header_lines = 1;
			my $name = (split('#', $line))[1];
			push(@headers, $name);
		}
	}
	#Continue parsing headers until we are done with headers
	elsif($header_lines == 1){
		if(substr($line, 0, 1) eq "["){
			my $name = (split('#', $line))[1];
			push(@headers, $name);
		}
		else{
			#Once we're done with headers record
			$header_lines = 2;
		}
	}
	#When we're done with headers, look at the data
	else{
		#For the first line, print the headers
		if($line_count == 0){
			print $outfile "\t" . join("\t", @headers) . "\n";
		}
		#For each consecutive line, print the appropriate header and replace spaces with tabs
		elsif($line_count > 0){
			my $dist = (split(/\]\s+/, $line))[1];
			my @fix_spaces = split(/\s+/, $dist);
			print $outfile $headers[$line_count] . "\t" . join("\t", @fix_spaces) . "\n";
		}
		$line_count++;
	}
}
