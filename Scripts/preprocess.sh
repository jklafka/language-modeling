#!/bin/bash

# takes source (childes or wikipedia or corpus); name of language/corpus;
# e.g.: sh Scripts/cross-val.sh childes Eng-NA

## get corpus into .txt file
if [[ $1 == "childes" ]]
then
  # get the CHILDES corpus
  Rscript Scripts/get_childes.R $2

  sh Scripts/cross-val.sh adult $2
  sh Scripts/cross-val.sh child $2

else

  if [[ $1 == "wikipedia" ]]
  then
    ## get the language's Wikipedia prefix (e.g. "en" for English)
    PREFIX=$(cat language_dict.json | jq --arg lang "$2" '.[$lang]' | tr -d \")
    ## get most recent full wikipedia dump
    DUMPSDATE=$(python3 Scripts/get_dumpsdate.py)
    timeout 10m curl -o datafile "https://dumps.wikimedia.org/other/cirrussearch/current/${PREFIX}wiki-${DUMPSDATE}-cirrussearch-content.json.gz"
    ## extract the text into a single txt file with one sentence per line
    python3 Scripts/cirrus-extract.py datafile
    python3 Scripts/get_wikipedia.py $2
    rm -r text
    rm datafile

    sh Scripts/cross-val.sh $1 $2

  else

    sh Scripts/cross-val.sh adult $1

  fi

fi
