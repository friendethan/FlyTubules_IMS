## Step 1: Prepare the envrionment
#load packages, Cardinal is most important
require(Cardinal)
source("functions.R")

#set working directory
setwd("working_directory")

## Step 2: Read imzml and pick peaks
#obtain data list
imzml <- as.matrix(read.table("dirlist_imzml.txt"))

#read data
imzml_data <- list()
for(i in 1:length(imzml)){
  imzml_data[i] <- readImzML(imzml[i])
}  

#create names of imzml for peak picked data
rd_name = paste(imzml, "rd", sep="")

#conduct pre-processing on a list of imzml files
data_rd=multiIMSred(cardinaldatalist=imzml_data, filenamelist=rd_name)

## Step 3: Change Variable Name
#reloading data to change name
rd <- as.matrix(read.table("dirlist_raw.txt"))
rd_name <- as.matrix(read.table("dirlist_rd.txt"))

#example of names changed
load(rd[2])
AFPBS_Neg_180620_rd=cardinaldatalist.peaks
save(AFPBS_Neg_180620_rd, file=rd_name[2])

##Step 4: Separate and combine data by condition
#reloading data
#set working directory
setwd("working_directory")
rd_list <- as.matrix(read.table("dirlist_rd.txt"))
list=as.matrix(ls())

#obtain coordiantes for glycerol wash
setwd("glycerol_xml")
GLAA_1 <- sampleROIs(AFPBS_Pos_180620_rd, XMLdata = "PBS_GLAA_SUB_DHB_180620_1.xml", width=3)
GLAA_2 <- sampleROIs(NWGLAA_Pos_180627_rd, XMLdata = "PBS_GLAA_SUB_DHB_180627_2.xml", width=3)
GLAA_3 <- sampleROIs(GLAA_Pos_180710_rd, XMLdata = "PBS_GLAA_SUB_DHB_180710_3.xml", width=3)

#image to confirm that separation occurred
par(mfrow=c(2,2), mai = c(0.4,0.4,0.4,0.4))
image(GLAA_1, mz=728.8, plusminus=0.1)
image(GLAA_2, mz=728.8, plusminus=0.1)
image(GLAA_3, mz=728.8, plusminus=0.1)

#save data
save(GLAA_1, file="GLAA_1.Rdata")
save(GLAA_2, file="GLAA_2.Rdata")
save(GLAA_3, file="GLAA_3.Rdata")

#combine rd data
GLAA_triplicate <- list(GLAA_1, GLAA_2, GLAA_3)

##Step 5: Statistical analysis

#provide name for the samples
name=c("GLAA_1_180620", "GLAA_2_180627", "GLAA_3_180710")

##Spatial Shrunken Centroids
#three clusters
sscglist_3=list()
sscglist_3[[1]]=spatialShrunkenCentroids(GLAA_triplicate[[1]],r=1,k=3,s=1)
sscglist_3[[2]]=spatialShrunkenCentroids(GLAA_triplicate[[2]],r=1,k=3,s=1)
sscglist_3[[3]]=spatialShrunkenCentroids(GLAA_triplicate[[3]],r=1,k=3,s=1)

for(i in 1:length(sscglist_3)){
  filename=paste(name[[i]], "_sscg_3.RData",sep="")
  sscg=sscglist_3[[i]]
  save(sscg, file=filename)  
}

#four clusters
sscglist_4=list()
sscglist_4[[1]]=spatialShrunkenCentroids(GLAA_triplicate[[1]],r=1,k=4,s=1)
sscglist_4[[2]]=spatialShrunkenCentroids(GLAA_triplicate[[2]],r=1,k=4,s=1)
sscglist_4[[3]]=spatialShrunkenCentroids(GLAA_triplicate[[3]],r=1,k=4,s=1)
for(i in 1:length(sscglist_4)){
  filename=paste(name[[i]], "_sscg_4.RData",sep="")
  sscg=sscglist_4[[i]]
  save(sscg, file=filename)  
}

