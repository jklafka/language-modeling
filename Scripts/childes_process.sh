#!/bin/bash

# this script takes four arguments: the name of a CHILDES collection; the column (stem or gloss);
# the speaker (child or adult) that you want to run the LM on; and the order of ngrams to use
Rscript Scripts/get_childes.R $1 $2 $3
# build the ngrams model
cat Data/childes_$1_$3.txt | python3 Scripts/process_corpus.py | kenlm/build/bin/lmplz -o $4 > Models/childes_$1_$3.arpa
# convert model to binary for faster reading and lower storage
kenlm/build/bin/build_binary Models/childes_$1_$3.arpa Models/childes_$1_$3.klm
# get ngrams
python3 Scripts/childes_ngrams.py $1 $3
# free up space
rm Data/childes_$1_$3.txt Models/childes_$1_$3.arpa Models/childes_$1_$3.klm
