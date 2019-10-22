#!/bin/bash

# get the wikipedia dump file
PREFIX=$(cat language_dict.json | jq --arg lang "$1" '.[$lang]' | tr -d \")
curl -o datafile "https://dumps.wikimedia.org/other/cirrussearch/20190923/${PREFIX}wiki-20190923-cirrussearch-content.json.gz"

# extract the text into a single txt file with one sentence per line
python3 Scripts/cirrus-extract.py datafile
python3 Scripts/get_wikipedia.py $1
rm -r text
rm datafile

# build the ngram language model in binary
head -n 1000000 $1.txt | python3 Scripts/process_corpus.py | kenlm/build/bin/lmplz -o $2 --discount_fallback > Models/$1.arpa
kenlm/build/bin/build_binary Models/$1.arpa Models/$1.klm

# now split up the corpus into ngrams and compute surprisal for each of them
python3 Scripts/wikipedia_ngrams.py $1
Rscript Scripts/wikipedia_surprisal.R $1

# clean up
rm $1.txt Models/$1.arpa Models/$1.klm Data/wikipedia_$1.csv
