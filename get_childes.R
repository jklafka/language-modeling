require(childesr)
require(dplyr)

args = commandArgs(trailingOnly=TRUE)

get_utterances(corpus = args[1]) %>%
  select(args[2]) %>%
  write.table("childes.txt",sep="\n",row.names=FALSE)

system("cat childes.txt | python3 process.py | ./kenlm/build/bin/lmplz -o 3 > childes.arpa")
system("./kenlm/build/bin/build_binary childes.arpa childes.klm")