require(tidyverse)
require(tidytext)
require(here)
require(glue)

source <- c("adult", "adult", "adult", "child")
corpus <- c("bnc", "sbc", "childes", "childes")

compute_lengths <- function(source, corpus) {
  
  
  data <- read_delim(here(glue("Data/{source}/{corpus}.txt")), 
                    delim = '\n', col_names = c("text"))
  
  data %>% 
    mutate(length = stringr::str_count(text, pattern = "[ +]+") + 1) %>%
    count(length) %>%
    mutate(m = cumsum(n) / sum(n)) %>%
    mutate(source = source,
           language = corpus)
}

lengths <- map2_dfr(source, corpus, compute_lengths)


#   
# ## how many utterances for each length
# counts %>%
#   ggplot(aes(x = length, y = n)) +
#     geom_col()
# 
# ## cumulative percentage of that length or less
# counts %>%
#   ggplot(aes(x = length, y = m)) + 
#     geom_col()

write_csv(lengths, here("Data/Paper/lengths.csv"))
