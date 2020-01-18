library(tidyverse)
library(dtwclust)
library(here)

switchboard <- read_csv(here("data/surprisals/unigram/switchboard.csv"))
gujarati <- read_csv(here("Data/Gujarati_unigrams.csv"))


nested <- gujarati %>%
  filter(length > 5, length < 30) %>%
  mutate(switch = position < lag(position)) %>%
  mutate(switch = if_else(is.na(switch), FALSE, switch)) %>%
  mutate(switch = cumsum(switch)) %>%
  group_by(length, position, switch) %>% # get ids for each sentence
  summarise(surprisal = mean(surprisal, na.rm = T)) %>%
  summarise(surprisal = mean(surprisal, na.rm = T)) %>%
  select(-position) %>%
  group_by(length) %>%
  nest() 

listed <- nested %>% ungroup() %>% pull(data) %>% 
  map(~pull(.x, surprisal)) #%>%
 # map(~scale(.x, scale = TRUE)[,1])

  
dtw_avg <- DBA(listed, centroid = listed[[5]], trace = TRUE, max.iter = 100)


dtw_avg %>%
  enframe(name = "x", value = "y") %>%
  ggplot(aes(x = x, y = y)) +
  geom_point() + 
  geom_line()


# require(reticulate)
# use_python("~//usr/local/bin/python3.7")
# use_condaenv(condaenv = "lm", conda = "/Applications/anaconda3/bin/conda")
# tslearn <- import("tslearn.barycenters")
# 
# tslearn$dtw_barycenter_averaging(listed, barycenter_size = )
# nested %>% 
#   ungroup() %>%
#   pivot_wider(names_from = position, values_from = surprisal) %>%
#   select(-length) %>%
#   write_csv(here("guja.csv"))
