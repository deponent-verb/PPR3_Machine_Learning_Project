library(phonTools)
library(MASS)
setwd("~/discoal/")

num_pad_total = 200

#set up discoal parameters
mu=1.5e-8
recomb_rate=1e-8
Ne=10000
nSites=10000
theta=4*Ne*mu*nSites
r=4*Ne*recomb_rate*nSites
sampleSize=5
selection<-c(0,0.001,0.005,0.01,0.02,0.05,0.1,0.2,0.5)
nrep=1
nSites<-format(100000,scientific = FALSE)

for (i in 1:10){
  
  cmd = paste("~/discoal/discoal", sampleSize, nrep, nSites, "-t", theta, "-r", r)
  
  sim=system(cmd, intern=TRUE)

  start <- which(substr(sim, 1,3) == "pos") + 1  # Searching for the line with "position" at the beginning
  end = length(sim)
  
  segsites = as.numeric(gsub(pattern = "seg.* ", replacement = "", sim[substr(sim, 1,3) == "seg"]))  
  
  haplo = sapply(sim[start:end], function(s) {as.numeric(strsplit(s, split="")[[1]])}, USE.NAMES = F)

  num_pad = num_pad_total - segsites
  
  haplo_padded = rbind(haplo, zeros(x=num_pad, y=ncol(haplo)))
  
  #image(haplo_padded)
  
  file_name=paste("~/work/PPR3/data/neutral/sim", i, ".txt")
  
  write.matrix(t(haplo_padded), file =file_name)
  
}

#save(), and load() to make it into R object