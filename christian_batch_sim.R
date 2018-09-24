library(phonTools)
library(MASS)
library(parallel)
setwd("~/discoal/")

#set up discoal parameters
mu=1.5e-8
recomb_rate=1e-8
Ne=10000
nSites=100000
theta=4*Ne*mu*nSites
r=4*Ne*recomb_rate*nSites
sampleSize=50
anc_samples=10
selection<-c(0,0.001,0.005,0.01,0.02,0.05,0.1,0.2,0.5)
alpha<-c()

for(i in seq_along(selection)){
#  print(selection[i])
  alpha<-c(alpha, 2*Ne*selection[i])
}

nrep=1
nSites<-format(nSites, scientific = FALSE)

######simulation code starts here!

discoal_sim <- function (s_coeff,num_sim){

    start.time <- Sys.time()
  
    haplo_list = mclapply(1:num_sim, function(k){
    
    selection_start=runif(1,min=0,max=0.2)
    
    cmd = paste("~/discoal/discoal", sampleSize, nrep, nSites, "-t", theta, "-r", r, "-A",+
                  anc_samples, 0 , 0.05, "-A", anc_samples, 0 , 0.1, "-A", anc_samples, 0 , 0.15, "-A", anc_samples, 0 , 0.20,
                  "-ws", selection_start, "-x", 0.5 , "-a", s_coeff )
    
    while(TRUE) {
      sim=system(cmd, intern=TRUE)
      segsites = as.numeric(gsub(pattern = "seg.* ", replacement = "", sim[substr(sim, 1,3) == "seg"]))
      if (segsites != 0) {
        break
      }
    }
    
    start <- which(substr(sim, 1,3) == "pos") + 1  # Searching for the line with "position" at the beginning
    end = length(sim)
    
    return(sapply(sim[start:end], function(s) {as.numeric(strsplit(s, split="")[[1]])}, USE.NAMES = F))
  }, mc.cores = 8)
  
  segsites_vec = sapply(haplo_list, function(x) {dim(x)[1]})
  
  #padding
  
  num_pad_total=max(segsites_vec)
  for (i in 1:num_sim){
    if (segsites_vec[i] == 0) {
      next
    }
    if (segsites_vec[i] == 1) {
      haplo_list[[i]] = t(as.matrix(haplo_list[[i]]))
    }
    num_pad = num_pad_total - segsites_vec[i]
    haplo_padded[[i]] = rbind(haplo_list[[i]], zeros(x=num_pad, y=ncol(haplo_list[[i]])))
  }
  
  segsites_vec<-c()
  haplo_list<-list()
  
  #save as R object
  s=s_coeff/(2*Ne)
  object_name=paste("./discoal_sim_s=", s,".R")
  save(haplo_padded,file=object_name)
  
  haplo_padded<-list()
}

#Running simulations

for(i in 1:length(alpha)){
  start.time<-Sys.time()
  discoal_sim(s_coeff = alpha[i],num_sim = 10000)
  end.time<-Sys.time()
  total.time<-end.time-start.time
  progress=paste("Completed sim ", i , " in ", total.time)
  print(progress)
}

discoal_sim(s_coeff = 0,num_sim = 10)

#for checking functions


dim(haplo_list[[1]])
dim(haplo_padded[[1]])
max(segsites_vec)

segsites_vec
haplo_list
haplo_padded

image(haplo_padded[[2]])

#writing the files out
# for (i in 1:num_sim){
#   if (segsites_vec[i] == 0) {
#     next
#   }
#   file_name=paste("~/work/PPR3/data/neutral/sim", i, ".txt")
#   write.matrix(t(haplo_padded), file =file_name)
# }


#x<-c(1,1,1)
#save(x,file="~/work/PPR3/data/neutral/neutral_object.R")



