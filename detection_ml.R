library(keras)
library(rlist)

load(file="~/work/PPR3/processed_data/padded_haplotypes.Rdata")
s<-c(0,0.001,0.005,0.01,0.02,0.05,0.1,0.2,0.5)

# Make s vector

s_vec = rep(s, sapply(haplo_padded, length))
haplo_padded_flat = unlist(haplo_padded, recursive = F)

data=list()
data$samples=haplo_padded_flat
data$labels=s_vec

#picking only s=0, s=0.5

small_data=list()
small_data$samples=list(haplo_padded_flat[1:1000],haplo_padded_flat[8001:9000])
small_data$samples=unlist(small_data$samples, recursive = F)
small_data$labels=append(rep(0,1000),rep(1,1000))

#shuffle the data
ID=sample(length(small_data$labels),length(small_data$labels))

#putting into training and testing sets

train_size=1700
test_size=300

train<-list()
for(i in 1:train_size){
  train$samples[i]<-small_data$sample[ID[i]] 
  train$label[i]<-small_data$labels[ID[i]] 
}

test<-list()
for(i in 1:test_size){
  test$samples[i]<-small_data$sample[ID[i+train_size]] 
  test$label[i]<-small_data$labels[ID[i+train_size]] 
}


train<-list()
train["samples"]<-list()
train["labels"]<-list()

test<-list()
test["samples"]<-list()
test["labels"]<-list()

#neural network starts here





#haplo_padded_flat[s_vec==0]
#data[["samples"]]<-sapply(haplo_padded[1:2], identity)

#str(haplo_padded[[1]])  list of 1000









#diagnosis
genome["train"][1]<-1

# mnist<-dataset_mnist()
# train_images = mnist$train$x
# train_labels = mnist$train$y
# test_images= mnist$test$x
# test_labels=mnist$test$y