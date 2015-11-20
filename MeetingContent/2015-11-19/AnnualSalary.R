library(dplyr)
library(tidyr)

Salaries <- 
  read.csv(file.path("MeetingContent/2015-11-19",
                     "Annual_Salary_2010_thru_2013.csv"),
           stringsAsFactors = FALSE,
           nrows = 10000) 

Salaries <- 
  Salaries %>%
  gather(Year, Salary, 
         Salary2010, Salary2011, Salary2012, Salary2013) %>%
  group_by(EmployeeName, Year) %>%
  summarise(Salary = sum(Salary)) %>%
  ungroup()

TotalSalaries <- 
  Salaries %>%
  spread(Year, Salary)
  