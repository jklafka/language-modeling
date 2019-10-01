Rscript Scripts/get_childes.R $1 $2
cat Data/childes_$1.txt | python3 Scripts/process_corpus.py | kenlm/build/bin/lmplz -o 3 > Models/childes_$1.arpa
kenlm/build/bin/build_binary Models/childes_$1.arpa Models/childes_$1.klm
python3 Scripts/childes_ngrams.py $1
rm Data/childes_$1.txt
