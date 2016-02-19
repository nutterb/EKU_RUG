#* Convert each of the following character strings to
#* a) A Date object
#* b) A POSIXct object

#* To get Date objects, use as.Date instead of as.POSIXct

as.POSIXct("2010-01-14", format = "%Y-%m-%d")

as.POSIXct("December 3, 2018", format = "%B %d, %Y")

as.POSIXct("15 Dec 2013 9:15 AM", format = "%d %b %Y %H:%M %p")

as.POSIXct("3/20/2018", format = "%m/%d/%Y")

as.POSIXct("3-11-2014", format = "%d-%m-%Y")
#* or as.POSIXct("3-11-2014", format = "%m-%d-%Y"); this format is ambiguous

as.POSIXct("17-Oct-10 16:11:32", format = "%d-%b-%y %H:%M:%S")

