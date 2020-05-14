#!/bin/bash

K = 10

## tokenize corpus
cat Data/$1/$2.txt | python3 Scripts/process_corpus.py > Data/$1/${2}_processed.txt

## split file into K pieces
split_length=`wc -l "$1" | grep -oE "\d+"`/$K

split -l split_length Data/$1/${2}_processed.txt

## iterate over pieces: train and test unigram and trigram model on all but held-out piece
## record suprisals on held-out piece as test and write to file
for i in `{a..f}`;
  cat Data/$1/${2}_temp[a-f!"$i"] > Data/$1/${2}_bigtemp.txt
  do sh Scripts/process.sh Data/$1/${2}_bigtemp.txt Data/$1/${2}_temp${i}.txt
  rm Data/$1/${2}_bigtemp.txt
done
