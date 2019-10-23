require(here)
require(broom)
require(janitor)
require(tidyverse)
require(lme4)
require(data.table)

NUM_SECTIONS <- 5
lang_name = commandArgs(trailingOnly=TRUE)[1]

## helpers
# Get the quantiles of the different sentence lengths i.e. the positions at the
# different "fifths" of the sentence
get_quantiles <- function(df, num_sections) {
  df %>%
    pull(position) %>%
    quantile(., probs = seq(0, 1, 1/num_sections)) %>%
    round() %>%
    enframe(name = NULL) %>%
    rename(position = value) %>%
    mutate(quantile = 1:(num_sections + 1))
}


relative_slopes <- function(lang_df, pos_list) {

  divides <- pos_list %>%
    group_by(length) %>%
    mutate(start_pos = position, end_pos = lead(position)) %>%
    filter(!is.na(end_pos)) %>%
    group_by(length, quantile) %>%
    nest() %>%
    mutate(position = map(data, ~seq(.x$start_pos, .x$end_pos) %>%
                            enframe(name = NULL, value = "position"))) %>%
    select(-data) %>%
    unnest(cols = position)

  quantile_groups <- divides %>%
    left_join(lang_df, by = c("length", "position")) %>%
    group_by(quantile, length) %>%
    mutate(position = scale(position)) %>%
    ungroup() %>%
    mutate(quantile = factor(quantile), length = scale(length))

  lm(surprisal ~ length * position : quantile + 0,
                data = quantile_groups) %>%
    tidy() %>%
    filter(str_detect(term, "position"),
           str_detect(term, "quantile"), !str_detect(term, "length")) %>%
    clean_names() %>%
    mutate(term = gsub("position:quantile", "", term),
           term = as.numeric(term)) %>%
    rename(quantile = term)
}

wikipedia_ngrams <- read_csv(here(paste0("Data/wikipedia_", lang_name, ".csv")),
                     col_names = c("position", "surprisal", "length")) %>%
  mutate(position = position + 1) %>% #python is 0 but R is 1-indexed
  filter(length >= 9, length <= 50)

pos_list <- wikipedia_ngrams %>%
  group_by(length) %>%
  nest() %>%
  mutate(quantiles = map(data, ~get_quantiles(.x, NUM_SECTIONS))) %>%
  select(-data) %>%
  unnest(cols = c(quantiles))

slopes <- relative_slopes(wikipedia_ngrams, pos_list)

lang_slopes <- slopes %>%
  pull(estimate) %>%
  tibble() %>%
  t() %>%
  as_tibble() %>%
  mutate(language = lang_name) %>%
  rename(slope1 = V1, slope2 = V2, slope3 = V3, slope4 = V4, slope5 = V5)

all_slopes <- read_csv(here("Data/Wikipedia/new_relative_slopes.csv"), col_names=T)
all_slopes %>%
  bind_rows(lang_slopes) %>%
  write_csv(here("Data/Wikipedia/new_relative_slopes.csv"))
