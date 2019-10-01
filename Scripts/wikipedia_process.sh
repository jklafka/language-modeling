python3 get_wikipedia.py $1
cat $1.txt | python3 process.py | ../kenlm/build/bin/lmplz -o $2 > ../Models/childes.arpa
../kenlm/build/bin/build_binary ../Models/$1.arpa ../Models/$1.klm
python3 wikipedia_ngrams.py $1.txt
