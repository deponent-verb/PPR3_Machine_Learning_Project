library(keras)
library(rlist)
library(phonTools)
setwd("~/work/PPR3/data/")

#loading genome data
s<-c(0,0.001,0.005,0.01,0.02,0.05,0.1,0.2,0.5)
haplo_list_full<-list()

for (i in 1:length(s)){
  batch<-paste("discoal_sim_s=", s[i],".R")
  load(file=batch)
  haplo_list_full<-list.append(haplo_list_full,haplo_padded)
}

#padding

pad_total=0
##looping for each s
for( s in 1:length(haplo_list_full[][])){
  ##looping for each matrix for a particular s
  for( i in 1:length(haplo_list_full[[s]][])){
    x<-dim(haplo_list_full[[s]][[i]])
    if(x[1]>pad_total){
      pad_total=x[1]
    }
  }
}

haplo_padded=list()

for( s in 1:length(haplo_list_full[][])){
  for( i in 1:length(haplo_list_full[[s]][])){
  haplo_padded[[s]][[i]]=rbind(haplo_list_full[[s]][[i]], zeros(x=pad_total,y=ncol(haplo_list_full[[s]][[i]])))
  }
}

haplo_list_full[[1]][[999]]


#    haplo_padded[[i]] = rbind(haplo_list[[i]], zeros(x=num_pad, y=ncol(haplo_list[[i]])))

pad_total=dim(haplo_list_full[[1]][[999]])

summary(haplo_list_full)
haplo_list_full[[1]][[999]]

dim(haplo_list_full[[1]][[999]])[1]
dim(haplo_list_full[[2]][[999]])[1]
