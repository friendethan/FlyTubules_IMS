#Step 1: Prepare the evironment
#Load necessary packages and functions
require(Cardinal)
source("functions.R")

#set working directory
setwd("imzml_sections")

#Step 2: Load and Peak Pick Data

#obtain data list
imzml <- as.matrix(read.table("dirlist.txt"))

#read data
imzml_data <- list()
for(i in 1:length(imzml)){
  imzml_data[i] <- readImzML(imzml[i])
}  

#obtain list of peakpicked names
rd_name = paste(imzml, "_rd", sep="")

#Setting variables for peakpicking
imzml_list=imzml_data
namelist=rd_name

#Peakpicking
data_rd=multiIMSred(cardinaldatalist=imzml_list, filenamelist=namelist)

## Step 2: Rename and Save Data
#set working directory
setwd("rdata")

rd <- as.matrix(read.table("dirlist_rd.txt"))
rd_name <- as.matrix(read.table("dirlist_rd.txt"))

#2018-07-26_FlyTubule_Sections_DAN_rd.RData
load(rd[1])
DAN_POS_180726_rd=cardinaldatalist.peaks
save(DAN_POS_180726_rd, file=rd_name[1])

#2018-07-26_FlyTubule_Sections_DHB_rd.RData
load(rd[2])
DHB_POS_180726_rd=cardinaldatalist.peaks
save(DHB_POS_180726_rd, file=rd_name[2])

#2018-07-27_FlyTubule_Sections_SADHA_rd.RData
load(rd[3])
SADHA_POS_180727_rd=cardinaldatalist.peaks
save(SADHA_POS_180727_rd, file=rd_name[3])

#2018-08-02_FlyTubule_Sections_DAN_NEG_rd.RData
load(rd[4])
DAN_NEG_180802_rd=cardinaldatalist.peaks
save(DAN_NEG_180802_rd, file=rd_name[4])

#2018-08-13_FlyTubule_Sections_DAN_NEG_rd.RData
load(rd[5])
DAN_NEG_180813_rd=cardinaldatalist.peaks
save(DAN_NEG_180813_rd, file=rd_name[5])

#2018-08-13_FlyTubule_Sections_DAN_POS_rd.RData
load(rd[6])
DAN_POS_180813_rd=cardinaldatalist.peaks
save(DAN_POS_180813_rd, file=rd_name[6])

#reloading data
#set working directory
setwd("/rdata")
rd_list <- as.matrix(read.table("dirlist_rd.txt"))
raw_list <- as.matrix(read.table("dirlist_raw.txt"))

#setwd("/rdata")
load(rd_list[[6]])
load(raw_list[[6]])

par(mfrow=c(2,2), mai = c(0.4,0.4,0.4,0.4))
image(POS_DAN_3, mz=884.4, plusminus=0.1, main=raw_list[[6]])
image(DAN_POS_180813_rd, mz=884.4, plusminus=0.1, main=rd_list[[6]])

## Step 3: Split Data
#Obtain XML 
setwd("/xml")
xml_list <- as.matrix(read.table("dirlist_xml.txt"))

#DAN_POS1_GelEt <- sampleROIs(DAN_POS_180726_rd, XMLdata = xml_list[[1]], width=3)
#DAN_POS1_GelFr <- sampleROIs(DAN_POS_180726_rd, XMLdata = xml_list[[2]], width=3)
#DAN_POS1_CMCEt <- sampleROIs(DAN_POS_180726_rd, XMLdata = xml_list[[3]], width=3)
#DAN_POS1_OCTEt <- sampleROIs(DAN_POS_180726_rd, XMLdata = xml_list[[4]], width=3)

DHB_POS1_GelEt <- sampleROIs(DHB_POS_180726_rd, XMLdata = xml_list[[5]], width=3)
DHB_POS1_GelFr <- sampleROIs(DHB_POS_180726_rd, XMLdata = xml_list[[6]], width=3)
DHB_POS1_CMCEt <- sampleROIs(DHB_POS_180726_rd, XMLdata = xml_list[[8]], width=3)
DHB_POS1_OCTEt <- sampleROIs(DHB_POS_180726_rd, XMLdata = xml_list[[9]], width=3)

#combine rd data
DAN_POS1 <- list(DAN_POS1_GelEt, DAN_POS1_GelFr, DAN_POS1_CMCEt, DAN_POS1_OCTEt)
DHB_POS1 <- list(DHB_POS1_GelEt, DHB_POS1_GelFr, DHB_POS1_CMCEt, DHB_POS1_OCTEt)
DAN_NEG <- list(DAN_NEG_180802_rd, DAN_NEG_180813_rd, SADHA_POS_180727_rd)

