library(tidyverse)
library(dtwclust)
library(here)

switchboard <- read_csv(here("data/surprisals/unigram/switchboard.csv"))


nested <- switchboard %>%
  filter(length > 5, length < 30) %>%
  mutate(switch = position < lag(position)) %>%
  mutate(switch = if_else(is.na(switch), FALSE, switch)) %>%
  mutate(switch = cumsum(switch)) %>%
  group_by(length, position, switch) %>%
  summarise(surprisal = mean(surprisal, na.rm = T)) %>%
  summarise(surprisal = mean(surprisal, na.rm = T)) %>%
  select(-position) %>%
  group_by(length) %>%
  nest() 

listed <- nested %>% ungroup() %>% pull(data) %>% 
  map(~pull(.x, surprisal)) #%>%
 # map(~scale(.x, scale = TRUE)[,1])

  
dtw_avg <- DBA(listed, trace = TRUE, max.iter = 100)


dtw_avg %>%
  enframe(name = "x", value = "y") %>%
  ggplot(aes(x = x, y = y)) +
  geom_point() + 
  geom_line()


