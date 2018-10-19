library(keras)
library(ggplot2)

model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu",
                input_shape = c(300, 50, 1)) %>%
  layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 64, kernel_size = c(3, 3), activation = "relu") %>% layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>% layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_conv_2d(filters = 128, kernel_size = c(3, 3), activation = "relu") %>% layer_max_pooling_2d(pool_size = c(2, 2)) %>%
  layer_flatten() %>%
  layer_dense(units = 512, activation = "relu") %>%
  layer_dense(units = 4, activation = "softmax")

model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = optimizer_rmsprop(lr = 1e-4),
  metrics = c("acc")
)

#setting up directories

base_dir<- "~/work/PPR3/processed_data/multinomial_images/"
#base_dir<- "~/work/PPR3/processed_data/images/"

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
  class_mode = "categorical"
)

validation_generator <- flow_images_from_directory(
  generator = validation_datagen,
  directory=validation_dir,
  target_size = c(300, 50),
  color_mode = "grayscale",
  batch_size = 20,
  class_mode = "categorical"
)

batch <- generator_next(train_generator)
str(batch)
#check 20 samples in each batch, 600*50 images, 1 channel

#running ML

multi_history <- model %>% fit_generator(
  train_generator,
  steps_per_epoch = 100,
  epochs = 50,
  validation_data = validation_generator,
  validation_steps = 50
)

save(multi_history,file="~/work/PPR3/models/multinomial_history.Rdata")

#saving model

model %>% save_model_hdf5("~/work/PPR3/models/multinomial_model.h5")
model<-load_model_hdf5("~/work/PPR3/models/test.h5")

#predicting images

img_path<- "~/work/PPR3/processed_data/multinomial_images/validation/s=0.000398107170553497/s=0.000398107170553497_1001.JPEG"
#img<-image_load(img_path,grayscale=TRUE)
# multi_history %>% predict(img)


img<-image_load(img_path,grayscale = TRUE,target_size = c(300,50))%>%
  image_to_array()
img <- array_reshape(img, dim=c(1,300,50)) 
#img <- imagenet_preprocess_input(img)

S.new[,,,1] <- img/255
#S.new <- array(img, dim=c(1, 300, 50, 1))
#S.new[,,,1] <- img/255
#preds<-model(predict(S.new))

pred= predict(object = model, x=S.new)
result=selection[max(pred)]

result_vector=data.frame()

get_predictions<-function(s_coeff, selection_vec){
  
  for(i in 1001:1100){
    img_path=paste0("~/work/PPR3/processed_data/multinomial_images/validation/s=",s_coeff,"/s=",s_coeff,"_",i,".JPEG")
    img<-image_load(img_path,grayscale = TRUE,target_size = c(300,50))%>%
    image_to_array()
    img <- array_reshape(img, dim=c(1,300,50,1)) / 255
    #S.new[,,,1] <-img/255

  pred= predict(object = model, x=img)
  #print(pred)
  result=selection_vec[which.max(pred)]
  result_vector=rbind(result_vector,cbind(s = s_coeff, pred = result))
  }
  #object_name=paste0("~/work/PPR3/models/predictions/",s,".Rdata")
  return(result_vector)
}

selection<-10^seq(-2,-4,-0.2)
short_selection<-c(0.0100000000,0.0010000000,0.00158489319246111,0.00251188643150958,s=0.00398107170553497,s=0.000398107170553497,s=0.00630957344480193,s=0.000630957344480193)

res = lapply(short_selection, function(x) get_predictions(s_coeff=x, short_selection))
res = do.call(rbind, res)


# res = lapply(selection[1:3], function(x) get_predictions(s_coeff=x, selection))
# res = do.call(rbind, res)

plot(res[,1], res[,2])
abline(c(0,1))

ggplot(res, aes(s, pred)) + geom_count() + scale_x_log10() + scale_y_log10()
