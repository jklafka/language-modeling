#!/bin/bash


declare -a languages=("Basque" "Bosnian" "Afrikaans" "Anglo-Saxon" "Slovak"
"Banyumasan" "Karachay" "Balkar" "Marathi" "Estonian" "Finnish"
"Hungarian" "Bulgarian" "Croatian" "Serbo" "Malay" "Turkish"
"Persian" "Galician" "Romanian" "Waray" "Korean" "Catalan"
"Asturian" "Emilian" "Romagnol" "Extremaduran" "Franco" "Provençal"
"Czech" "Slovenian" "Võro" "Esperanto" "Lithuanian" "Latvian"
"Samogitian" "Chavacano" "Danish" "Indonesian" "Vietnamese" "Dutch"
"Ukrainian" "Russian" "German" "Arabic" "Polish" "French" "Spanish")
## for each language
## submit a job to run cross-val for that language on a compute node with enough memory

for language in "${languages[@]}"
do
  sbatch one-crossval.sh wikipedia $language
done
