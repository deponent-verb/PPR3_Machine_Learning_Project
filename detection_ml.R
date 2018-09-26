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
save(small_data,file="~/work/PPR3/processed_data/small_data.Rdata")

#shuffle the data
ID=sample(length(small_data$labels),length(small_data$labels))

#putting into training and testing sets

train_size=1700
test_size=300

train<-list()
for(i in 1:train_size){
  train$samples[i]<-small_data$sample[ID[i]] 
  train$labels[i]<-small_data$labels[ID[i]] 
}

test<-list()
for(i in 1:test_size){
  test$samples[i]<-small_data$sample[ID[i+train_size]] 
  test$labels[i]<-small_data$labels[ID[i+train_size]] 
}

# look at genotype matrices

par(mfrow=c(4,8))
par(mar=c(0,0,0,0))
for (i in 1:16) {
  image(haplo_padded_flat[s_vec==0][[1+i]], col=c("white", "black"))
  image(haplo_padded_flat[s_vec==0.5][[1+i]], col=c("white", "black"))
}
#neural network starts here

train_samples<-train$samples
train_labels<-train$labels
test_samples<-test$samples
test_labels<-test$labels


network <- keras_model_sequential() %>%
  layer_dense(units = 512, activation = "relu", input_shape = c(1212 *50)) %>%
  layer_dense(units = 2, activation = "softmax")

network %>% compile(
  optimizer = "rmsprop",
  loss = "categorical_crossentropy",
  metrics = c("accuracy")
)

train_labels <- to_categorical(train_labels)
test_labels <- to_categorical(test_labels)

train_samples <- array_reshape(train_samples, c(1700, 1212 *50))
train_samples <- train_samples / 1.0
test_samples <- array_reshape(test_samples, c(300, 1212 *50))
test_samples <- test_samples / 1.0

#learning

network %>% fit(train_samples, train_labels, epochs = 40, batch_size = 128)

#testing

metrics <- network %>% evaluate(test_samples, test_labels)
metrics

type_of(train_labels[1])

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