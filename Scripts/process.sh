#!/bin/bash

# takes source (childes or wikipedia or corpus); name of language/corpus;
# sh Scripts/process.sh childes Eng-NA

## get corpus into .txt file
if [[ $1 == "childes" ]]
then
  # get the CHILDES corpus
  Rscript Scripts/get_childes.R $2

else

  if [[ $1 == "wikipedia" ]]
  then
    # get the language's Wikipedia prefix (e.g. "en" for English)
    PREFIX=$(cat language_dict.json | jq --arg lang "$2" '.[$lang]' | tr -d \")
    # get most recent full wikipedia dump
    DUMPSDATE=$(python3 Scripts/get_dumpsdate.py)
    timeout 15m curl -o datafile "https://dumps.wikimedia.org/other/cirrussearch/current/${PREFIX}wiki-${DUMPSDATE}-cirrussearch-content.json.gz"
    # extract the text into a single txt file with one sentence per line
    python3 Scripts/cirrus-extract.py datafile
    python3 Scripts/get_wikipedia.py $2
    rm -r text
    rm datafile

  fi

  ## Build unigram and trigram models

  # build the unigram model
  cat Data/$1/$2.txt file |
    python3 Scripts/process_corpus.py |
    kenlm/build/bin/lmplz -o 1 > Models/$1/unigram/$2.lm
  # extract unigram model from kenlm file
  ####### REMAINS TO BE DONE

  # build the trigram model
  cat Data/$1/$2.txt file |
    python3 Scripts/process_corpus.py |
    kenlm/build/bin/lmplz -o 3 > Models/$1/trigram/$2.arpa

  # convert model to binary for faster reading and lower storage
  kenlm/build/bin/build_binary Models/$1/trigram/$2.arpa Models/$1/trigram/$2.klm
  rm Models/$1/trigram/$2.arpa

  # get surprisals
  python Scripts/surprisal_ngrams.py $2 1
  python Scripts/surprisal_ngrams.py $2 3
  # free up space
  rm Models/childes_$1_$3.arpa Models/childes_$1_$3.klm Data/childes_$1_$3.txt

fi
