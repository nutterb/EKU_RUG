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

#* explore package contents
library(help = qcc)


Wafer <- read.csv("MeetingContent/2016-03-25/Wafers.csv",
                  stringsAsFactors = FALSE)


#* Create a qcc object
xbar <- 
  qcc(data = Wafer[, -1],
      type = "xbar",
      plot = FALSE)

#* Plot the object 
plot(xbar, title = "xbar Chart for Wafers")

#* Explore the attributes of the qcc object
attributes(xbar)

xbar$statistics  #* sample means
xbar$sizes       #* Sample sizes
xbar$std.dev     #* standard deviation
xbar$limits      #* control limits
xbar$violations  #* violating points (none in this example)

#* Create the R Chart to go with the xbar Chart
#* Notice, we let this print by default
rchart <-
  qcc(data = Wafer[, -1], 
      type = "R",
      title = "R-Chart for Wafers")


#* Group size of 1

WaferOne <- 
  gather(Wafer, wafer_id, flow_width,
         wafer1:wafer5)

xbar_one <- 
  qcc(WaferOne[, "flow_width", drop = FALSE],
      type = "xbar.one")

xbar_one$violations


#* Cusum chart

cusum_chart <- 
  cusum(Wafer[, -1])

cusum_chart_one <- 
  cusum(WaferOne[, "flow_width", drop = FALSE])



#* EWMA Chart

ewma_chart <- 
  ewma(Wafer[, -1])



#******************************************
#* Make a prettier xbar-chart

xbar <- 
  qcc(data = Wafer[, -1],
      type = "xbar",
      plot = FALSE)

Wafer$sample_means <- xbar$statistics

ggplot(Wafer,
       mapping = aes(x = sample,
                     y = sample_means)) + 
  geom_point() + 
  geom_line() + 
  geom_hline(yintercept = xbar$center,
             colour = "red") + 
  geom_hline(yintercept = xbar$limits[1],
             colour = "blue") + 
  geom_hline(yintercept = xbar$limits[2],
             colour = "blue") + 
  geom_point(data = WaferOne,
             mapping = aes(x = sample,
                           y = flow_width),
             colour = "gray") + 
  xlab("Sample Number") +
  ylab("Sample Mean")


#******************************************
#* Make a prettier ewma-chart

ewma_chart <- 
  ewma(Wafer[, -1],
       plot = FALSE)

Wafer$sample_means <- ewma_chart$statistics
Wafer$ewma_x <- ewma_chart$x
Wafer$ewma_y <- ewma_chart$y
Wafer$ucl <- ewma_chart$limits[, "UCL"]
Wafer$lcl <- ewma_chart$limits[, "LCL"]

ggplot(Wafer,
       mapping = aes(x = ewma_x,
                     y = ewma_y)) + 
  geom_point() + 
  geom_hline(yintercept = ewma_chart$center,
             colour = "red") + 
  geom_step(mapping = aes(y = ucl),
            colour = "blue") + 
  geom_step(mapping = aes(y = lcl),
            colour = "blue")