#five clusters
sscglist_5=list()
load("GLAA_2_180627_sscg_5_r2.RData")
sscglist_5[[2]]=sscg
load("GLAA_3_180710_sscg_5_r2.RData")
sscglist_5[[3]]=sscg
load("GLAA_1_180620_sscg_5_r2.RData")
sscglist_5[[1]]=sscg

#seven clusters
sscglist_7=list()
sscglist_7[[1]]=spatialShrunkenCentroids(GLAA_triplicate[[1]],r=1,k=7,s=1)
sscglist_7[[2]]=spatialShrunkenCentroids(GLAA_triplicate[[2]],r=1,k=7,s=1)
sscglist_7[[3]]=spatialShrunkenCentroids(GLAA_triplicate[[3]],r=1,k=7,s=1)
for(i in 1:length(sscglist_7)){
  filename=paste(name[[i]], "_sscg_7.RData",sep="")
  sscg=sscglist_7[[i]]
  save(sscg, file=filename)  
}

## Step 6: Export Segmentation and Top Marker Results as PDF

#import results by wash and matrix
#image the results
setwd("rdata_directory")
sscg_list <- as.matrix(read.table("dirlist_sscg.txt"))

#rename the files
load(sscg_list[[2]])
GLAA_1_sscg_4=sscg
save(GLAA_1_sscg_4, file=sscg_list[[2]])

#load all files
for(i in 1:length(sscg_list)){load(sscg_list[[i]])}
sscg_data <- list(GLAA_1_sscg_3,
                  GLAA_1_sscg_4,
                  GLAA_1_sscg_5,
                  GLAA_1_sscg_5_r2,
                  GLAA_1_sscg_7,
                  GLAA_2_sscg_3,
                  GLAA_2_sscg_4,
                  GLAA_2_sscg_5,
                  GLAA_2_sscg_5_r2,
                  GLAA_2_sscg_7,
                  GLAA_3_sscg_3,
                  GLAA_3_sscg_4,
                  GLAA_3_sscg_5,
                  GLAA_3_sscg_5_r2,
                  GLAA_3_sscg_7)

sscg_name=sscg_name[c(20:24, 26:30, 32:36)]

par(mfrow=c(2,3), mai = c(0.4,0.4,0.4,0.4))

for(i in 1:5){
  image(sscg_data[[i]], main=sscg_name[i], strip=FALSE, key=TRUE,
        axes = FALSE, xaxt='n', yaxt='n')}

#AFPos
load("GLAA_1.Rdata")
load("GLAA_2.Rdata")
load("GLAA_3.Rdata")

#GLAA1
pdf("GLAA_1.pdf",width=9, height=9); 
for(j in 1:5){
  length=as.numeric(sscg_data[[j]]$k)
  for (i in 1:length){
    image(sscg_data[[j]],column=i,layout=c(3,3), main=sscg_list[[j]],strip=FALSE)
    image(GLAA_1, colorkey=FALSE,main="Top 8 markers",
          mz=topLabels(sscg_data[[j]],model=1,n=20,filter=list(classes=i))$mz[1:8],normalize.image="linear")  
  }  
}
dev.off()

#GLAA2
pdf("GLAA_2.pdf", width=9, height=9); 
for(j in 6:10){
  length=as.numeric(sscg_data[[j]]$k)
  for (i in 1:length){
    image(sscg_data[[j]],column=i,layout=c(3,3), main=sscg_list[[j]],strip=FALSE)
    image(GLAA_2, colorkey=FALSE,main="Top 8 markers",
          mz=topLabels(sscg_data[[j]],model=1,n=20,filter=list(classes=i))$mz[1:8],normalize.image="linear")  
  }  
}
dev.off()

#GLAA3
pdf("GLAA_3.pdf", width=9, height=9); 
for(j in 11:15){
  length=as.numeric(sscg_data[[j]]$k)
  for (i in 1:length){
    image(sscg_data[[j]],column=i,layout=c(3,3), main=sscg_list[[j]],strip=FALSE)
    image(GLAA_3, colorkey=FALSE,main="Top 8 markers",
          mz=topLabels(sscg_data[[j]],model=1,n=20,filter=list(classes=i))$mz[1:8],normalize.image="linear")  
  }  
}
dev.off()
