#!/usr/bin/python
import sys

#######################################################################################################
#translate.py
#Author: Taryn Athey
#Date: June 9th, 2017
#
#This script translates nucleotides into amino acid sequences.  This script takes in a fasta containing
#a single nucleotide sequence.  This script assumes that the fasta file is in the appropriate frame.
#
#######################################################################################################

dnaFile = sys.argv[1]
dna_content = open(dnaFile)

aaFile = open(dnaFile + "_protein.fas", "w")

CodonDict={'TTT':'F', 'TCT':'S', 'TAT':'Y', 'TGT':'C', 'TTC':'F', 'TCC':'S', 'TAC':'Y', 'TGC':'C', 'TTA':'L', 'TCA':'S', 'TAA':'*', 'TGA':'*', 'TTG':'L', 'TCG':'S', 'TAG':'*', 'TGG':'W', 'CTT':'L', 'CCT':'P', 'CAT':'H', 'CGT':'R', 'CTC':'L', 'CCC':'P', 'CAC':'H', 'CGC':'R', 'CTA':'L', 'CCA':'P', 'CAA':'Q', 'CGA':'R', 'CTG':'L', 'CCG':'P', 'CAG':'Q', 'CGG':'R', 'ATT':'I', 'ACT':'T', 'AAT':'N', 'AGT':'S', 'ATC':'I', 'ACC':'T', 'AAC':'N', 'AGC':'S', 'ATA':'I', 'ACA':'T', 'AAA':'K', 'AGA':'R', 'ATG':'M', 'ACG':'T', 'AAG':'K', 'AGG':'R', 'GTT':'V', 'GCT':'A', 'GAT':'D', 'GGT':'G', 'GTC':'V', 'GCC':'A', 'GAC':'D', 'GGC':'G', 'GTA':'V', 'GCA':'A', 'GAA':'E', 'GGA':'G', 'GTG':'V', 'GCG':'A', 'GAG':'E', 'GGG':'G'}

DNAseq = ""
header = ""

#Read in DNA sequence
for lines in dna_content:
	line = lines.rstrip("\n")
	if line[0] == ">":
		header = line
	else:
		DNAseq = DNAseq + line

seq = ""

#translate protein sequence
for n in range(0,len(DNAseq),3):
	codon = DNAseq[n:n+3]
	seq = seq + CodonDict.get(codon)

aaFile.write(header + "\n")

#print protein sequence to output file
for i in range(0,len(seq), 50):
	aaFile.write(seq[i:i+50] + "\n")
