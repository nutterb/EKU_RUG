library(dplyr)
library(stringr)

Salaries <- 
  read.csv("MeetingContent/2015-11-19/Salaries__OUS__Oregon_State_University__FY_2014.csv",
           stringsAsFactors = FALSE) %>%
  setNames(tolower(names(.))) %>%
  rename(agency = agency..) %>%
  mutate(annual.salary = str_replace_all(string = annual.salary,
                                         pattern = "([$]|,)",
                                         replace = ""),
         annual.salary = as.numeric(annual.salary))

Salaries %>%
  group_by(full.part.time) %>%
  summarise(n = n(),
            mean = mean(annual.salary),
            median = median(annual.salary),
            sd = sd(annual.salary),
            min = min(annual.salary),
            max = max(annual.salary))

table(Salaries$service.type)


Salaries %>%
  group_by(full.part.time, service.type) %>%
  summarise(n = n(),
            mean = mean(annual.salary),
            median = median(annual.salary),
            sd = sd(annual.salary),
            min = min(annual.salary),
            max = max(annual.salary))



Salaries %>%
  filter(str_detect(string = classification,
                    pattern = "Professor")) %>%
  mutate(classification = str_replace(string = classification,
                                      pattern = "( [(].+$|[(].+$)",
                                      replacement = "")) %>%
  group_by(full.part.time, classification) %>%
  summarise(n = n(),
            mean = mean(annual.salary),
            median = median(annual.salary),
            sd = sd(annual.salary),
            min = min(annual.salary),
            max = max(annual.salary)) %>%
  ungroup() %>%
  filter(n > 10)



Salaries %>%
  filter(service.type == "Executive/Admin and managerial") %>%
  mutate(executive = ifelse(str_detect(string = classification,
                                       pattern = "(E|e)xecutive"),
                            "Executive", 
                            "Administrative")) %>%
  group_by(executive) %>%
  summarise(n = n(),
            mean = mean(annual.salary),
            median = median(annual.salary),
            sd = sd(annual.salary),
            min = min(annual.salary),
            max = max(annual.salary)) %>%
  ungroup()
