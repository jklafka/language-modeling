library(tidyverse)

read_unigram_model <- function(file) {
  read_lines(file, skip = 7) %>%
    enframe(name = NULL, value = "line") %>%
    slice(1:(n()-2)) %>%
    separate(line, into = c("surprisal", "word"), sep = "\t") %>%
    mutate(surprisal = as.numeric(surprisal))
}

get_surprisal <- function(model, unigram){
  model %>%
    filter(word == unigram) %>%
    pull(surprisal)
}
