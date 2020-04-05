#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

SplitProblemPeaks<-function(ProblemPeakBed, MasterBed, OutputBed){
  ProblemPeaks<- read.table(ProblemPeakBed,sep="\t",stringsAsFactors=F)
  masterFile<- read.table(MasterBed,sep="\t",stringsAsFactors = F)
  NewBed<-list()
  for(Peak in 1:nrow(ProblemPeaks)){
    message(paste0("Fixing Problem Peak ", Peak, " of ", nrow(ProblemPeaks)))
    FoundPeaks<-masterFile[which(masterFile[,1]==ProblemPeaks[Peak,1]&masterFile[,2]>=ProblemPeaks[Peak,2]&masterFile[,3]<=ProblemPeaks[Peak,3]),]
    PeakWidth<-ProblemPeaks[Peak,3]-ProblemPeaks[Peak,2]
    NumBins<- ceiling(PeakWidth/2000)
    OverHang<- (NumBins*2000)-PeakWidth
    PotentialStarts<-(ProblemPeaks[Peak,2]-OverHang):ProblemPeaks[Peak,2]
    NumSplit<-c()
    DistFromCenter<-c()
    for(i in PotentialStarts){
      splits<-i + seq(0,NumBins*2000,2000)
      NumSplit[paste0(i)]<-sum(unlist(lapply(splits, function(x) sum(FoundPeaks[,2]<x&FoundPeaks[,3]>x))))
      DistFromCenter[paste0(i)]<-abs((OverHang-abs(i-ProblemPeaks[Peak,2])) - (OverHang/2))/(OverHang/2)
    }
    if(OverHang==0){
      DistFromCenter<-0
    }
    OptSplit<-as.numeric(names(which.min(NumSplit/max(c(NumSplit,1))+DistFromCenter)))
    #plot(NumSplit/max(c(NumSplit,1))+DistFromCenter)
    NewPeaks<-matrix(nrow=NumBins, ncol=5)
    NewPeaks[,1]<-as.character(ProblemPeaks[Peak,1])
    NewPeaks[,2]<- OptSplit + seq(0,(NumBins-1)*2000,2000)
    NewPeaks[,3]<-OptSplit + seq(2000,(NumBins)*2000,2000)
    NewPeaks[,4]<-unlist(lapply(1:NumBins, function(x) paste0(unique(c(FoundPeaks[which(FoundPeaks[,2]>=NewPeaks[x,2]&FoundPeaks[,2]<=NewPeaks[x,3]),11],FoundPeaks[which(FoundPeaks[,3]>=NewPeaks[x,2]&FoundPeaks[,3]<=NewPeaks[x,3]),11])),collapse = ",")))
    NewPeaks[,5]<-unlist(lapply(1:NumBins, function(x) length(unique(c(FoundPeaks[which(FoundPeaks[,2]>=NewPeaks[x,2]&FoundPeaks[,2]<=NewPeaks[x,3]),11],FoundPeaks[which(FoundPeaks[,3]>=NewPeaks[x,2]&FoundPeaks[,3]<=NewPeaks[x,3]),11])))))
    NewBed[[Peak]]<-NewPeaks
  }
  NewBedOut<-do.call(rbind,NewBed)
  write.table(NewBedOut, OutputBed, sep="\t",quote=F,row.names=F,col.names=F)
}

SplitProblemPeaks(ProblemPeakBed=args[1], MasterBed=args[2], OutputBed=args[3])
