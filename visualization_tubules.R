#This script provides the set-up for exporting tubule results for figures

##Step 1: Set-up environment
require(Cardinal)
source("functions.R")

#load in list of imzml data
setwd("imzml_directory")
imzml=as.matrix(read.table("imzml.txt"))

#load in list of samples
xml=as.matrix(read.table("xml.txt"))

#obtain list of samples to be included in the figure
list = c(1, 4, 8, 15, 18, 20, 23, 25, 28, 31, 33, 37, 41, 44, 49, 54)

##Step 2: Split sample from data set

#Split samples using a loop
for (j in 1:length(list)){
  par(mfrow=c(2,2), mai = c(0.4,0.4,0.4,0.4))
  number=list[[j]]
  file=paste(xml[[number]],".txt",sep="")
  file=as.matrix(read.table(file))
  load(file[[1]])
  length(file)
  #read original data
  image(data, mz=855.8, plusminus=0.5)
  
  #export data
  for(i in 2:length(file)){
    #split data
    ROI=sampleROIs(data, XMLdata="PBS_ABDrip_SUB_DAN_NEG_180314_1.xml",width=3)
    
    #confirm that splitting was done correctly
    image(ROI, mz=855.8, plusminus=0.5)
    
    #save sample
    filename=strsplit(file[[i]],".xml")
    #save to directory with the split samples
    setwd("roi_directory")
    #save sample
    save(ROI, file=paste(filename,".RData",sep=""))
    #set to original directory for the imzml
    setwd("imzml_directory")
  }  
}

##Step 3: Combine pieces of samples into one
#rename some unsplit data
source("functions.R")
setwd("roi_directory")
combinethese=as.matrix(read.table("combinethese.txt"))
samples=strsplit(combinethese,".Rdata")

#don't change data; also, if you got more than two pieces, need to do it multiple times.
for (i in 2:length(combinethese)){
  par(mfrow=c(2,2), mai = c(0.4,0.4,0.4,0.4))
  load(combinethese[[i]])
  image(ROI, mz=800, plusminus=0.1)
  levels(ROI$sample)[1:2] <- samples[[i]]
  protocolData(ROI) <- AnnotatedDataFrame(data=data.frame(row.names=sampleNames(ROI)))
  ROI<- regeneratePositions(ROI)
  validObject(ROI)
  image(ROI, mz=800, plusminus=0.1)
  save(ROI, file=combinethese[[i]])  
}

##Step 4: Export figures 
setwd("roi_directory")

#negative data, mz=859.6
images=as.matrix(read.table("negdata_wash.txt"))
par(mfrow=c(2,3), mai = c(0.6,0.6,0.6,0.6),bg="black")
name=filenameinfo(read.table("negdata_wash.txt"), sep="_", 
                  colnames=c("Full","Buffer", "Wash", "Method", "Matrix", "Mode", "Date"))

for(i in 1:length(images)){
  load(images[[i]])
  image(ROI,mz=859.6, plusminus=0.3, 
        xaxt="n", yaxt="n",col.main="white", cex.main=6,
        main=paste(name$"Buffer"[[i]],name$"Wash"[[i]],name$"Method"[[i]],name$"Matrix"[[i]], sep=" "),
        strip=FALSE, colorkey=FALSE, normalize.image=c("linear"), contrast.enhance=c("suppression"))
}

#positive data, mz=806.5, 796.5
images=as.matrix(read.table("posdata_wash.txt"))
par(mfrow=c(2,3), mai = c(0.6,0.6,0.6,0.6),bg="black")

name=filenameinfo(read.table("posdata_wash.txt"), sep="_", 
                  colnames=c("Full","Buffer", "Wash", "Method", "Matrix", "Mode", "Date"))

for(i in 1:length(images)){
  load(images[[i]])
  image(ROI,mz=796.5, plusminus=0.3, 
        xaxt="n", yaxt="n",col.main="white", cex.main=6,
        main=paste(name$"Buffer"[[i]],name$"Wash"[[i]],name$"Method"[[i]],name$"Matrix"[[i]], sep=" "),
        strip=FALSE, colorkey=FALSE, normalize.image=c("linear"), contrast.enhance=c("suppression"))
}
