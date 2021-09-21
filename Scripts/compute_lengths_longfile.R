require(data.table)
require(tidyverse)
require(glue)
require(here)

corpus_name <- commandArgs(trailingOnly=TRUE)[1]
language_name <- commandArgs(trailingOnly=TRUE)[2]
gram <- commandArgs(trailingOnly=TRUE)[3]

NROWS <- 500000000


num_runs <- 0
last_switch <- 1

sub_surprisals <- fread(glue(
  "/Volumes/wilbur/wiki_models/ValSurprisals/{corpus_name}/{gram}/{language_name}.csv"),
  nrows = NROWS, skip = last_switch)

names(sub_surprisals) <- c("position", "surprisal", "length")

sub_surprisals <- sub_surprisals %>%
  filter(position == 1) %>%
  count(length)

format(last_switch,scientific = F)

last_switch <- last_switch -1 + NROWS

sub_surprisals %>%
  fwrite(here(glue("Data/mdpi_paper/{language_name}_batched_lengths.csv")),
         col.names=FALSE, append = TRUE)

num_runs <- num_runs + 1


batched_lengths <- fread(
  here(glue("Data/mdpi_paper/{language_name}_batched_lengths.csv"))) 
names(batched_lengths) <- c("length", "n")

batched_lengths <- batched_lengths %>%
  group_by(length) %>%
  summarise(n = sum(n))

write_csv(batched_lengths, here(glue("Data/mdpi_paper/{language_name}_lengths.csv")),
          col_names=FALSE)

