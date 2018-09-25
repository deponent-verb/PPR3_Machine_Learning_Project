library(keras)

load(file="~/work/PPR3/processed_data/padded_haplotypes.Rdata")

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