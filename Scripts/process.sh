#!/bin/bash

## preprocess the corpus
# cat Data/$1/$2.txt | python3 Scripts/process_corpus.py > Data/$1/${2}_temp.txt

## build the unigram model
kenlm/build/bin/lmplz -o 1 --discount_fallback < $1 > Models/$1/unigram/$2.lm
## get surprisals and barycenter
Rscript Scripts/unigram_surprisal.R $2
Rscript Scripts/compress_surprisals.R $2 unigram
python3 Scripts/dba.py $1 $2 unigram

## build the trigram model
cat $1 | kenlm/build/bin/lmplz -o 3 --discount_fallback > Models/$1/trigram/$2.arpa
# convert trigram model to binary for faster reading and lower storage
kenlm/build/bin/build_binary Models/$1/trigram/$2.arpa Models/$1/trigram/$2.klm
rm Models/$1/trigram/$2.arpa
# get surprisals and barycenter
python3 Scripts/surprisal_ngrams.py $2
Rscript Scripts/compress_surprisals.R $2 trigram
python3 Scripts/dba.py $1 $2 trigram

rm Data/$1/${2}_temp.txt
