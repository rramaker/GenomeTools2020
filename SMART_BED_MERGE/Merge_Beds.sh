#!/bin/bash

BED_DIR=$1
BED_LIST=$2
DEPENDENCY_PATH=$3

#combine all bed file peaks into one master file
while read BED_NUM_FULL; do

	BED_NUM="${BED_NUM_FULL/$'\r'/}"
	
	BED_NUM_TRIM="${BED_NUM_FULL/'.bed'/}"

	awk -v name=$BED_NUM_TRIM 'BEGIN{FS=OFS="\t"}{print $0, name}' $BED_DIR/$BED_NUM >> $BED_DIR/MasterBed.txt

done <$BED_LIST

#sort and merge peaks
sort -k 1,1 -k2,2n $BED_DIR/MasterBed.txt > $BED_DIR/MasterBed.sorted.txt
bedtools merge -i $BED_DIR/MasterBed.sorted.txt -c 11,11 -o collapse,count_distinct -d 2000 > $BED_DIR/MasterBed.merged.txt

#Identify problem peaks that have grown > 2kb and split into new 2kb components
awk 'BEGIN{FS=OFS="\t"}{if (int(($3-$2)/2)>2000) print $0}' $BED_DIR/MasterBed.merged.txt > $BED_DIR/ProblemPeaks.merged.txt
Rscript --vanilla $DEPENDENCY_PATH/SplitProblemPeaks.R $BED_DIR/ProblemPeaks.merged.txt $BED_DIR/MasterBed.sorted.txt $BED_DIR/Final_MasterBed.merged.txt

#Re-size non-problem peaks to 2kb
awk 'BEGIN{FS=OFS="\t"}{if (int(($3-$2)/2)<=2000) print $1,(int(($3-$2)/2)+$2)-1000,(int(($3-$2)/2)+$2)+1000,$4,$5}' $BED_DIR/MasterBed.merged.txt >> $BED_DIR/Final_MasterBed.merged.txt

#Clean Up
rm $BED_DIR/MasterBed.txt
rm $BED_DIR/MasterBed.sorted.txt



