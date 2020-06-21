#'Cluster transcription factors
#'@param Merged_Peak_Frame A dataframe containing merged TF peak data with at least 4 columns. This is the standard output from the SMART_BED_MERGE function in GenomeTools2020 repo. Columns 1-3 should contain the chromosome, start, and stop position of each merged peak region. Column 4 should contain a string that represents comma separated list of all TFs present at each position. Each row should contain data for each merged peak region.
#'@export
#'@return Returns a distance matrix indicating the clustering distance for each TF pair. The number of columns and rows is equal to the number of unique TFs included in the Merged_Peak_Frame. This matrix can be provided to any heatmap function desired.
#'
#'@examples
#'data(DLPFC_Example_062120)
#'ClusterTFs(test)

ClusterTFs<-function(Merged_Peak_Frame){
  require(pheatmap)

  #Find Unique TFs
  Unique_TFs<-unique(unlist(strsplit(Merged_Peak_Frame[,4],",")))

  #Make Occupancy Matrix
  message("Parsing TFs")
  HotFrame<-matrix(nrow=nrow(Merged_Peak_Frame),ncol=length(Unique_TFs))
  colnames(HotFrame)<-Unique_TFs
  rownames(HotFrame)<-paste(Merged_Peak_Frame[,1],Merged_Peak_Frame[,2],Merged_Peak_Frame[,3],sep="_")
  for(i in colnames(HotFrame)){
    HotFrame[grep(i,Merged_Peak_Frame[,4]),i]<-1
  }
  HotFrame[which(is.na(HotFrame))]<-0

  #Compute Eigen Distances
  message("Computing TF Distances")
  TF_PCA<-prcomp(t(HotFrame))
  TF_Eigens<-TF_PCA$x
  PVar<-summary(TF_PCA)$importance[2,]
  TF_EigenDist<-apply(TF_Eigens,1,function(y) colSums(apply(TF_Eigens,1,function(x) abs(y-x))*PVar^1))

  return(TF_EigenDist)
}

