library(keras)

model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 32, kernel_size = c(3, 3), activation = "relu",
                input_shape = c(600, 50, 1)) %>%
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

base_dir<- "~/work/PPR3/processed_data/images"
train_dir<-file.path(base_dir,"train")
validation_dir<-file.path(base_dir,"validation")
test_dir<-file.path(base_dir,"test")

train_generator <- flow_images_from_directory(
  directory = train_dir,
  target_size = c(600, 50),
  color_mode = "grayscale",
  batch_size = 20,
  class_mode = "binary"
)

validation_generator <- flow_images_from_directory(
  directory=validation_dir,
  target_size = c(600, 50),
  color_mode = "grayscale",
  batch_size = 20,
  class_mode = "binary"
)

batch <- generator_next(train_generator)
str(batch)
#check 20 samples in each batch, 600*50 images, 1 channel

#running ML

history <- model %>% fit_generator(
  train_generator,
  steps_per_epoch = 100,
  epochs = 30,
  validation_data = validation_generator,
  validation_steps = 50
)
