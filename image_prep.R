library(jpeg)

#turning matrices into images

setwd("~/work/Adelaide/AncientSelection_Anthony/testing_CNN/")

load(file="discoal_sim_s=0.Rdata")

for(i in 1:length(haplo_list)){
  m<-haplo_list[[i]]
  if (i<=100) {
    name=paste("./images/test/neutral/neutral",i,".JPEG",sep="")
  } else {
    if (i>100 & i<=200){
      name=paste("./images/validation/neutral/neutral",i,".JPEG",sep="")
    } else {
      name=paste("./images/train/neutral/neutral",i,".JPEG",sep="")
    }
  }
  writeJPEG(m,name, quality=1)
}

load(file="discoal_sim_s=0.01.Rdata")

for(i in 1:length(haplo_list)){
  m<-haplo_list[[i]]
  if (i<=100) {
    name=paste("./images/test/selected/selected",i,".JPEG",sep="")
  } else {
    if (i>100 & i<=200){
      name=paste("./images/validation/selected/selected",i,".JPEG",sep="")
    } else {
      name=paste("./images/train/selected/selected",i,".JPEG",sep="")
    }
  }

  writeJPEG(m,name, quality=1)
}

####STOP HERE




load(file = "~/work/PPR3/processed_data/small_data.Rdata")
library(jpeg)
sim_size=1000

m<-small_data[[1]][[1]]
writeJPEG(m,target="~/work/PPR3/processed_data/s=0_images/test")

#fix this later
image_maker <- function(s){
  for(i in 1:sim_size){
    m<-small_data[[1]][[i]]
    name=paste("~/work/PPR3/processed_data/images/s=",s,"/",i,".JPEG",sep="")
  #  name=paste("~/work/PPR3/processed_data/images/s=0",i,".JPEG")
    writeJPEG(m,target=name)
  }
}

image_maker_sel <- function(s){
  for(i in sim_size+1:2000){
    print(i)
    m<-small_data[[1]][[i]]
    name=paste("~/work/PPR3/processed_data/images/s=",s,"/",i,".JPEG",sep="")
    #  name=paste("~/work/PPR3/processed_data/images/s=0",i,".JPEG")
    writeJPEG(m,target=name)
  }
}

for(i in sim_size:1005){
  print(i)
}

image_maker(0)
image_maker_sel(0.5)

target=paste("~/work/PPR3/processed_data/s=", s,"_images/test2.jpeg")

object_name=paste("~/work/PPR3/data/discoal_sim_s=", s,".R")

