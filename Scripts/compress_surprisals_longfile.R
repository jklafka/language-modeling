require(data.table)
require(tidyverse)
require(glue)
require(here)

corpus_name <- commandArgs(trailingOnly=TRUE)[1]
language_name <- commandArgs(trailingOnly=TRUE)[2]
gram <- commandArgs(trailingOnly=TRUE)[3]

NROWS <- 500000000

MIN_LENGTH <- 5
MAX_LENGTH <- 45

## center but don't scale
# scale(center = TRUE, scale = FALSE)

num_runs <- 0
last_switch <- 1

sub_surprisals <- fread(glue(
  "/Volumes/wilbur/wiki_models/ValSurprisals/{corpus_name}/{gram}/{language_name}.csv"),
  nrows = NROWS, skip = last_switch)

names(sub_surprisals) <- c("position", "surprisal", "length")

sub_surprisals <- sub_surprisals %>%
  mutate(row = 1:n()) %>%
  filter(length >= MIN_LENGTH, length <= MAX_LENGTH) %>%
  mutate(switch = position < lag(position, default = FALSE)) %>%
  mutate(switch = cumsum(switch)) 

format(last_switch,scientific = F)

last_switch <- last_switch -1 + sub_surprisals %>%
  filter(switch == max(switch)) %>%
  filter(row == min(row)) %>%
  pull(row) 

sub_surprisals <- sub_surprisals %>%
  group_by(length, position) %>%
  summarise(surprisal = mean(surprisal, na.rm = T),  n = n()) 

sub_surprisals %>%
  fwrite(here(glue("ValSurprisals/{corpus_name}/{gram}/{language_name}_compressed_batch.csv")),
            col.names=FALSE, append = TRUE)

num_runs <- num_runs + 1


batched_surprisals <- fread(
  here(glue("ValSurprisals/{corpus_name}/{gram}/{language_name}_compressed_batch.csv"))) 
names(batched_surprisals) <- c("length", "position","surprisal","n")

batched_surprisals <- batched_surprisals %>%
  group_by(length, position) %>%
  summarise(surprisal = weighted.mean(surprisal, n), n = sum(n)) %>%
  ungroup() %>%
  pivot_wider(names_from = position, values_from = surprisal) %>%
  select(-length) 

write_csv(batched_surprisals, here(glue("ValSurprisals/{corpus_name}/{gram}/{language_name}_compressed.csv")),
       col_names=FALSE)

