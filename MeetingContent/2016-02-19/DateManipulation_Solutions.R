#' Calculate your 10th, 20th, and 30th birthday


#* One approach is just to simply add the number of days onto a Date object
birth <- as.Date("1980-06-25")

birth + 365.2425 * 10
birth + 365.2425 * 20
birth + 365.2425 * 30

#* But notice that the 20th birthday is off by a day
#* (If we use 365.25, we do get the correct date)
#* The lesson being that trying to add days to a Date object can be 
#* risky.

#* Instead, let's use a POSIXct object with the lubridate package

library(lubridate)
birth <- ymd("1980-06-25")

birth + years(10)
birth + years(20)
birth + years(30)


#* Find the date of your next pi birthday
#* Since the 'years' function only accepts integers, we'll have to 
#* use the riskier way.  But pi isn't exactly a precise 
#* measure of time, so we'll probably be able to live with a 
#* little inaccuracy.
#* We'll use a date object here so we can use days instead of seconds
birth <- as.Date("1980-06-25")

pi_birthday <- birth + 365.25 * pi * 1:100

pi_birthday <- pi_birthday[pi_birthday >= Sys.Date()]

pi_birthday[1]
