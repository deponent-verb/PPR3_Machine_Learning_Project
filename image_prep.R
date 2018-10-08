#turning matrices into images

load(file="~/work/PPR3/data/neutral.Rdata")


for(i in 1000){
  m<-haplo_padded[[i]]
  name=paste("~/work/PPR3/processed_data/images/neutral",i,".JPEG",sep="")
  writeJPEG(m,name)
}

load(file="~/work/PPR3/data/selection.Rdata")

for(i in 1000){
  m<-haplo_padded[[i]]
  name=paste("~/work/PPR3/processed_data/images/selection",i,".JPEG",sep="")
  writeJPEG(m,name)
}

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

