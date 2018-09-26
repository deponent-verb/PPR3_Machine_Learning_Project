library(keras)

load(file="~/work/PPR3/processed_data/padded_haplotypes.Rdata")

#partitioning data

data<-list()
data["samples"]<-list()
data["labels"]<-list()

##getting the neutral data and labelling

  for (i in 1:length(haplo_padded[[1]])){
    data[["samples"]][[i]]<-haplo_padded[[1]][[i]]
    data[["labels"]][[i]]<-0
  }

##getting s=0.5 data

push<-length(haplo_padded[[1]])
for (i in push+1:push+push+length(haplo_padded[[9]])){
  data[["samples"]][[i]]<-haplo_padded[[1]][[i]]
  data[["labels"]][[i]]<-0
}

for(s in c(1,9)){
  print(s)
}


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