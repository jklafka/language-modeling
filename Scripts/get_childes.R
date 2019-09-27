require(childesr)
require(dplyr)
require(here)

english <- get_utterances(collection = "Eng-NA")

english %>%
  # filter(speaker_role %in% c("Target_Child", "Child")) %>%
  filter(speaker_role %in% c("Mother", "Father", "Adult")) %>%
  select(gloss) %>%
  write.table(here("Data/childes.txt"), sep="\n", row.names=FALSE)