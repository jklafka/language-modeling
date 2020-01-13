#!/bin/bash

# this program takes two arguments: a language and an ngram order

# get the language's Wikipedia prefix (e.g. "en" for English)
PREFIX=$(cat language_dict.json | jq --arg lang "$1" '.[$lang]' | tr -d \")
# cut off downloading the file after 15 minutes
timeout 10m curl -o datafile "https://dumps.wikimedia.org/other/cirrussearch/20191125/${PREFIX}wiki-20191125-cirrussearch-content.json.gz"

# extract the text into a single txt file with one sentence per line
python3 Scripts/cirrus-extract.py datafile
python3 Scripts/get_wikipedia.py $1
rm -r text
rm datafile

# build the ngram language model using KenLM
head -n 1000000 $1.txt | python3 Scripts/process_corpus.py | kenlm/build/bin/lmplz -o $2 --discount_fallback > Models/$1.arpa
# convert the language model to binary
kenlm/build/bin/build_binary Models/$1.arpa Models/$1.klm

# split up the corpus into ngrams and evaluate surprisal on each
python3 Scripts/wikipedia_ngrams.py $1
# compute the slopes
# Rscript Scripts/wikipedia_surprisal.R $1

# clean up
rm $1.txt Models/$1.arpa Models/$1.klm #Data/wikipedia_$1.csv
