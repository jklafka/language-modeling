require(tidyverse)
require(glue)
require(here)

MIN_LENGTH <- 5
MAX_LENGTH <- 45

## center but don't scale
# scale(center = TRUE, scale = FALSE)

corpus_name <- commandArgs(trailingOnly=TRUE)[1]
language_name <- commandArgs(trailingOnly=TRUE)[2]
gram <- commandArgs(trailingOnly=TRUE)[3]
surprisals <- read_csv(here(glue("Surprisals/{corpus_name}/{gram}/{language_name}.csv")))

surprisals %>%
  filter(length >= 5, length <= 45, complete.cases(.)) %>%
  mutate(switch = position < lag(position)) %>%
  mutate(switch = if_else(is.na(switch), FALSE, switch)) %>%
  mutate(switch = cumsum(switch)) %>%
  group_by(length, position, switch) %>% # get ids for each sentence
  summarise(surprisal = mean(surprisal, na.rm = T)) %>%
  summarise(surprisal = mean(surprisal, na.rm = T)) %>%
  ungroup() %>%
  pivot_wider(names_from = position, values_from = surprisal) %>%
  select(-length) %>%
  write_csv(here(glue("Surprisals/{corpus_name}/{gram}/{language_name}_compressed.csv")),
            col_names=FALSE)
