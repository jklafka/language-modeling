options(warn=-1)
options(message())

require(tidyverse)
require(tidytext)
require(glue)
require(here)

corpus_name = commandArgs(trailingOnly=TRUE)[1]
language_name = commandArgs(trailingOnly=TRUE)[2]
model_file <- here(glue("Models/{corpus_name}/unigram/{language_name}.lm"))
corpus_file <- here(glue("Data/{corpus_name}/{language_name}.txt"))


read_unigram_model <- function(file) {
  read_lines(file, skip = 7) %>%
    enframe(name = NULL, value = "line") %>%
    slice(1:(n()-2)) %>%
    separate(line, into = c("surprisal", "word"), sep = "\t") %>%
    mutate(surprisal = -as.numeric(surprisal))
}

read_corpus <- function(file) {
  read_lines(corpus_file) %>%
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
corpus <- read_corpus(corpus_file)

surprisals <- corpus %>%
  left_join(model, by = c("word")) %>%
  select(-word)

write_csv(surprisals, here(glue("Surprisals/{corpus_name}/unigram/{language_name}.csv")))
