gaugeRR <- function(fit, nrep)
{
  require(dplyr)
  require(tidyr)
  require(broom)
  
  #* A vectorized form of `grepl`
  #* Returns TRUE when any of the patterns are found in `x`
  Vgrepl <- function(pattern, x)
  {
    local_grepl <- 
      Vectorize(FUN = grepl,
                vectorize.args = c("pattern")) 
    apply(X = local_grepl(pattern = pattern, 
                     x = x),
          MARGIN = 1,
          FUN = any)
  }
  
  #* A double vectorized for of `grepl`
  #* it returns a value for each pairwise check of pattern and x
  VVgrepl <- function(pattern, x)
  {
    local_grepl <- 
      Vectorize(FUN = grepl,
                vectorize.args = c("pattern", "x"))
    local_grepl(pattern, x)
  }
    
  mse <- tail(anova(fit)[, 3], 1)
  
  tidy_fit <- tidy(anova(fit))
  
  
  attributes(terms(fit))[["factors"]][-1, ] %>%
    as.data.frame() %>%
    mutate(
      variable = rownames(.)) %>%
    gather(term, in_model, -variable) %>%
    mutate(
      order = 1:n(), 
      interaction = grepl(":", term),
      subtract_from_main = VVgrepl(variable, term) & interaction
    ) %>%
    group_by(variable, term) %>%
    mutate(
      in_denom = !grepl(variable, term)
    ) %>%
    ungroup() %>%
    group_by(variable) %>%
    mutate(
      in_interaction = Vgrepl(pattern = term, 
                              x = term)
    ) %>%
    ungroup() %>%
    mutate(
      in_denom = in_denom & in_interaction
    ) %>%
    select(-in_interaction) %>%
    left_join(
      .,
      tidy_fit[, c("term", "meansq", "df")],
      by = c("term" = "term")
    ) %>%
    mutate(
      subtract_from_main = meansq * subtract_from_main,
      in_denom = ifelse(test = in_denom, 
                        yes = df + 1,
                        no = 1)
    ) %>%
    group_by(variable) %>%
    mutate(
      subtract_from_main = ifelse(variable == term, 
                                  sum(subtract_from_main),
                                  0),
      in_denom = ifelse(variable == term | grepl(":", term), 
                        1, 
                        prod(in_denom))
    ) %>%
    ungroup() %>%
    group_by(term) %>%
    mutate(
      subtract_from_main = ifelse(grepl(":", term),
                                  subtract_from_main + (mse / n()),
                                  subtract_from_main)
    ) %>%
    ungroup() %>%
    mutate(
      variable = ifelse(grepl(":", term),
                        term,
                        variable)
    ) %>%
    group_by(variable) %>%
    arrange(variable) %>%
    select(variable, subtract_from_main, in_denom) %>%
    left_join(
      .,
      tidy_fit,
      by = c("variable" = "term")
    ) %>%
    summarise(
      var = (meansq[1] - sum(subtract_from_main)) / (prod(in_denom) * nrep)
    )
 
}