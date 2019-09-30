# Language modeling tools for studying the distribution of information in speech and text


## Changes to wikiextractor/cirrus-extract.py

Line 76: changed `char` to `int(char)` for each character.
Lines 121-137: now only writes the text, not the header or footer.
~Lines 100-105 (in process_dump): now only writes the text and does not utf-8 encode it
