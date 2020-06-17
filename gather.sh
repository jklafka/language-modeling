#!/bin/bash

readarray langs < languages.txt

for lang in "${langs[@]}"
do
  ## do we have a unigram and trigram model folder?
  echo $lang
  [ -d "Models/wikipedia/unigram/$lang/" ] && (echo "$lang unigram" >> to_model.txt)
  [ -d "Models/wikipedia/trigram/$lang/" ] && (echo "$lang trigram" >> to_model.txt)

  ## do we have a non-compressed surprisal file for both unigrams and trigrams?
  [ -f "ValSurprisals/wikipedia/unigram/$lang.csv" ] && (echo "$lang unigram" >> to_surprisal.txt)
  [ -f "ValSurprisals/wikipedia/trigram/$lang.csv" ] && (echo "$lang trigram" >> to_surprisal.txt)

  ## do we have a compressed surprisal file for both unigrams and trigrams?
  [ -f "ValSurprisals/wikipedia/unigram/${lang}_compressed.csv" ] && (echo "$lang unigram" >> to_compress.txt)
  [ -f "ValSurprisals/wikipedia/trigram/${lang}_compressed.csv" ] && (echo "$lang trigram" >> to_compress.txt)
done
