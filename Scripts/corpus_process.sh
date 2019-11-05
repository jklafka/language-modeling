#!/bin/bash

# this program takes two arguments: a corpus and an ngram order

# build the ngram language model using KenLM
cat Data/corpus/$1.txt | python3 Scripts/process_corpus.py | kenlm/build/bin/lmplz -o $2 --discount_fallback > Models/corpus_$1.arpa
# convert the language model to binary
kenlm/build/bin/build_binary Models/corpus_$1.arpa Models/corpus_$1.klm
# split up the corpus into ngrams and evaluate surprisal on each
python3 Scripts/corpus_ngrams.py $1
# clean up
rm Models/corpus_$1.arpa Models/corpus_$1.klm
