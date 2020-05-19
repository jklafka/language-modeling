#!/bin/bash

K=2

declare -a alphabet=( 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n'
                      'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' )

## tokenize corpus
cat Data/$1/$2.txt | python3 Scripts/process_corpus.py > Data/$1/${2}_processed.txt

## split file into K pieces
numerator=`wc -l Data/$1/${2}_processed.txt | grep -oE "\d+"`
let split_length=" $numerator / $K "

shuf -o Data/$1/${2}_shuffled.txt Data/$1/${2}_processed.txt
rm Data/$1/${2}_processed.txt

if [ ! -d "Data/$1/$2/" ]
then
  mkdir Data/$1/$2/
fi
split -l $split_length -a 1 Data/$1/${2}_shuffled.txt Data/$1/$2/

## iterate over pieces: train and test unigram and trigram model on all but held-out piece
## record suprisals on held-out piece as test and write to file
for holdout in "${alphabet[@]:0:${K-1}}"
do
  for letter in "${alphabet[@]:0:${K-1}}"
  do
    [ $holdout != $letter ] && cat Data/$1/${2}/$letter > Data/$1/${2}_bigtemp.txt
  done
  sh Scripts/process.sh $1 $2 Data/$1/${2}_bigtemp.txt Data/$1/${2}/$holdout $holdout
  rm Data/$1/${2}_bigtemp.txt
done

rm Data/$1/${2}_shuffled.txt
