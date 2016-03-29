# U.S. Department of Health and Human Services
# Office for Civil Rights
# Breach Portal: Notice to the Secretary of HHS Breach of Unsecured Protected Health Information
#* https://ocrportal.hhs.gov/ocr/breach/breach_report.jsf

if (!"ggplot2" %in% installed.packages()) install.packages("ggplot2")
if (!"dplyr" %in% installed.packages()) install.packages("dplyr")
if (!"Lahman" %in% installed.packages()) install.packages("Lahman")

library(dplyr)
library(ggplot2)
library(Lahman)

Breach <- read.csv("MeetingContent/2016-04-15/breach_report.csv",
                   stringsAsFactors = FALSE) %>%
  mutate(Breach.Submission.Date = as.Date(Breach.Submission.Date,
                                          format = "%m/%d/%Y"),
         Year = format(Breach.Submission.Date, 
                       format = "%Y")) %>%
  filter(Individuals.Affected < 10000)

head(Breach)


(plot <- 
  ggplot(data = Breach,
         mapping = aes(x = State,
                       y = Individuals.Affected)) )



(plot <- plot + 
  geom_boxplot() )
  
  
(plot <- plot + 
  scale_y_continuous(limits = c(0, 500000)))



#* Annual breaches

ggplot(data = Breach,
       mapping = aes(x = Year)) + 
  geom_bar()


ggplot(data = Breach,
       mapping = aes(x = Year,
                     fill = State)) + 
  geom_bar()

ggplot(data = Breach,
       mapping = aes(x = Year,
                     y = Individuals.Affected)) + 
  geom_boxplot()


ggplot(data = Breach,
       mapping = aes(x = Year,
                     y = Individuals.Affected)) + 
  geom_boxplot() + 
  geom_point()


ggplot(data = Breach,
       mapping = aes(x = Year,
                     y = Individuals.Affected)) + 
  geom_boxplot() + 
  geom_jitter()




data(Salaries)

SubSalary <- filter(Salaries, 
                    teamID %in% c("ATL", "CLE", "SEA", "BOS") & 
                      yearID >= 2005)
  
ggplot(data = SubSalary, 
       aes(x = teamID,
            y = salary)) + 
  geom_boxplot()



ggplot(data = SubSalary,
       aes(x = teamID,
           y = salary,
           colour = factor(yearID))) + 
  geom_boxplot()


ggplot(data = SubSalary,
       aes(x = teamID,
           y = salary,
           colour = factor(yearID))) + 
  geom_boxplot() + 
  facet_grid(~ yearID)

ggplot(data = SubSalary,
       aes(x = teamID,
           y = salary,
           colour = factor(yearID))) + 
  geom_boxplot() + 
  facet_grid(~ teamID)


ggplot(data = SubSalary,
       aes(x = teamID,
           y = salary,
           colour = factor(yearID))) + 
  geom_boxplot() + 
  facet_grid(~ teamID, scales = "free_x")




Boston <- filter(Salaries, teamID == "BOS")

ggplot(data = Boston,
       mapping = aes(x = yearID,
                     y = salary)) + 
  geom_point()



ggplot(data = Boston,
       mapping = aes(x = yearID,
                     y = salary)) + 
  geom_point(alpha = .5) + 
  geom_line(stat = "smooth", 
            method = "lm") 

ggplot(data = Boston,
       mapping = aes(x = yearID,
                     y = salary)) + 
  geom_point(alpha = .5) + 
  geom_line(stat = "smooth",
            method = "loess") 
       



#Examples from https://gist.github.com/nutterb/fb19644cc18c4e64d12a
#* ggSurvGraph source code at: https://gist.github.com/nutterb/004ade595ec6932a0c29

source("https://gist.githubusercontent.com/nutterb/004ade595ec6932a0c29/raw/f5a94793ab2793c64e96dbd6ccfdd4e6e9ec3823/ggSurvGraph.R")
library(ggplot2)
library(survival)
install.packages("KMsurv")
data(kidney, package="KMsurv")

fit <- survfit(Surv(time, delta) ~ type, data=kidney)

plot(fit)

ggSurvGraph(fit)

ggSurvGraph(fit, conf.bar=FALSE)

ggSurvGraph(fit, conf.bar=FALSE,
            gg_expr=list(geom_rect(aes(xmin=time, xmax=next.time,
                                       ymin=lower, ymax=upper,
                                       fill=strata),
                                   alpha=.25, linetype=0)))

ggSurvGraph(fit, conf.bar=FALSE,
            n.risk=TRUE, n.event=TRUE,
            gg_expr=list(geom_rect(aes(xmin=time, xmax=next.time,
                                       ymin=lower, ymax=upper,
                                       fill=strata),
                                   alpha=.25, linetype=0)))

ggSurvGraph(fit, conf.bar=FALSE, times=seq(0, 30, by=6),
            n.risk=TRUE, n.event=TRUE,
            gg_expr=list(geom_rect(aes(xmin=time, xmax=next.time,
                                       ymin=lower, ymax=upper,
                                       fill=strata),
                                   alpha=.25, linetype=0)))

ggSurvGraph(fit, conf.bar=FALSE, times=seq(0, 30, by=6),
            n.risk=TRUE, n.event=TRUE, cum.inc=TRUE,
            gg_expr=list(geom_rect(aes(xmin=time, xmax=next.time,
                                       ymin=lower, ymax=upper,
                                       fill=strata),
                                   alpha=.25, linetype=0)))



ggSurvGraph(fit, conf.bar=FALSE, times=seq(0, 30, by=6),
            n.risk=TRUE, n.event=TRUE,
            gg_expr=list(geom_rect(aes(xmin=time, xmax=next.time,
                                       ymin=lower, ymax=upper,
                                       fill=strata),
                                   alpha=.25, linetype=0))) 