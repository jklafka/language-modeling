require(childesr)
require(here)
library(tidyverse)

collections <- get_collections()

mandarin_corpora <- childesr::get_corpora() %>%
  filter(collection_name == "Chinese", 
         !corpus_name %in% c("HKU", "LeeWongLeung")) %>%
  pull(corpus_name)

mandarin <- map_df(mandarin_corpora, ~childesr::get_utterances(corpus = .x))

mandarin %>%
  # filter(speaker_role %in% c("Target_Child", "Child")) %>%
  filter(speaker_role %in% c("Mother", "Father", "Adult")) %>%
  select(stem) %>%
  write.table(here("Data/childes_mandarin.txt"), sep="\n", row.names=FALSE)
