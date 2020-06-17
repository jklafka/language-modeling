#!/bin/bash

## arguments
## 1. corpus name; 2. language name;
## 3. location of training file; 4. location of testing file
## 5. name of model

## build the unigram model
cat $3 | ~/kenlm/build/bin/lmplz -o 1 -S 10% > Models/$1/unigram/${2}/${5}.lm

## build the trigram model
cat $3 | ~/kenlm/build/bin/lmplz -o 3 -S 10% > Models/$1/trigram/${2}/${5}.arpa
# convert trigram model to binary for faster reading and lower storage
~/kenlm/build/bin/build_binary Models/$1/trigram/${2}/${5}.arpa Models/$1/trigram/${2}/${5}.klm

# get surprisals and barycenter
Rscript Scripts/unigram_surprisal.R $1 $2 $5
python3 Scripts/surprisal_ngrams.py $1 $2 $4 $5
