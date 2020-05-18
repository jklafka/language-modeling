#!/bin/bash

K = 10

declare -a alphabet=( 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n'
                      'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z')

## tokenize corpus
cat Data/$1/$2.txt | python3 Scripts/process_corpus.py > Data/$1/${2}_processed.txt

## split file into K pieces
split_length=`wc -l "$1" | grep -oE "\d+"`/$K

split -l split_length Data/$1/${2}_processed.txt

## iterate over pieces: train and test unigram and trigram model on all but held-out piece
## record suprisals on held-out piece as test and write to file
for i in ("alphabet[@:1:${K}]");
  cat Data/$1/${2}_temp[a-${K}!"${i}"] > Data/$1/${2}_bigtemp.txt
  do sh Scripts/process.sh Data/$1/${2}_bigtemp.txt Data/$1/${2}_temp${i}.txt
  rm Data/$1/${2}_bigtemp.txt
done
