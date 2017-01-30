#!/usr/bin/perl
use warnings;
use strict;

##########################################################################
##rename_fastaHeaders.pl						##
##Written by: Taryn Athey						##
##Date: January 30th, 2017						##
##									##
##Implementation: perl rename_fastaHeaders.pl names.txt file.fasta	##
##									##
##########################################################################

#Get user input
my $names_file = $ARGV[0];
my $fasta_file = $ARGV[1];

#If user puts -h or -help, give information on how to run the script
if(($names_file eq "-h") or ($names_file eq "-help")){
	print("\n*********************************************************\nrename_fastaHeaders.pl\nWritten by: Taryn Athey\nDate: January 30th, 2017\n\nImplementation: perl rename_fastaHeaders.pl names.txt file.fasta\n\nnames.txt: A tab separated text file containing original header names in the first column and new header names in the second column.  The file may contain headers and extra columns and rows.\nfile.fasta: A multifasta containing headers to be changed.  If a header is not in the names.txt file, this header will not be replaced.\n\nOutput is a file following the naming convention multifasta.new.fasta\n*********************************************************\n\n");
	exit();
}

#open user input files
open my $names, "<$names_file" or die "Can't find $names_file input file!";
open my $fasta, "<$fasta_file" or die "Can't find $fasta_file input file!";

#remove .fasta from fasta file name and open new file
$fasta_file =~ s/.fasta//;
open my $new_fasta, ">", "$fasta_file.new.fasta" or die $!;

#declar dictionary
my %names_dict;
 
#read in names file and save to a dictionary
foreach my $name (<$names>){
	$name =~ s/\r?\n//;

	(my $original, my $new_name) = split(/\s+/, $name);

	$names_dict{$original} = $new_name;
}

#reads in multifasta and changes header names
foreach my $line (<$fasta>){
	$line =~ s/\r?\n//;

	#Check if line begins with ">"
	if(substr($line,0,1) eq ">"){
		my $header = substr($line, 1);

		#Check if header exists in dictionary
		if(exists($names_dict{$header})){
			print $new_fasta ">$names_dict{$header}\n";
		}
		else{
			print $new_fasta $line . "\n";
		}
	}
	else{
		print $new_fasta $line . "\n";
	}
}
