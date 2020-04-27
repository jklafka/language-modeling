require(tidyverse)
require(glue)
require(data.table)
require(here)
require(rsample)

MIN_LENGTH <- 5
MAX_LENGTH <- 15

## center but don't scale
# scale(center = TRUE, scale = FALSE)

corpus_name <- commandArgs(trailingOnly=TRUE)[1]
language_name <- commandArgs(trailingOnly=TRUE)[2]
gram <- commandArgs(trailingOnly=TRUE)[3]
surprisals <- fread(here(glue("Surprisals/{corpus_name}/{gram}/{language_name}.csv"))) %>%
  as_tibble()

surprisals %>%
  filter(length >= MIN_LENGTH, length <= MAX_LENGTH, complete.cases(.)) %>%
  mutate(switch = position < lag(position)) %>%
  mutate(switch = if_else(is.na(switch), FALSE, switch)) %>%
  mutate(switch = cumsum(switch)) %>%
  group_by(length, position, switch) %>% # get ids for each sentence
  summarise(surprisal = mean(surprisal, na.rm = T)) %>%
  bootstraps(., times = 1000) %>%
  mutate(data = map(splits, ~.x %>% analysis %>% 
                      summarise(surprisal = mean(surprisal, na.rm = T)))) %>%
  select(-splits) %>%
  unnest(cols = c(data)) %>%
  ungroup() %>%
  pivot_wider(names_from = position, values_from = surprisal) %>%
  select(-length) %>%
  mutate(id = as.numeric(as.factor(id))) %>%
  mutate(id = as.numeric(as.factor(id))) %>%
  fwrite(here(glue("Surprisals/{corpus_name}/{gram}/{language_name}_compressed.csv")),
            col.names=FALSE)
