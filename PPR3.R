library(phonTools)
library(MASS)
setwd("~/discoal/")

num_pad_total = 200

for (fn in paste("test", 1:100, sep="_")) {
  
  #x = readLines(con = "test.txt")
  
 # cmd = paste("~/discoal/discoal", nsamp, nrep, nsites, "-t", theta)
  
  x = system("~/discoal/discoal 10 1 100000 -t 60 -r 40", intern = TRUE)

  start = which(substr(x, 1,3) == "pos") + 1  # Searching for the line with "position" at the beginning
  end = length(x)
  
  segsites = as.numeric(gsub(pattern = "seg.* ", replacement = "", x = x[substr(x, 1,3) == "seg"]))  # Searching for the line with "position" at the beginning
  
  haplo = sapply(x[start:end], function(s) {as.numeric(strsplit(s, split="")[[1]])}, USE.NAMES = F)

  num_pad = num_pad_total - segsites
  
  haplo_padded = rbind(haplo, zeros(x=num_pad, y=ncol(haplo)))
  
  write.matrix(t(haplo_padded), file = )
  
}

#save(), and load() to make it into R object