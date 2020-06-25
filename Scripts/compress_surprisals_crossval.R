require(tidyverse)
require(glue)
require(here)
require(rsample)

MIN_LENGTH <- 5
MAX_LENGTH <- 45

## center but don't scale
# scale(center = TRUE, scale = FALSE)

corpus_name <- commandArgs(trailingOnly=TRUE)[1]
language_name <- commandArgs(trailingOnly=TRUE)[2]
gram <- commandArgs(trailingOnly=TRUE)[3]
surprisals <- read_csv(here(glue("ValSurprisals/{corpus_name}/{gram}/{language_name}.csv")))

sentence_surprisals <- surprisals %>%
  filter(length >= MIN_LENGTH, length <= MAX_LENGTH) %>%
  mutate(switch = position < lag(position, default = FALSE)) %>%
  mutate(switch = cumsum(switch)) %>%
  group_by(length, switch, position) %>%
  summarise(surprisal = mean(surprisal, na.rm = T)) %>%
  pivot_wider(names_from = position, values_from = surprisal) %>%
  ungroup() %>%
  select(-switch) %>%
  vfold_cv(v = 10)
 
training_surprisals <- sentence_surprisals %>%
  mutate(surprisals = map(splits, ~ .x %>% 
                            analysis %>% 
                            group_by(length) %>%
                            mutate(n = n()) %>%
                            group_by(length, n) %>%
                            summarise_at(vars(-group_cols()), mean) %>%
                            ungroup() %>%
                            select(-length))) %>%
  select(surprisals) 

test_surprisals <- sentence_surprisals %>%
  mutate(surprisals = map(splits, ~ .x %>% 
                            assessment %>% 
                            group_by(length) %>%
                            mutate(n = n()) %>%
                            group_by(length, n) %>%
                            summarise_at(vars(-group_cols()), mean) %>%
                            ungroup() %>%
                            select(-length))) %>%
  select(surprisals) 
  
walk2(training_surprisals$surprisals, 1:nrow(training_surprisals), 
      ~ write_csv(.x, 
                    here(glue("ValSurprisals/{corpus_name}/{gram}/{language_name}_training{.y}.csv")),
                                                                col_names = FALSE))

walk2(test_surprisals$surprisals, 1:nrow(test_surprisals), 
      ~ write_csv(.x, 
                  here(glue("ValSurprisals/{corpus_name}/{gram}/{language_name}_test{.y}.csv")),
                  col_names = FALSE))

      