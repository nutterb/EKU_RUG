#* Install qcc, if needed
if (!"qcc" %in% installed.packages()) install.packages("qcc")
if (!"dplyr" %in% installed.packages()) install.packages("dplyr")
if (!"tidyr" %in% installed.packages()) install.packages("tidyr")
if (!"magrittr" %in% installed.packages()) install.packages("magrittr")
if (!"ggplot2" %in% installed.packages()) install.packages("ggplot2")

library(qcc)
library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)


OJ <- read.csv("MeetingContent/2016-03-25/OrangeJuice.csv",
               stringsAsFactors = FALSE)

qcc(OJ$nonconforming, 
    type = "p",
    sizes = OJ$sample_size)


qcc(OJ$nonconforming,
    type = "np",
    sizes = OJ$sample_size)
