#!/bin/bash
#######################################################################
#consensus.sh
#
#By: Taryn Athey, Biocomputational Analyst, May 24th 2018
#
#Run this script from the directory of fastqs you want a consensus for
#
#######################################################################

module load samtools/samtools-1.4

#Set REFERENCE to be file you want to align you fastq files to
REFERENCE=/Scratch.NFS/tathey/Influenza_Reference/Texas_HA.fa
REF=$(basename $REFERENCE)

#Indexes reference for alignmnet tools
bowtie2-build $REFERENCE $REF
samtools faidx $REFERENCE

#SET SIZE TO BE NUMBER OF LINES YOUR FINAL FASTA FILE WILL BE, including header
SIZE=30

#RUNS THROUGH EACH FASTQ FILE IN DIRECTORY
for FILENAME in *_R1.fastq.gz ;
 do
  if [ -f "$FILENAME" ]; then
    NAME=$(basename "$FILENAME" _R1.fastq.gz) #Grabs basename of fastq file

    bowtie2 -1 $NAME\_R1.fastq.gz -2 $NAME\_R2.fastq.gz -x $REF -S $NAME.sam #Aligns fastq to reference

    #Convert sam to bam and sort bam file (note, this is using samtools version, 1.4)
    samtools view -b -o $NAME.bam -q 1 -S $NAME.sam
    samtools sort -o $NAME.sorted.bam $NAME.bam

    samtools mpileup -uf $REFERENCE $NAME.sorted.bam | bcftools call -c - | vcfutils.pl vcf2fq > $NAME.fq #Creates consensus

    sed -i s/\@/\>$NAME\_/g $NAME.fq #Coverts @ symbol to > for proper fasta format

    head -n $SIZE $NAME.fq >> All.fasta #Creates a multifasta of all your strains
 fi
done
