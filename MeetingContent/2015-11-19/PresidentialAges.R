library(magrittr)   #* Chained operations
library(dplyr)      #* Data Management Suite 
library(lubridate)  #* Date Operations
library(stringr)    #* String Operations
library(tidyr)      #* Reshaping Operations

library(readxl)     #* For reading excel files

#* More disclaimers:
#* I will rely heavily on the `dplyr` package's aprroach
#* to data management.  `dplyr` has the advantage of being
#* (in my opinion) easier to read and faster than the 
#* base R operations.
#*
#* There is another package called `data.table` that is
#* a bit faster than `dplyr` (although that gap is getting
#* smaller), but has the added benefit of using very 
#* dense code.  The reason I don't use it is two-fold
#* 1) My personal opinion is that the dense code is 
#*    insufferable to read.
#* 2) If I struggle to read it, none of the C# programmers
#*    who review my code will be able to understand it
#*
#* But in the end, my aversion to `data.table` is strictly
#* a matter of preference.  If you want faster code and
#* are strongly motivated to write as little code as 
#* possible, I recommend you learn `data.table` syntax
#* as early as you can.

#********************************************************
#********************************************************

#* Goal: Calculate the age at which each US president was
#*       elected to the presidency

Presidents <- 
  read_excel("MeetingContent/2015-11-19/Presidents.xls")

Elections <- 
  read_excel("MeetingContent/2015-11-19/Presidents.xls",
             sheet = 2)


#* Clean up the President's Data
#* Tasks:
#* 1. Convert Birth to a Date
#* 2. Drop Variables of no interest

Presidents <- 
  Presidents %>%
  mutate(Birth = mdy(Birth))

#* Why the warning?  Check out the date formats
#* Solution: make a grouping for the date formats
#*    More about parsing dates can be found at
#*    ?stptime

Presidents <- 
  read_excel("MeetingContent/2015-11-19/Presidents.xls") %>%
  
  #* Convert the birth date
  mutate(date_group = ifelse(!is.na(as.numeric(Birth)),
                             "numericDate",
                             "characterDate")) %>%
  group_by(date_group) %>%
  mutate(Birth = ifelse(date_group == "numericDate",
                        as.Date(as.numeric(Birth), 
                                origin = "1899-12-30"),
                        as.Date(Birth,
                                format = "%B %d, %Y"))) %>%
  ungroup() %>%
  mutate(Birth = as.Date(Birth, origin = origin)) %>%
  
  #* Drop unwanted variables
  select(Name, Birth, BirthOrder, PresidencyOrder)


#* Clean Up the Elections Data
#* 1. Make R-friendy variable names
#* 2. Drop unwanted variables
#* 3. Filter out extraneous rows
#* 4. Convert "ElectionOrder" to numeric
#* 5. Reduce ElectionYear to the four digit year
#* 6. Keep only the names of the presidents
#* 7. Remove duplicate entries

Elections <- 
  read_excel("MeetingContent/2015-11-19/Presidents.xls",
             sheet = 2) %>%
  
  #* 1. Make R-friendy variable names
  setNames(c("ElectionOrder", "ElectionYear", "Winner", 
             "OtherCandidates")) %>%
  
  #* 2. Drop unwanted variables
  select(ElectionOrder, ElectionYear, Winner) %>%
  
  #* 3. Filter out extraneous rows
  filter(!is.na(ElectionOrder)) %>%
  
  #* 4. Convert "ElectionOrder" to numeric
  mutate(ElectionOrder = gsub("[a-z]", "", ElectionOrder)) %>%
  
  #* 5. Reduce ElectionYear to the four digit year
  mutate(ElectionYear = substr(ElectionYear, 1, 4)) %>%
  
  #* 6. Keep only the names of the presidents
  mutate(Winner = gsub(pattern = "([*]|[(]).+", 
                       replacement = "", 
                       x = Winner),
         Winner = gsub(pattern = "[^[a-z]]*$", 
                       replacement = "", 
                       x = Winner, 
                       perl=TRUE))

#* 7. Remove duplicate entries
#*    We have to be careful here, however.  
#*    Grover Cleveland was elected twice, but he's
#*    the only president that non-consecutive 
#*    terms as president, so his presidencies are 
#*    commonly treated as two separate administrations.
#*    In the loop below, we define a sequential presidency
#*    as one where a the elected president prior to the
#*    current president is the same as the current 
#*    president.
Elections$SequentialTerm <- rep(NA, nrow(Elections))
for(i in 1:nrow(Elections)){
  if (i == 1){
    Elections$SequentialTerm[i] <- 0
  }
  else{
    if (Elections$Winner[i] == Elections$Winner[i-1]){
      Elections$SequentialTerm[i] <- 1 
    }
    else{
      Elections$SequentialTerm[i] <- 0
    }
  }
}

#* Now we can filter out all of the sequential presidencies
#* leaving us with the first term each president was 
#* elected, plus President Cleveland's second term.
Elections <- 
  filter(Elections, SequentialTerm == 0) %>%
  select(-SequentialTerm)

#* Now let's add an index the separates Cleveland's 
#* first term from his second.

Elections <- 
  Elections %>%
  group_by(Winner) %>%
  arrange(ElectionYear) %>%
  mutate(ElectionNumber = 1:n()) %>%
  ungroup() %>%
  arrange(ElectionOrder)


#* Now let's join the two tables
PresidentialElections <-   
  left_join(Presidents, Elections, 
            by = c("Name" = "Winner"))


#* Uh oh! There are 46 entries in this table.
#* What went wrong?
#* We didn't have a matching presidency index in the
#* Presidents table.  Let's add one now.

Presidents <- 
  Presidents %>%
  group_by(Name) %>%
  arrange(PresidencyOrder) %>%
  mutate(TermOrder = 1:n()) %>%
  ungroup() %>%
  arrange(PresidencyOrder)

PresidentialElections <-   
  left_join(Presidents, Elections, 
            by = c("Name" = "Winner")) %>%
  filter(ElectionNumber == TermOrder | is.na(ElectionOrder))

#* At last, we can now calculate the age at which
#* each president was elected.

PresidentialElections <- 
  PresidentialElections %>%
  mutate(ApproxElection = paste0(ElectionYear, 
                                 "-11-01"),
         ApproxElection = as.Date(ApproxElection),
         AgeAtElection = difftime(time1 = ApproxElection,
                                  time2 = Birth,
                                  units = "days"),
         AgeAtElection = as.numeric(AgeAtElection) / 365.2425) %>%
  select(Name, Birth, ApproxElection, AgeAtElection)


