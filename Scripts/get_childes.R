require(childesr)
require(dplyr)
require(here)

language = commandArgs(trailingOnly=TRUE)[1]
# column_to_use = commandArgs(trailingOnly=TRUE)[2]
# speaker = commandArgs(trailingOnly=TRUE)[3]

# if (speaker == "child") {
#   speaker_roles <- c("Target_Child", "Child")
# } else {
#   speaker_roles <- c("Mother", "Father", "Adult")
# }

corpora <- get_utterances(collection = language)

corpora %>%
  filter(speaker_role %in% c("Target_Child", "Child")) %>%
  select(stem) %>%
  write.table(here(paste0("Data/child/", language, ".txt")),
              sep="\n", row.names=FALSE)

corpora %>%
  filter(speaker_role %in% c("Mother", "Father", "Adult")) %>%
  select(stem) %>%
  write.table(here(paste0("Data/adult/", language, ".txt")),
              sep="\n", row.names=FALSE)

# corpora %>%
#   filter(speaker_role %in% speaker_roles) %>%
#   select(column_to_use) %>%
#   write.table(here(paste0("Data/childes_", language, '_', speaker, ".txt")),
#               sep="\n", row.names=FALSE, col.names=FALSE)
