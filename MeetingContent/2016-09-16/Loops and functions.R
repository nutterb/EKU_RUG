# Simple for loop example

for (i in 1:5){
  print(paste("Hi! (#", i, ")"))
}

# Iterating over a character vector
for (i in c("red", "green", "blue", "purple")){
  print(paste("Hi! (", i, ")"))
}


# Calculate a sum with a loop
x <- 1:10

sum <- 0
for(i in seq_along(x)){
  sum <- sum + x[i]
  print(sum)
}
sum

# Calculate the Fibonnaci Sequence in a loop
fibb <- vector("numeric", 10)
fibb[1:2] <- c(1, 1)
for (i in 3:length(fibb)){
  fibb[i] <- fibb[i-2] + fibb[i-1]
}
fibb

# Creating a list of models using a loop
form <- list(mpg ~ wt,
             mpg ~ disp,
             mpg ~ wt + disp)

library(broom)
library(magrittr)
models <- vector('list', length(form))
for(i in seq_along(form)){
  models[[i]] <- lm(form[[i]], data = mtcars) %>% glance()
}

# Compare the models
library(dplyr)
models %>% bind_rows %>% View 


#####################################
## FUNCTIONS 
#####################################
add <- function(x, y){
  x + y
}

add(3,2)

# Function to return if values are odd or even
x <- 1:20

is_even <- function(k){
  checkmate::assertIntegerish(k)
  k %% 2 == 0
}

is_odd <- function(k){
  !is_even(k)
}

is_odd(x)

##################################
## HERE'S AN EXAMPLE FOR WHY 
## FUNCTIONS ARE SO USEFUL
##################################

library(pixiedust)

# Fit a model
fit <- lm(mpg ~ qsec + wt + am + factor(gear),
          data = mtcars)

options(pixiedust_print_method = "html")

## Format the model into a pretty table of results
dust(fit) %>%
  sprinkle(cols = "p.value",
           fn = quote(pvalString(value))) %>%
  sprinkle(cols = 2:4,
           round = 2) %>%
  sprinkle(pad = 3) %>%
  sprinkle(rows = 1,
           border = "top") %>%
  sprinkle(rows = 6,
           border = "bottom")

## Note: That was a lot of code!!
## Let's define a function to do all that work

sprinkle_my_model <- function(x){
  x %>%
    sprinkle(cols = "p.value",
             fn = quote(pvalString(value))) %>%
    sprinkle(cols = 2:4,
             round = 2) %>%
    sprinkle(pad = 3) %>%
    sprinkle(rows = 1,
             border = "top") %>%
    sprinkle(rows = 6,
             border = "bottom")
}

# Now let's format the table with our new function.
# Look how much faster that is!
dust(fit) %>% sprinkle_my_model


## Here's a function to calculate the first
## n values in the Fibonnaci Sequence

fibb <- function(n){
  # make sure that n is something like an integer
  checkmate::assertIntegerish(n)
  
  # Return 1 if we only want the first element
  if (n == 1) return(1)
  
  # Return 1, 1 if we only request the first two elements
  else if (n == 2) return(c(1, 1))
  
  # Use a loops to get from 3 to n
  else
  {
    s <- vector('numeric', n)
    s[1:2] <- c(1, 1)
    for(i in 3:n){
      s[i] <- s[i-1] + s[i-2]
    }
    return(s)
  }
}

fibb(10)




