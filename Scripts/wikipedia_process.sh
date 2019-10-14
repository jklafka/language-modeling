#!/bin/bash

python3 Scripts/get_wikipedia.py $1
cat $1.txt | python3 Scripts/process_corpus.py | kenlm/build/bin/lmplz -o $2 --discount_fallback > Models/$1.arpa
kenlm/build/bin/build_binary Models/$1.arpa Models/$1.klm
python3 Scripts/wikipedia_ngrams.py $1
Rscript Scripts/wikipedia_surprisal.R $1
rm $1.txt Models/$1.arpa Models/$1.klm Data/wikipedia_$1.csv
