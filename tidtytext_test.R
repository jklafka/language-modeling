# first build the ngram counts
# ngram-count -text brown.txt -lm -kndiscount brown.lm 

# then do word-by-word prediction
# ngram -lm brown.lm -ppl brown.txt -debug 2 > brown.ppl

# then set PPL to the file you want and run!

PPL <- "brown.ppl"

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
  summarise(value = mean(-value))

mean__surprisals %>%
  filter(length %in% c(5, 7, 9, 11, 13)) %>%
  ggplot(aes(x = position, y = value, color = as.factor(length))) + 
  geom_point() +
  geom_line() + 
  theme_classic()