##Step 4: Statistical Analysis
##Spatial Shrunken Centroids
#Set working directory
setwd("/sscg")

#decide on filename
filename=c("DAN_POS_180726_GelEt", "DAN_POS_180726_GelFr", "DAN_POS_180726_CMCEt", "DAN_POS_180726_OCTEt")

#conduct segmentation analysis
#DAN_POS
DAN_POS1_r1_k3  = multiSSCG(DAN_POS1, filenamelist=filename, r=1, k=3, s=1)
DAN_POS1_r1_k5  = multiSSCG(DAN_POS1, filenamelist=filename, r=1, k=5, s=1)
DAN_POS1_r1_k7  = multiSSCG(DAN_POS1, filenamelist=filename, r=1, k=7, s=1)
DAN_POS1_r1_k9  = multiSSCG(DAN_POS1, filenamelist=filename, r=1, k=9, s=1)
DAN_POS1_r1_k10 = multiSSCG(DAN_POS1, filenamelist=filename, r=1, k=10, s=1)
DAN_POS1_r2_k3  = multiSSCG(DAN_POS1, filenamelist=filename, r=2, k=3, s=1)
DAN_POS1_r2_k5  = multiSSCG(DAN_POS1, filenamelist=filename, r=2, k=5, s=1)
DAN_POS1_r2_k7  = multiSSCG(DAN_POS1, filenamelist=filename, r=2, k=7, s=1)
DAN_POS1_r2_k9  = multiSSCG(DAN_POS1, filenamelist=filename, r=2, k=9, s=1)
DAN_POS1_r2_k10 = multiSSCG(DAN_POS1, filenamelist=filename, r=2, k=10, s=1)

#DHB_POS
filename=c("DHB_POS_180726_GelEt", "DHB_POS_180726_GelFr", "DHB_POS_180726_CMCEt", "DHB_POS_180726_OCTEt")
DHB_POS1_r1_k3  = multiSSCG(DHB_POS1, filenamelist=filename, r=1, k=3, s=1)
DHB_POS1_r1_k5  = multiSSCG(DHB_POS1, filenamelist=filename, r=1, k=5, s=1)
DHB_POS1_r1_k7  = multiSSCG(DHB_POS1, filenamelist=filename, r=1, k=7, s=1)
DHB_POS1_r1_k9  = multiSSCG(DHB_POS1, filenamelist=filename, r=1, k=9, s=1)
DHB_POS1_r1_k10 = multiSSCG(DHB_POS1, filenamelist=filename, r=1, k=10, s=1)
DHB_POS1_r2_k3  = multiSSCG(DHB_POS1, filenamelist=filename, r=2, k=3, s=1)
DHB_POS1_r2_k5  = multiSSCG(DHB_POS1, filenamelist=filename, r=2, k=5, s=1)
DHB_POS1_r2_k7  = multiSSCG(DHB_POS1, filenamelist=filename, r=2, k=7, s=1)
DHB_POS1_r2_k9  = multiSSCG(DHB_POS1, filenamelist=filename, r=2, k=9, s=1)
DHB_POS1_r2_k10 = multiSSCG(DHB_POS1, filenamelist=filename, r=2, k=10, s=1)

#DAN_NEG
filename=c("DAN_NEG_180802", "DAN_NEG_180813", "SADHA_POS_180727")
DHB_NEG_PRO_r1_k3  = multiSSCG(DAN_NEG, filenamelist=filename, r=1, k=3, s=1)
DHB_NEG_PRO_r1_k5  = multiSSCG(DAN_NEG, filenamelist=filename, r=1, k=5, s=1)
DHB_NEG_PRO_r1_k7  = multiSSCG(DAN_NEG, filenamelist=filename, r=1, k=7, s=1)
DHB_NEG_PRO_r1_k9  = multiSSCG(DAN_NEG, filenamelist=filename, r=1, k=9, s=1)
DHB_NEG_PRO_r1_k10 = multiSSCG(DAN_NEG, filenamelist=filename, r=1, k=10, s=1)
DHB_NEG_PRO_r2_k3  = multiSSCG(DAN_NEG, filenamelist=filename, r=2, k=3, s=1)
DHB_NEG_PRO_r2_k5  = multiSSCG(DAN_NEG, filenamelist=filename, r=2, k=5, s=1)
DHB_NEG_PRO_r2_k7  = multiSSCG(DAN_NEG, filenamelist=filename, r=2, k=7, s=1)
DHB_NEG_PRO_r2_k9  = multiSSCG(DAN_NEG, filenamelist=filename, r=2, k=9, s=1)
DHB_NEG_PRO_r2_k10 = multiSSCG(DAN_NEG, filenamelist=filename, r=2, k=10, s=1)

