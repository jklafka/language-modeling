require(childesr)
require(dplyr)
require(here)

language = commandArgs(trailingOnly=TRUE)[1]
column_to_use = commandArgs(trailingOnly=TRUE)[2]

corpora <- get_utterances(collection = language)

corpora %>%
  # filter(speaker_role %in% c("Target_Child", "Child")) %>%
  filter(speaker_role %in% c("Mother", "Father", "Adult")) %>%
  select(column_to_use) %>%
  write.table(here(paste0("Data/childes_", language, ".txt")), sep="\n", row.names=FALSE)
