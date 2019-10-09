# Language modeling tools for studying the distribution of information in speech and text

## Setup

Run

`python3 -m pip install https://github.com/kpu/kenlm/archive/master.zip`

to install the python3 API for KenLM. More information on the installation and usage for KenLM in Python can be found at (https://github.com/kpu/kenlm) and KenLM in general at (https://kheafield.com/code/kenlm/).

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
