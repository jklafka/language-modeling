# Constructing representations of language using speech and text

## Project overview

How do top-down constraints in our language affect how we structure our sentences, and how we communicate with one another more broadly? Languages vary widely in terms of hundreds of possible constraints speakers in those languages have to obey. For example, German speakers must use a verb as the second word in their sentences yet have much more flexible word order otherwise than English speakers, while speakers of Chinese and Japanese often must end their sentences with a particle that carries little information on its own.

We carry out the largest-scale cross-linguistic analysis of information structure in communication, both at the level of word frequency and at the communicative level by incorporating predictive processing. We mainly use parent-child speech corpora from the CHILDES-Talkbank system and

## Setup

The pipelines for CHILDES and Wikipedia are set up to work in a bash environment with curl and jq installed (if not install, Homebrew and apt-get work for installing both of them). You will need to install the regex and KenLM packages for Python (the installation process for KenLM is described below). You also need a working R installation with the tidyverse, janitor and here libraries installed. If you want to run the CHILDES pipeline, you will need the childes-r R library installed as well.

Run

`python3 -m pip install https://github.com/kpu/kenlm/archive/master.zip`

to install the Python3 API for KenLM. Follow the instructions on (https://kheafield.com/code/kenlm/) to download and install kenlm into the home directory for this project. The scripts handle using the Python and C++ modules, so you don't have to worry about anything besides installation.

More information on the installation and usage for KenLM in Python can be found at (https://github.com/kpu/kenlm) and KenLM in general at (https://kheafield.com/code/kenlm/).

## Local usage

Clone the repository. Execute either of the following commands in the command-line.

*childes*: From the top-level directory, run

`sh Scripts/preprocess.sh childes 1`

where 1 is the name of the language collection (e.g. "Chinese").

*wikipedia*: From the top-level directory, run

`sh Scripts/preprocess.sh wikipedia 1`

where 1 is the English name of the language corpus from Wikipedia you want to train the frequency-based and contextual models on.

## Other notes

### Changes made to Giuseppi Attardi's wikiextractor (cirrus-extract.py):
Line 76: changed `char` to `int(char)` for each character.
Lines 121-137: now only writes the text, not the header or footer.
~Lines 100-105 (in process_dump): now only writes the text and does not utf-8 encode it
