library(dplyr)
library(magrittr)
library(survival)
library(broom)
library(ggplot2)
library(zoo)
library(lazyWeave)
library(devtools)

data(Scout)

#* Exercise 1: Calculate your age as of today

Sys.Date()

Sys.time()

#* This dataset represents 105 midwestern Boy Scouts and their advancement through
#* the boy scout program.  

#* Variables
#* date.birth: The boy's birth date
#* date.grad: The day the boy exited the Boy Scout program. 
#*            For boys who earned the rank of Eagle, this is the date they 
#*            earned the rank, otherwise, it is the day of their 18th birthday
#*            (You'll notice the birthdays aren't quite right. I tried to 
#*             make this dataset before I knew some of the things I know now)
#* date.[rank]: The date at which a particular rank was earned.

#* Can you recalculate the time to earning each rank and verify the data in the 
#* data set (essentially, did I do it right?)
#* Since we don't have the exact date the scouts joined, we'll use the date they
#* earned their first rank as the baseline date.

#* 1. How long did it take each boy to earn First Class?

Scout$date.scout
Scout$date.first


#* 2. How long did it take each boy to earn Eagle

Scout$date.scout
Scout$date.eagle


#* 3. Bonus exercise: It is claimed by the Boy Scouts of America that boys
#*    who earn first class within one year of joining scouts are 
#*    more likely to earn the rank of Eagle than those who earn first class
#*    more than one year after joining.  Do these data support that claim?

Scout %<>%
  mutate(time.to.first = difftime(),                  # Complete this line
         first.year = ,                               # Complete this line
         time.to.eagle = difftime(),                  # Complete this line
         time.to.eagle = ifelse(is.na(time.to.eagle),
                                difftime(),           # Complete this line
                                time.to.eagle),
         eagle = !is.na(date.eagle)
  ) %>%
  filter(!is.na(time.to.first) & !is.na(birth.date))


#* Chi-square test
chisq.test(table(Scout$first.year, Scout$eagle))

#* Logistic Regression
fit.glm <- glm(eagle ~ first.year, data = Scout, family=binomial)
tidy(fit.glm, exponentiate = TRUE)

#* Cox Regression
fit.cox <- coxph(Surv(as.numeric(time.to.eagle), eagle) ~ first.year, data = Scout)
tidy(fit.cox, exponentiate = TRUE)

#* Kaplan-Meier Plot
fit.km <- survfit(Surv(as.numeric(time.to.eagle), eagle) ~ first.year, data = Scout)
plot(fit.km)

#* I really dislike the default plot for Kaplan-Meier curves, so I use my own.
devtools::source_gist("https://gist.github.com/nutterb/004ade595ec6932a0c29")

ggSurvGraph(fit.km, cum.inc = TRUE, conf.bar = FALSE,
            gg_expr=list(geom_rect(aes(xmin=time, xmax=next.time,
                                       ymin=lower, ymax=upper,
                                       fill=strata),
                                   alpha=.25, linetype=0)))
