require(tidyverse)
require(tidytext)
require(here)
require(glue)

source <- "adult"
corpus <- "bnc"


data.txt <- read_delim(here(glue("Data/{source}/{corpus}.txt")), 
                  delim = '\n', col_names = c("text"))

counts <- data.txt %>% 
  mutate(length = stringr::str_count(text, pattern = "[ +]+") + 1) %>%
  count(length) %>%
  mutate(m = cumsum(n) / sum(n))
  
## how many utterances for each length
counts %>%
  ggplot(aes(x = length, y = n)) +
    geom_col()

## cumulative percentage of that length or less
counts %>%
  ggplot(aes(x = length, y = m)) + 
    geom_col()
