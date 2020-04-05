SMART_BED_MERGE (04/05/2020)

This folder contains a shell script (Merge_Beds.sh) that takes a list of bed files as input and generates a single merged bed file containing the minimal number of merged 2KB loci/bins that contain all input beds  while splitting the fewest number of individual bed regions possible.

#################DEPENDENCIES############################
This shell script is designed to run on MAC OSX (10.9.5 or greater) command line and assumes the following software packages are installed and available via the command line:

1. bedtools v2.24.0 or newer (https://bedtools.readthedocs.io/en/latest/content/installation.html)
2. R v3.2.1 or newer (https://cran.r-project.org/bin/macosx/)

#################ARGUMENTS###############################
This script also requires three arguments in the following order:

1. The path to a directory containing bed files.
2. The path to a single column text file that contains the file names of each bed file the user would like to merge
3. The path to the DEPENDENCIES folder in the GenomeTools2020 folder from which this script is obtained

##################OUTPUTS#################################
There are two important outputs from this script

1. Final_MasterBed.merged.txt - This is the final merged bed file that contains the following columns:
A)Chromosome
B)Merged Bin Start
C)Merged Bin Stop
D)Names of input bed files contained within the bin
E)Number of unique input bed files that contain regions within the bin

2. ProblemPeaks.merged.txt - This is a bedfile containing peaks that grew larger than 2kb and required splitting into constituent 2kb bins. The column descriptions are identical to the "Final_MaterBed.merged.txt" file above.


##################EXAMPLE#################################
An example data set of bedfiles for the ENCODE H1 cell line is included in the DEPENDENCIES subfolder of GenomeTools2020. An example call of this script to proces these bed files is shown below:

sh Merge_Beds.sh /User/Path/To/GenomeTools2020/DEPENDENCIES/H1_Beds/ /User/Path/To/GenomeTools2020/DEPENDENCIES/H1_Beds/Bed_List.txt /User/Path/To/GenomeTools2020/DEPENDENCIES/


