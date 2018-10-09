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

alpha<-c()

# for(i in seq_along(selection)){
#   #  print(selection[i])
#   alpha<-c(alpha, 2*Ne*selection[i])
# }

nrep=1
nSites<-format(nSites, scientific = FALSE)

######simulation code starts here!

random_discoal_sim <- function (num_sim){
  
  haplo_list = mclapply(1:num_sim, function(k){
    
    selection_start=runif(1,min=0,max=0.2)
    #selection_start=0.2
    s_coeff=runif(1,min=0,max=0.05)
    alpha=2*Ne*s_coeff
    
    cmd = paste("~/discoal/discoal", sampleSize, nrep, nSites, "-t", theta, "-r", r, "-A",+
                  anc_samples, 0 , 0.05, "-A", anc_samples, 0 , 0.1, "-A", anc_samples, 0 , 0.15, "-A", anc_samples, 0 , 0.20,
                "-ws", selection_start, "-x", 0.5 , "-a", alpha )
    
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
  })
  
  #save as R object
  object_name=paste0("~/work/PPR3/raw_data/binary/selection.Rdata")
  save(haplo_list,file=object_name)
}

random_discoal_sim(10000)
