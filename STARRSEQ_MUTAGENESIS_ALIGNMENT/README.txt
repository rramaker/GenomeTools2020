STARRSEQ_MUTAGENESIS_ALIGNMENT (04/05/2020)

This folder contains a shell script (MPRA_FASTQ_to_Counts.sh) that takes a list of paired end FASTQ files from a STARR-seq experiment and a test element FASTA file for a STARR-seq experiment and generates a count table for each sample.

#########################DEPENDENCIES##########################
This shell script is designed to run on MAC OSX (10.9.5 or greater) command line and assumes the following software packages are installed and available via the command line:

1. cutadapt v1.16 or greater (https://cutadapt.readthedocs.io/en/stable/installation.html)
2. samtools v1.3 or greater (http://www.htslib.org/download/)

#########################ARGUMENTS#############################
This script requires 4 arguments in the following order:

1. The path to a directory containing paired end FASTQ files for alignment. This script assumes paired end mate FASTQs share the same name with the exception of a 1 or 2 in the file name indicating the sequencing read.
2. The path to a single column text file that contains the file names of each bed file the user would like to align.
3. The path to a FASTA file describing the sequences of the test elements or genome regions assayed in the STARR-seq experiment
4. The path to the DEPENDENCIES folder in the GenomeTools2020 folder from which this script is obtained

##########################OUTPUTS##############################
This script contains the following outputs:

1. An ALIGNMENTS folder containing the following files:
A) Sorted and indexed bam files for each input sample (.bam.sorted file extension)
B) A count table containing counts of aligned reads to each test element for each input sample (Final_Count_Table.txt)

2. A TRIMMED_FILES folder containing adapter trimmed FASTQ files

#########################Example################################
The DEPENDENCIES folder in GenomeTools2020 contains randomly subsampled FASTQs from a STARR-seq experiment. An example command aligning those files is as follows:

sh MPRA_FASTQ_to_Counts.sh /User/Path/To/GenomeTools2020/DEPENDENCIES/STARR_Seq_FASTQs/ /User/Path/To/GenomeTools2020/DEPENDENCIES/STARR_Seq_FASTQs/SL_List.txt /User/Path/To/GenomeTools2020/DEPENDENCIES/STARR_Seq_FASTQs/HOT_STARR_FASTA_Reference.fa /User/Path/To/GenomeTools2020/DEPENDENCIES/
