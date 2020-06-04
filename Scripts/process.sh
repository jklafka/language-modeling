#!/bin/bash

## arguments
## 1. corpus name; 2. language name;
## 3. location of training file; 4. location of testing file
## 5. name of model

## build the trigram model
cat $3 | ~/kenlm/build/bin/lmplz -o 3 --discount_fallback > Models/$1/trigram/${2}/${5}.arpa
# convert trigram model to binary for faster reading and lower storage
~/kenlm/build/bin/build_binary Models/$1/trigram/${2}/${5}.arpa Models/$1/trigram/${2}/${5}.klm
## extract unigram data from trigram model
echo \data\ > Models/$1/unigram/${2}/${5}.arpa
# get number of unigrams
grep Models/$1/trigram/${2}/${5}.arpa -oE "ngram 1=\d+" >> Models/$1/unigram/${2}/${5}.arpa
# get all unigrams
sed -n "/^[\]1grams:/,/^$/p" Models/$1/trigram/${2}/${5}.arpa >> Models/$1/unigram/${2}/${5}.arpa
rm Models/$1/trigram/${2}/${5}.arpa

# get surprisals and barycenter
Rscript Scripts/unigram_surprisal.R $1 $2 $4 $5
python3 Scripts/surprisal_ngrams.py $1 $2 $4 $5
