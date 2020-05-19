#!/bin/bash

## arguments
## 1. corpus name; 2. language name;
## 3. location of training file; 4. location of testing file
## 5. name of model


## preprocess the corpus
# cat Data/$1/$2.txt | python3 Scripts/process_corpus.py > Data/$1/${2}_temp.txt

## build the unigram model
kenlm/build/bin/lmplz -o 1 --discount_fallback < $3 > Models/$1/unigram/${2}_${5}.lm
## get surprisals and barycenter
Rscript Scripts/unigram_surprisal.R $1 $2 $4
Rscript Scripts/compress_surprisals.R $2 unigram
python3 Scripts/dba.py $1 $2 unigram

## build the trigram model
cat $3 | kenlm/build/bin/lmplz -o 3 --discount_fallback > Models/$1/trigram/${2}_${5}.arpa
# convert trigram model to binary for faster reading and lower storage
kenlm/build/bin/build_binary Models/$1/trigram/${2}_${5}.arpa Models/$1/trigram/${2}_${5}.klm
rm Models/$1/trigram/${2}_${5}.arpa
# get surprisals and barycenter
python3 Scripts/surprisal_ngrams.py $1 $2 $4
Rscript Scripts/compress_surprisals.R $2 trigram
python3 Scripts/dba.py $1 $2 trigram
