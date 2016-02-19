Dates
========================================================
author: EKU R User Group
date: 19 February 2016

Processing Dates
========================================================
incremental: true

How do we write dates?

How should we write dates?

Standard Date Formats
========================================================

`POSIX` Standards

https://en.wikipedia.org/wiki/POSIX

The **Portable Operating System Interface** (POSIX) is a family of standards specified by the IEEE Computer Society for maintaining compatibility between operating systems. 

What it looks like
========================================================
incremental: true

Date class:  
`2016-02-19`

Date/Time class  
`2016-02-19 14:30:00`

Random rant: "2/19/2016" is the second worst way to write a date in the world, with 
"2/9/16" being the worst.  

Functional Differences
========================================================
incremental: true

Date class: The number of **days** elapsed since 1970-01-01

Date time class: The number of **seconds** elapsed since 1970-01-01

Why the difference?

Functional Differences
========================================================
incremental: true

**How many days are in a year?**

365 (Common Year)

365.25 (Julian Year)

365.2425 (Gregorian Year)

365.24219 (Solar Year)

Functional Differences
========================================================
incremental: true

**How many seconds are in a year?**

POSIX doesn't care. There are 86,400 seconds in a day.

...Unless there are 86,401 seconds in a day.

Leap seconds are scheduled by the International Earth Rotation and Reference Systems Service and are not predictable. (https://en.wikipedia.org/wiki/Unix_time#cite_note-4)


Which Should I Use?
========================================================
incremental: true

Should I use `Date` class, or `POSIXct` class?

Honestly, it doesn't matter.

But use `POSIXct`.

...Except when you use `Date`.


Trivia: How do other software programs handle dates?
========================================================
incremental: true

SAS: Number of days since 1960-01-01

SPSS: Number of seconds since 1582-10-04

Excel: Number of days since 1900-01-01 (Except they forgot 
1900 wasn't a leap year, so really, since 1899-12-31)


Using Dates
========================================================

Three Main Tasks

1. Converting strings to dates
2. Calculating differences between dates
3. New dates referenced on other dates (When is my next birthday?)

Converting strings to dates
========================================================
incremental: true

Commit this to memory: `?strptime`

`ConvertingToDates1.R`

Now use the `lubridate` package  
`ConvertingToDates2.R`


Calculating differences between dates
========================================================

`DateCalculations.R`

Using `-`

Using `difftime`



New Dates referencing other dates
========================================================

Adding time manually

Using `lubridate` functions

* `years`
* `months`
* `days`
