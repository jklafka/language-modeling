options(warn=-1)
options(message())

require(tidyverse)
require(tidytext)
require(glue)
require(here)

corpus_name <- commandArgs(trailingOnly=TRUE)[1]
language_name <- commandArgs(trailingOnly=TRUE)[2]
suffix <- commandArgs(trailingOnly=TRUE)[3]
model_file <- here(glue("Models/{corpus_name}/unigram/{language_name}/{suffix}.lm"))
test_file <- here(glue("Data/{corpus_name}/{language_name}/{suffix}"))

read_unigram_model <- function(file) {
  read_lines(file, skip = 2) %>%
    enframe(name = NULL, value = "line") %>%
    slice(1:(n()-2)) %>%
    separate(line, into = c("surprisal", "word", "noise"), sep = "\t") %>%
    select(-noise) %>%
    mutate(surprisal = -as.numeric(surprisal))
}

read_corpus <- function(file) {
  read_lines(file) %>%
    enframe(name = NULL, value = "text") %>%
    mutate(length = str_count(text, pattern = "[ +]+") + 1) %>%
    mutate(utterance_id = 1:n()) %>%
    unnest_tokens(word, text, token = stringr::str_split, pattern = "[ +]+",
                  to_lower = FALSE) %>%
    group_by(utterance_id) %>%
    mutate(position = 1:n()) %>%
    ungroup() %>%
    select(-utterance_id)
}

model <- read_unigram_model(model_file)
corpus <- read_corpus(test_file)

surprisals <- corpus %>%
  left_join(model, by = c("word")) %>%
  select(-word)

outfile <- here(glue("ValSurprisals/{corpus_name}/unigram/{language_name}.csv"))
# write_csv(surprisals, here(glue("ValSurprisals/{corpus_name}/unigram/{language_name}.csv")))
write.table(surprisals %>% arrange(position, surprisal, length), outfile, sep = ",",
            col.names = !file.exists(outfile),
            row.names = F,
            append = T)
