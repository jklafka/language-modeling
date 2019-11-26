# first build the ngram counts
# ngram-count -text brown.txt -lm -kndiscount brown.lm 

# then do word-by-word prediction
# ngram -lm brown.lm -ppl brown.txt -debug 2 > brown.ppl

# then set PPL to the file you want and run!

PPL <- "childes_kenlm.ppl"

ppl <- read_lines(PPL) %>%
  enframe(name = NULL) %>%
  mutate(break_line = as.numeric(value == "")) %>%
  mutate(gram = cumsum(break_line)) %>%
  select(-break_line) 
  
surprisals <- ppl %>%  
  filter(str_detect(value, "\tp")) %>%
  mutate(value = gsub(".*\\[", "", value),
         value = gsub(" \\]", "", value) %>% as.numeric()) %>%
  group_by(gram) %>%
  mutate(position = 1:n(),
         length = n() - 1) %>%
  filter(position <= length)

mean_surprisals <- surprisals %>%
  group_by(length, position) %>%
  mutate(n = n()) %>%
  summarise(mean = mean(-value), se = sd(-value)/sqrt(mean(n)))

require(here)
require(tidyverse)
surprisals <- read_csv(here("Data/wikipedia_char_chinese.csv"))

mean_surprisals <- surprisals %>%
  slice(1:1000000) %>% 
  group_by(length, position) %>%
  mutate(n = n()) %>%
  summarise(mean = mean(surprisal), se = sd(surprisal)/sqrt(mean(n)))
                       
mean_surprisals %>%
  filter(length %in% c(1, 3, 5, 7, 9)) %>%
  ggplot(aes(x = position, y = mean, color = as.factor(length))) + 
    geom_pointrange(aes(ymin = mean - 1.96 * se, ymax = mean + 1.96 * se)) +
    geom_line() + 
    # facet_wrap(~length) + 
    theme_classic()

