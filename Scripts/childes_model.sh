cat ../Data/childes.txt | python3 process.py | ../kenlm/build/bin/lmplz -o 3 > ../Models/childes.arpa
../kenlm/build/bin/build_binary ../Models/childes.arpa ../Models/childes.klm
python3 childes_ngrams.py
