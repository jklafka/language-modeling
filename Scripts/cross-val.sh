#!/bin/bash

K = 10
## how many lines in each piece of the file
split_length=`wc -l "$1" | grep -oE "\d+"`/$K

cat Data/$1/$2.txt | python3 Scripts/process_corpus.py > Data/$1/${2}_temp.txt

split -l split_length Data/$1/${2}_temp.txt



## iterate over pieces: train and test unigram and trigram model on all but focused piece
## record suprisals on held-out piece as test
for i in `seq 1 "$K"`;
  do sh Scripts/process.sh $1 $2
done

:'
Fetching data: same.
'
