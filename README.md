# Language modeling tools for studying the distribution of information in speech and text

## Setup

The pipelines for CHILDES and Wikipedia are set up to work in a bash environment with curl and jq installed (if not install, Homebrew and apt-get work for installing both of them). You will need to install the regex and KenLM packages for Python (the installation process for KenLM is described below). You also need a working R installation with the tidyverse, janitor and here libraries installed. If you want to run the CHILDES pipeline, you will need the childes-r R library installed as well. 

Run

`python3 -m pip install https://github.com/kpu/kenlm/archive/master.zip`

to install the Python3 API for KenLM. Follow the instructions on (https://kheafield.com/code/kenlm/) to download and install kenlm into the home directory for this project. The scripts handle using the Python and C++ modules, so you don't have to worry about anything besides installation.

More information on the installation and usage for KenLM in Python can be found at (https://github.com/kpu/kenlm) and KenLM in general at (https://kheafield.com/code/kenlm/).

## Usage

Clone the repository.

*childes*: From the top-level directory, run

`sh Scripts/childes_process.sh 1 2 3`

where 1 is the name of the collection you want to target in childes-db; 2 is the column (stem or gloss) you want to run the language model on, which matters for languages with different scripts; and 3 is "child" for child speech or anything else for parent speech.

*wikipedia*: From the top-level directory, run

`sh Scripts/wikipedia_process.sh 1 2`

where 1 is the English name of the language you want to target in childes-db; and 2 is the order of ngrams you want to use in the model.

## Other notes

### Changes made to Giuseppi Attardi's wikiextractor (cirrus-extract.py):
Line 76: changed `char` to `int(char)` for each character.
Lines 121-137: now only writes the text, not the header or footer.
~Lines 100-105 (in process_dump): now only writes the text and does not utf-8 encode it


## Attributions
