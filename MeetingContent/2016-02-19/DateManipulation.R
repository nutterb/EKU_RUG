#* Calculate your 10th, 20th, and 30th birthday


birth <- # Create a Date object here


#* Now, let's use a POSIXct object with the lubridate package

library(lubridate)
birth <- # Create a POSIXct object here (hint: ymd())


#* Find the date of your next pi birthday
#* Since the 'years' function only accepts integers, we'll have to 
#* use the riskier way.  But pi isn't exactly a precise 
#* measure of time, so we'll probably be able to live with a 
#* little inaccuracy.
#* We'll use a date object here so we can use days instead of seconds
  
birth <-  #* Create a date object here
  
#* To calculate the pi birthdays, add 365.25 * pi * x for the xth pi birthday
