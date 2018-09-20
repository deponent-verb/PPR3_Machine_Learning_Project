library(phonTools)
library(MASS)
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

#initialization for function, make sure you clean these on each run

haplo_list=list()
segsites_vec=c()
haplo_padded=list()
num_sim=10

#running simulations

for (i in 1:num_sim){
  
  # if (i%%1000 == 0) {
  #   print(i) 
  #   Sys.time()
  # }
  selection_start=runif(1,min=0,max=0.2)
  
  cmd = paste("~/discoal/discoal", sampleSize, nrep, nSites, "-t", theta, "-r", r, "-A",+
                anc_samples, 0 , 0.05, "-A", anc_samples, 0 , 0.1, "-A", anc_samples, 0 , 0.15, "-A", anc_samples, 0 , 0.20,
                "-ws", selection_start, "-x", 0.5 , "-a", alpha[1] )
  
  while(TRUE) {
    sim=system(cmd, intern=TRUE)
    segsites = as.numeric(gsub(pattern = "seg.* ", replacement = "", sim[substr(sim, 1,3) == "seg"]))
    if (segsites != 0) {
      break
    }
  }
  
  segsites_vec = c(segsites_vec,segsites)  
  
  start <- which(substr(sim, 1,3) == "pos") + 1  # Searching for the line with "position" at the beginning
  end = length(sim)
  
  
  haplo_list[[i]] = sapply(sim[start:end], function(s) {as.numeric(strsplit(s, split="")[[1]])}, USE.NAMES = F)
}

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

#save as R object

save(haplo_padded,file="~/work/PPR3/data/neutral/neutral_object.R")

#writing the files out
for (i in 1:num_sim){
  if (segsites_vec[i] == 0) {
    next
  }
  file_name=paste("~/work/PPR3/data/neutral/sim", i, ".txt")
  write.matrix(t(haplo_padded), file =file_name)
}


#x<-c(1,1,1)
#save(x,file="~/work/PPR3/data/neutral/neutral_object.R")


#for checking functions
segsites_vec
haplo_list
haplo_padded
image(haplo_padded[[2]])

dim(haplo_list[[1]])
dim(haplo_padded[[1]])
max(segsites_vec)


#save(), and load() to make it into R object