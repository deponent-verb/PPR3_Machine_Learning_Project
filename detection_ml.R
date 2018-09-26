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


#haplo_padded_flat[s_vec==0]
#data[["samples"]]<-sapply(haplo_padded[1:2], identity)

#str(haplo_padded[[1]])  list of 1000




#processing data into train + test

train<-list()
train["samples"]<-list()
train["labels"]<-list()

test<-list()
test["samples"]<-list()
test["labels"]<-list()

genome<-list(train,test)



genome["train"]<-list()
genome["train"]["samples"]<-list()

genome["test"]<-list() 

train_size=700
test_size=300




#diagnosis
genome["train"][1]<-1

# mnist<-dataset_mnist()
# train_images = mnist$train$x
# train_labels = mnist$train$y
# test_images= mnist$test$x
# test_labels=mnist$test$y