require(childesr)
require(dplyr)
require(here)

args = commandArgs(trailingOnly=TRUE)

get_utterances(corpus = args[1]) %>%
  select(args[2]) %>%
  write.table(here("../data/childes.txt"), sep="\n", row.names=FALSE)

system("cat ../data/childes.txt | python3 process.py | ../kenlm/build/bin/lmplz -o 3 > ../models/childes.arpa")
system("../kenlm/build/bin/build_binary ../models/childes.arpa ../models/childes.klm")
system("python3 childes_ngrams.py")