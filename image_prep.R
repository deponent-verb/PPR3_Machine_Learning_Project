library(jpeg)

#making the directories
base_dir<-"~/work/PPR3/processed_data/images"
train_dir<-file.path(base_dir,"train")
validation_dir<-file.path(base_dir,"validation")
test_dir<-file.path(base_dir,"test")
dir.create(train_dir)
dir.create(validation_dir)
dir.create(test_dir)

dir_setup<-function (s){
  new_train<-paste0(train_dir,"/s=",s)
  new_valid<-paste0(validation_dir,"/s=",s)
  new_test<-paste0(test_dir,"/s=",s)
  
  dir.create(new_train)
  dir.create(new_valid)
  dir.create(new_test) 
}

for (i in 1:length(selection)){
  dir_setup(selection[i])
}

#turning matrices into images

test_size=100
validation_size=100

setwd("~/work/PPR3/raw_data/")

make_image<-function(s){
  object<-paste0("discoal_sim_s=",s,".Rdata")
  load(file=object)
  for(i in 1:length(haplo_list)){
    m<-haplo_list[[i]]
    if (i<=test_size) {
      name=paste("~/work/PPR3/processed_data/images/test/s=",s,"/","s=",s,"_",i,".JPEG",sep="")
    } else if (i<=test_size+validation_size){
        name=paste("~/work/PPR3/processed_data/images/validation/s=",s,"/","s=",s,"_",i,".JPEG",sep="")
      } else 
        name=paste("~/work/PPR3/processed_data/images/train/s=",s,"/","s=",s,"_",i,".JPEG",sep="")
    writeJPEG(m,name, quality=1)
  }  
}

#make_image(0.01)

for(i in 1:length(selection)){
  make_image(selection[i])
}

make_image(0)

test_size=3
validation_size=4
for (i in 1:10){
  if (i<=test_size){
    print("test")
  }
  else if (i<=test_size+validation_size){
      print("validation")
  }
  else
    print("train")
}




# load(file="discoal_sim_s=0.Rdata")
# 
# for(i in 1:length(haplo_list)){
#   m<-haplo_list[[i]]
#   if (i<=100) {
#     name=paste("./images/test/neutral/neutral",i,".JPEG",sep="")
#   } else {
#     if (i>100 & i<=200){
#       name=paste("./images/validation/neutral/neutral",i,".JPEG",sep="")
#     } else {
#       name=paste("./images/train/neutral/neutral",i,".JPEG",sep="")
#     }
#   }
#   writeJPEG(m,name, quality=1)
# }
# 
# load(file="discoal_sim_s=0.01.Rdata")
# 
# for(i in 1:length(haplo_list)){
#   m<-haplo_list[[i]]
#   if (i<=100) {
#     name=paste("./images/test/selected/selected",i,".JPEG",sep="")
#   } else {
#     if (i>100 & i<=200){
#       name=paste("./images/validation/selected/selected",i,".JPEG",sep="")
#     } else {
#       name=paste("./images/train/selected/selected",i,".JPEG",sep="")
#     }
#   }
#   writeJPEG(m,name, quality=1)
# }

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

