#!/bin/bash

K=10

declare -a alphabet=( 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n'
                      'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' )

## tokenize corpus
cat Data/$1/$2.txt | python3 Scripts/process_corpus.py > Data/$1/${2}_processed.txt

# ## split file into K pieces
# numerator=`wc -l Data/$1/${2}_processed.txt | grep -oE "\d+"`
# let split_length=" $numerator / $K "

shuf -o Data/$1/${2}_shuffled.txt Data/$1/${2}_processed.txt
rm Data/$1/${2}_processed.txt

if [ ! -d "Data/$1/$2/" ]
then
  mkdir Data/$1/$2/
fi
split -n 10 -a 1 Data/$1/${2}_shuffled.txt Data/$1/$2/
# split -l split_length -a 1 Data/$1/${2}_shuffled.txt Data/$1/$2/


mkdir -p Models/$1/unigram/$2/
mkdir Models/$1/trigram/$2/
echo "position,surprisal,length" > ValSurprisals/$1/trigram/${2}.csv

## iterate over pieces: train and test unigram and trigram model on all but held-out piece
## record suprisals on held-out piece as test and write to file
for holdout in "${alphabet[@]:0:${K-1}}"
do
  # echo $holdout
  for letter in "${alphabet[@]:0:${K-1}}"
  do
    # echo $letter
    [ $holdout != $letter ] && cat Data/$1/${2}/$letter > Data/$1/${2}/bigtemp.txt
  done
  sh Scripts/process.sh $1 $2 Data/$1/${2}/bigtemp.txt Data/$1/${2}/$holdout $holdout
  rm Data/$1/${2}/bigtemp.txt
done

Rscript Scripts/compress_surprisals.R $1 $2 unigram
python3 Scripts/dba.py $1 $2 unigram
Rscript Scripts/compress_surprisals.R $1 $2 trigram
python3 Scripts/dba.py $1 $2 trigram

rm Data/$1/${2}_shuffled.txt
