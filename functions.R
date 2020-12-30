#conduct preprocessing of imzml files using pre-defined parameters
#only works with Cardinal 1.2.1
multiIMSred=function(cardinaldatalist,filenamelist){
  cardinaldatalist_rd=vector("list",length(cardinaldatalist))
  for(i in 1:length(cardinaldatalist)){
    #cardinaldatalist.peaklist <- peakPick(cardinaldatalist[[i]], pixel = seq(1, ncol(cardinaldatalist[[i]]), by = 10), method = "simple", SNR = 3)
    cardinaldatalist.peaklist <- peakPick(cardinaldatalist[[i]], method = "simple", SNR = 3)
    cardinaldatalist.peaklist <- peakAlign(cardinaldatalist.peaklist, ref = cardinaldatalist[[i]], method = "diff",units = "ppm", diff.max = 50)
    #cardinaldatalist.peaklist <- peakFilter(cardinaldatalist.peaklist, method = "freq", freq.min = ncol(cardinaldatalist.peaklist)*0.001)
    cardinaldatalist.peaks    <- reduceDimension(cardinaldatalist[[i]], ref = cardinaldatalist.peaklist, type = "height")
    filename=paste(filenamelist[[i]], ".RData", sep="")
    save(cardinaldatalist.peaks, file=filename)
    cardinaldatalist_rd[[i]]=cardinaldatalist.peaks
    rm(cardinaldatalist.peaks,cardinaldatalist.peaklist)
  }
  return(cardinaldatalist_rd)}

#split samples from one imzml file into multiple samples
#will only work with Cardinal 1.2.1
sampleROIs<-function(cardinaldata, XMLdata="myxml.xml",width=3){
  require(XML)
  XMLspots<-xmlToList(XMLdata)
  spots <-lapply(XMLspots[which(names(XMLspots) == "Class")],function(x){
    spots <- list()
    for(i in 1:(length(x == "Element") -1)){
      spots[[i]] <- x[[i]][["Spot"]]
    }
    spots <-unlist(spots)
    spots <-substr(spots,6,100)
    return(spots)})
  names(spots) <- NULL
  sampnames <- sapply(XMLspots[which(names(XMLspots) == "Class")],function(x)x$.attrs[["Name"]])
  
  cardinaldatas <- lapply(spots,function(x){
    cardinaldataf <- cardinaldata[,paste0("X",formatC(coord(cardinaldata)[,1], width = width, format = "d", flag = "0"),"Y",formatC(coord(cardinaldata)[,2], width = width, format = "d", flag = "0")) %in% x]
    return(cardinaldataf)
  })
  
  for(i in 1:length(cardinaldatas)){
    levels(cardinaldatas[[i]]$sample) <- sampnames[i]
    protocolData(cardinaldatas[[i]]) <- AnnotatedDataFrame(data=data.frame(row.names=sampleNames(cardinaldatas[[i]])))
    cardinaldatas[[i]] <- regeneratePositions(cardinaldatas[[i]])
    print(validObject(cardinaldatas[[i]]))
  }
  
  cardinaldata<-do.call(Cardinal::combine,cardinaldatas)
  return(cardinaldata)}


#conducts SSCG on a list of imaging data processed with Cardinal 1.2.1
#will not work if one of your item is not a valid object
multiSSCG=function(cardinaldatalist,filenamelist,r,k,s){
  sscglist=vector("list",length(cardinaldatalist))
  name=filenamelist
  for(i in 1:length(cardinaldatalist)){
    sscglist[[i]]=spatialShrunkenCentroids(cardinaldatalist[[i]],r=r,k=k,s=s)
    filename=paste(name[[i]], "_sscg_","r", r, "_k", k,  "_s", s, ".RData",sep="")
    sscg=sscglist[[i]]
    save(sscg, file=filename)
  }
  return(sscglist)}
