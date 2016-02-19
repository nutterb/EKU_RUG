#* Convert each of the following character strings to
#* a) A Date object
#* b) A POSIXct object

#* This time, use the lubridate package

library(lubridate)

ymd("2010-01-14")

mdy("December 3, 2018")

dmy_hm("15 Dec 2013 9:15 AM")

mdy("3/20/2018")

mdy("3-11-2014") #* or dmy("3-11-2014"); this date format is ambiguous

dmy_hms("17-Oct-10 16:11:32")

