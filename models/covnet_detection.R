library(keras)
rand_end=0.001

model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu",
                input_shape = c(300, 50, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>% layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>% layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>% layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dense(units = 512, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

model %>% compile(
  loss = "binary_crossentropy",
  optimizer = optimizer_rmsprop(lr = 1e-4),
  metrics = c("acc")
)

#setting up directories

#base_dir<- "~/work/PPR3/processed_data/binary_images/(0,0.05)"
base_dir<-paste0("~/work/PPR3/processed_data/binary_images/(0,",rand_end,")")
train_dir<-file.path(base_dir,"train")
validation_dir<-file.path(base_dir,"validation")
test_dir<-file.path(base_dir,"test")

test_datagen = image_data_generator(rescale=1/255)
validation_datagen = image_data_generator(rescale=1/255)

train_generator <- flow_images_from_directory(
  generator = test_datagen,
  directory = train_dir,
  target_size = c(300, 50),
  color_mode = "grayscale",
  batch_size = 20,
  class_mode = "binary"
)

validation_generator <- flow_images_from_directory(
  generator = validation_datagen,
  directory=validation_dir,
  target_size = c(300, 50),
  color_mode = "grayscale",
  batch_size = 20,
  class_mode = "binary"
)

batch <- generator_next(train_generator)
str(batch)
#check 20 samples in each batch, 150*50 images, 1 channel

#running ML

history <- model %>% fit_generator(
  train_generator,
  steps_per_epoch = 100,
  epochs = 50,
  validation_data = validation_generator,
  validation_steps = 50
)

#saving model and history
model_name=paste0("~/work/PPR3/models/binary_model(0,",rand_end,").h5")
model %>% save_model_hdf5(filepath=model_name)
history_name=paste0("~/work/PPR3/models/binary_history(0,",rand_end,").Rdata")
save(history,file=history_name)

#loading models

load(file="~/work/PPR3/models/binary_history(0,0.001).Rdata")
model<-load_model_hdf5("~/work/PPR3/models/binary_model(0,0.001).h5")

load(file="~/work/PPR3/models/binary_history(0,0.05).Rdata")
model<-load_model_hdf5("~/work/PPR3/models/binary_model(0,0.05).h5")

#detecting false positive rate

img_path=paste0 (base_dir,"/validation/neutral/neutral_",1000+i,".JPEG")
img<-image_load(img_path,grayscale = TRUE,target_size = c(300,50))%>%
  image_to_array()
img <- array_reshape(img, dim=c(1,300,50,1)) / 255
pred= predict(object = model, x=img)

false_positive <-function(num){
  count=0
  for(i in 1:num){
    img_path=paste0 (base_dir,"/validation/neutral/neutral_",1000+i,".JPEG")
    img<-image_load(img_path,grayscale = TRUE,target_size = c(300,50))%>%
      image_to_array()
    img <- array_reshape(img, dim=c(1,300,50,1)) / 255
    pred= predict(object = model, x=img)
    if(pred>0.5){
      count=count+1
    }
  } 
  return(count/num)
}

false_positive(num=1000)
#(0.0.05) gives 0.038
#(0,0.01) gives 0.032

false_negative <-function(num){
  count=0
  for(i in 1:num){
    img_path=paste0 (base_dir,"/validation/selection/s_",1000+i,".JPEG")
    img<-image_load(img_path,grayscale = TRUE,target_size = c(300,50))%>%
      image_to_array()
    img <- array_reshape(img, dim=c(1,300,50,1)) / 255
    pred= predict(object = model, x=img)
    if(pred<0.5){
      count=count+1
    }
  } 
  return(count/num)
}

false_negative(num=1000)
#(0.0.05) gives 0.02
#(0,0.01) gives  0.024
