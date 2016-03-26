library(dplyr)
library(broom)

Impedance <- 
  read.csv(
    file = "MeetingContent/2016-03-25/Thermal_Impedance.csv",
    stringsAsFactors = FALSE
  ) %>%
  mutate(
    inspector = factor(inspector),
    part_number = factor(part_number)
  )
    

fit <- 
  aov(thermal_impedance ~ part_number * inspector,
       data = Impedance)

summary(fit)

result_frame <- tidy(fit)

attributes(terms(fit))[["factors"]]

result_frame


n_reps <- 3

var_parts <- 
  (result_frame$meansq[1] - result_frame$meansq[3]) / 
    ((result_frame$df[2] + 1) * n_reps)     


var_inspector <- 
  (result_frame$meansq[2] - result_frame$meansq[3]) / 
  ((result_frame$df[1] + 1) * n_reps)   

var_parts_inspector <- 
  (result_frame$meansq[3] - result_frame$meansq[4]) / 
  (n_reps)   

var_error <- result_frame$meansq[4]



var_repeatability <- var_error

var_reproducibility <- var_inspector + var_parts_inspector

var_gauge <- var_repeatability + var_reproducibility



