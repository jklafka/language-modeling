Rscript Scripts/get_childes.R $1 $2 $3
cat Data/childes_$1_$3.txt | python3 Scripts/process_corpus.py | kenlm/build/bin/lmplz -o 3 > Models/childes_$1_$3.arpa
kenlm/build/bin/build_binary Models/childes_$1_$3.arpa Models/childes_$1_$3.klm
rm Models/childes_$1_$3.arpa #free up space
python3 Scripts/childes_ngrams.py $1 $3
rm Data/childes_$1_$3.txt
