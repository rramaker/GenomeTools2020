SLDIR=$1
SLNUM=$2
BOWTIE_INDX_DIR=$3

#Load modules and identify necessary paths
module load g/cutadapt/2.3
module load g/bowtie/2.3.5.1
module load g/samtools/1.10
bbmap_filterbyname_path="/gpfs/gpfs1/home/rramaker/bbmap/filterbyname.sh"

#Trim adapters
#cutadapt -a CATTGCGTGAACCGACAATTC -A GAATTCCTACTTGTACAGCTC -o $SLDIR"/TRIMMED_FILES/""$SLNUM"".1.trim.cat.fastq" -p $SLDIR"/TRIMMED_FILES/""$SLNUM"".2.trim.cat.fastq" $SLDIR"/CAT_FILES/""$SLNUM"".1.cat.fastq.gz" $SLDIR"/CAT_FILES/""$SLNUM"".2.cat.fastq.gz"

#Align read one
#bowtie2 -x $BOWTIE_INDX_DIR -U $SLDIR"/TRIMMED_FILES/""$SLNUM"".1.trim.cat.fastq" --score-min C,0,-1 -k 1 -S $SLDIR"/ALIGNMENTS/""$SLNUM"".read1.sam"
#samtools view -bS $SLDIR"/ALIGNMENTS/""$SLNUM"".read1.sam" | samtools sort - -o $SLDIR"/ALIGNMENTS/""$SLNUM"".read1.sorted.bam"
#samtools index $SLDIR"/ALIGNMENTS/""$SLNUM"".read1.sorted.bam" 

#Rescue unaligned read 1 reads in read 2
#samtools view -f 4 $SLDIR"/ALIGNMENTS/""$SLNUM"".read1.sam" | cut -f1 > $SLDIR"/ALIGNMENTS/""$SLNUM"".read1.unaligned.txt"
#$bbmap_filterbyname_path in=$SLDIR"/TRIMMED_FILES/""$SLNUM"".2.trim.cat.fastq" out=$SLDIR"/TRIMMED_FILES/""$SLNUM"".read2.unaligned.trim.cat.fastq" names=$SLDIR"/ALIGNMENTS/""$SLNUM"".read1.unaligned.txt" include=t -Xmx2g
#bowtie2 -x $BOWTIE_INDX_DIR -U $SLDIR"/TRIMMED_FILES/""$SLNUM"".read2.unaligned.trim.cat.fastq" --score-min C,0,-1 -k 1 -S $SLDIR"/ALIGNMENTS/""$SLNUM"".read2.unaligned.sam"
#samtools view -bS $SLDIR"/ALIGNMENTS/""$SLNUM"".read2.unaligned.sam" | samtools sort - -o $SLDIR"/ALIGNMENTS/""$SLNUM"".read2.unaligned.sorted.bam" 
#samtools index $SLDIR"/ALIGNMENTS/""$SLNUM"".read2.unaligned.sorted.bam"

#Merge original counts with rescued read 2 reads
#samtools merge $SLDIR"/ALIGNMENTS/""$SLNUM"".rescue_merged.bam" $SLDIR"/ALIGNMENTS/""$SLNUM"".read2.unaligned.sorted.bam" $SLDIR"/ALIGNMENTS/""$SLNUM"".read1.sorted.bam"

samtools sort $SLDIR"/ALIGNMENTS/""$SLNUM"".rescue_merged.bam" -o $SLDIR"/ALIGNMENTS/""$SLNUM"".rescue_merged.sorted.bam"
samtools index $SLDIR"/ALIGNMENTS/""$SLNUM"".rescue_merged.sorted.bam"
samtools idxstats $SLDIR"/ALIGNMENTS/""$SLNUM"".rescue_merged.sorted.bam" > $SLDIR"/ALIGNMENTS/""$SLNUM"".idxstats_counts.txt"

#Clean up sam and exra fastq files
#rm $SLDIR"/ALIGNMENTS/*.sam"
#rm -r $SLDIR"/CAT_FILES/"
