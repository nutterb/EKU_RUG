library(dplyr)
library(ggplot2)
library(lubridate)

Shootings <- 
  read.csv("MeetingContent/2015-11-19/Non-Fatal_Shootings_-_2013.csv",
           stringsAsFactors = FALSE) %>%
  mutate(Date = as.Date(Date, format = "%m/%d/%Y"),
         Month = month(Date),
         SelfInflicted = ifelse(str_detect(Type, "self"),
                                "Self Inflicted",
                                "Non Self Inflicted"))

Shootings %>%
  summarise(n_shootings = n())

Shootings %>%
  group_by(SelfInflicted) %>%
  summarise(n_shootings = n())

Shootings %>%
  group_by(Month) %>%
  summarise(n_shootings = n())

Shootings %>%
  group_by(County) %>%
  summarise(n_shootings = n())


Shootings %>%
  group_by(Month, SelfInflicted) %>%
  summarise(n_shootings = n())


ShootingsCountyMonth <- 
  Shootings %>%
  group_by(County, Month, SelfInflicted) %>%
  summarise(n_shootings = n())

ggplot(ShootingsCountyMonth,
       aes(x = Month, 
           y = n_shootings,
           colour = County)) + 
  geom_line() + 
  facet_grid(SelfInflicted ~ .)