##Step 5: Split segmentation analysis and resave
name=c(3, 5, 7,9, 10)
rd_data=DAN_POS_180813_rd
sscglist_DAN_POS3_r1=list()
sscglist_DAN_POS3_r1[[1]]=spatialShrunkenCentroids(rd_data,r=1,k=3,s=1)
sscglist_DAN_POS3_r1[[2]]=spatialShrunkenCentroids(rd_data,r=1,k=5,s=1)
sscglist_DAN_POS3_r1[[3]]=spatialShrunkenCentroids(rd_data,r=1,k=7,s=1)
sscglist_DAN_POS3_r1[[4]]=spatialShrunkenCentroids(rd_data,r=1,k=9,s=1)
sscglist_DAN_POS3_r1[[5]]=spatialShrunkenCentroids(rd_data,r=1,k=10,s=1)

for(i in 1:length(sscglist_DAN_POS3_r1)){
  filename=paste("DAN_POS_180813_k", name[[i]],"_r1.RData", sep="")
  sscg=sscglist_DAN_POS3_r1[[i]]
  save(sscg, file=filename)  
}

sscglist_DAN_POS3_r2=list()
sscglist_DAN_POS3_r2[[1]]=spatialShrunkenCentroids(rd_data,r=2,k=3,s=1)
sscglist_DAN_POS3_r2[[2]]=spatialShrunkenCentroids(rd_data,r=2,k=5,s=1)
sscglist_DAN_POS3_r2[[3]]=spatialShrunkenCentroids(rd_data,r=2,k=7,s=1)
sscglist_DAN_POS3_r2[[4]]=spatialShrunkenCentroids(rd_data,r=2,k=9,s=1)
sscglist_DAN_POS3_r2[[5]]=spatialShrunkenCentroids(rd_data,r=2,k=10,s=1)

for(i in 1:length(sscglist_DAN_POS3_r2)){
  filename=paste("DAN_POS_180813_k", name[[i]],"_r2.RData", sep="")
  sscg=sscglist_DAN_POS3_r2[[i]]
  save(sscg, file=filename)  
}

## Step 6: Export data for archiving as PDF

#Three Segments
pdf( "Tubule_Pos_3.pdf" ,width=9, height=9); 
for(j in 1:length(sscglist_3_pos)){
  Pos_sscg=sscglist_3_pos[[j]]
  rawdata=pos_rd[[j]]
  name=name_pos[[j]]
  for(i in 1:3){
    image(Pos_sscg,column=i,layout=c(3,3),main=name)
    image(rawdata, main="top 8 markers",
          mz=topLabels(Pos_sscg,model=1,n=20,filter=list(classes=i))$mz[1:8],normalize.image="linear")
  }
}
dev.off()

#Five Segments
pdf( "Tubule_Pos_5.pdf" ,width=9, height=9); 
for(j in 1:length(sscglist_5_pos)){
  Pos_sscg=sscglist_5_pos[[j]]
  rawdata=pos_rd[[j]]
  name=name_pos[[j]]
  for(i in 1:5){
    image(Pos_sscg,column=i,layout=c(3,3),main=name)
    image(rawdata, main="top 8 markers",
          mz=topLabels(Pos_sscg,model=1,n=20,filter=list(classes=i))$mz[1:8],normalize.image="linear")
  }
}
dev.off()

#Seven Segments
pdf( "Tubule_Pos_7.pdf" ,width=9, height=9); 
for(j in 1:length(sscglist_7_pos)){
  Pos_sscg=sscglist_7_pos[[j]]
  rawdata=pos_rd[[j]]
  name=name_pos[[j]]
  for(i in 1:7){
    image(Pos_sscg,column=i,layout=c(3,3),main=name)
    image(rawdata, main="top 8 markers",
          mz=topLabels(Pos_sscg,model=1,n=20,filter=list(classes=i))$mz[1:8],normalize.image="linear")
  }
}
dev.off()

