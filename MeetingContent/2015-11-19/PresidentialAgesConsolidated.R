library(magrittr)   #* Chained operations
library(dplyr)      #* Data Management Suite 
library(lubridate)  #* Date Operations
library(stringr)    #* String Operations
library(tidyr)      #* Reshaping Operations

library(readxl)     #* For reading excel files

#* Clean up the President's Data
#* Tasks:
#* 1. Convert Birth to a Date
#* 2. Drop Variables of no interest
#* 3. Add an index to separate consecutive from 
#*    non consecutive terms.
Presidents <- 
  read_excel("MeetingContent/2015-11-19/Presidents.xls") %>%
  
  #* 1. Convert Birth to a Date
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
  
  #* 2. Drop Variables of no interest
  select(Name, Birth, BirthOrder, PresidencyOrder) %>%
  
  #* 3. Add an index to separate consecutive from 
  #*    non consecutive terms.
  group_by(Name) %>%
  arrange(PresidencyOrder) %>%
  mutate(TermOrder = 1:n()) %>%
  ungroup() %>%
  arrange(PresidencyOrder)

#* Clean Up the Elections Data
#* 1. Make R-friendy variable names
#* 2. Drop unwanted variables
#* 3. Filter out extraneous rows
#* 4. Convert "ElectionOrder" to numeric
#* 5. Reduce ElectionYear to the four digit year
#* 6. Keep only the names of the presidents
#* 7. Remove duplicate entries
#* 8. Add Index for consecutive terms

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
  mutate(ElectionOrder = gsub("[a-z]", "", ElectionOrder),
         
         #* 5. Reduce ElectionYear to the four digit year
         ElectionYear = substr(ElectionYear, 1, 4),
         
         #* 6. Keep only the names of the presidents
         Winner = gsub("([*]|[(]).+", "", Winner),
         Winner = gsub("[^[a-z]]*$", "", 
                       Winner, perl=TRUE))

#* 7. Remove duplicate entries
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

#* 8. Add Index for consecutive terms

Elections <- 
  Elections %>%
  group_by(Winner) %>%
  arrange(ElectionYear) %>%
  mutate(ElectionNumber = 1:n()) %>%
  ungroup() %>%
  arrange(ElectionOrder)

#* 1. Join Presidents and Elections Table
#* 2. Remove Grover Cleveland's non-matched terms
#* 3. Generate an approximate date of election
#* 4. Calculate Age at election
#* 5. Remove unneeded columns

PresidentialElections <- 
  #* 1. Join Presidents and Elections Table
  left_join(Presidents, Elections, 
            by = c("Name" = "Winner")) %>%

  #* 2. Remove Grover Cleveland's non-matched terms
  filter(ElectionNumber == TermOrder | is.na(ElectionOrder)) %>%
  
  #* 3. Generate an approximate date of election
  mutate(ApproxElection = paste0(ElectionYear, 
                                 "-11-01"),
         ApproxElection = as.Date(ApproxElection),
         
         #* 4. Calculate Age at election
         AgeAtElection = difftime(ApproxElection,
                                  Birth),
         AgeAtElection = as.numeric(AgeAtElection) / 365.2425) %>%
  
  #* 5. Remove unneeded columns
  select(Name, Birth, ApproxElection, AgeAtElection)
