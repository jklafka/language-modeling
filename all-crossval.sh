#!/bin/bash

declare -a small_languages=("Alemannic" "Wolof" "Urdu" "Silesian" "Acehnese"
"Wu" "Bashkir" "Chuvash" "Gagauz" "Karachay-Balkar" "Sakha" "Tamil" "Telugu"
"Georgian" "Tatar" "Uyghur" "Icelandic" "Belarusian" "Gujarati" "Yoruba"
"Quechua" "Macedonian" "Serbo-Croatian" "Pangasinan" "Kapampangan"
"Khmer" "Javanese" "Sundanese" "Hakka" "Kazakh" "Kirghiz" "Turkmen" "Tajik"
"Latin" "Norman" "Corsican" "Bengali" "Welsh" "Armenian" "Assamese" "Bhojpuri"
"Divehi" "Greek" "Walloon" "Yiddish" "Maltese" "Romansh" "Bavarian" "Faroese"
"Ripuarian" "Luxembourgish" "Limburgish" "Scots" "Zeelandic" "Aragonese"
"Emilian-Romagnol" "Franco-Provençal" "Friulian" "Ladino" "Lombard" "Mirandese"
"Neapolitan" "Occitan" "Picard" "Sardinian" "Sicilian" "Venetian" "Rusyn"
"Uzbek" "Amharic" "Zazaki" "Gilaki" "Mazandarani" "Ossetian" "Pashto" "Komi"
"Vepsian" "Erzya" "Konkani" "Odia" "Maithili" "Sanskrit" "Sindhi" "Sinhalese"
"Ido" "Kannada" "Malayalam" "Breton" "Irish" "Manx" "Burmese" "Mingrelian"
"Lao" "Thai" "Lezgian" "Malagasy" "Papiamentu" "Albanian" "Luganda" "Swahili"
"Tswana" "Tsonga" "Buryat" "Samoan" "Tongan" "Nahuatl" "Somali" "Aymara" "Guarani"
"Kabyle" "Hausa" "Tetum" "Tulu" "Kabiye" "Maori" "Nepali" "Mongolian")

declare -a big_languages=("Basque" "Bosnian" "Afrikaans" "Anglo-Saxon" "Slovak"
"Banyumasan" "Karachay" "Balkar" "Marathi" "Estonian" "Finnish"
"Hungarian" "Bulgarian" "Croatian" "Serbo" "Malay" "Turkish"
"Persian" "Galician" "Romanian" "Waray" "Korean" "Catalan"
"Asturian" "Emilian" "Romagnol" "Extremaduran" "Franco" "Provençal"
"Czech" "Slovenian" "Võro" "Esperanto" "Lithuanian" "Latvian"
"Samogitian" "Chavacano" "Danish" "Indonesian" "Vietnamese" "Dutch"
"Ukrainian" "Russian" "German" "Arabic" "Polish" "French" "Spanish"
"Cantonese" "Aromanian" "Tarantino" "Gothic" "Piedmontese"
"Kashubian" "Cebuano" "Banyumasan" "Buginese" 

declare -a new_languages=("Banjar" "Chamorro" "Minangkabau"
"Gan" "Azerbaijani" "Karakalpak" "Tuvan" "Aramaic" "Tigrinya"
"Komi-Permyak" "Udmurt" "Moksha" "Kashmiri" "Doteli" "Pali" "Romani"
"Interlingua" "Interlingue" "Lojban" "Novial" "Volapuk" "Latgalian"
"Cornish" "Dzongkha" "Newar" "Pontic" "Zhuang" "Avar" "Chechen" "Lak" "Kongo"
"Kikuyu" "Lingala" "Chichewa" "Kirundi" "Kinyarwanda" "Shona" "Swati" "Sesotho"
"Tumbuka" "Venda" "Xhosa" "Zulu" "Kalmyk" "Hawaiian" "Tahitian" "Oromo"
"Bislama" "Norfolk" "Sranan" "Navajo" "Abkhazian" "Kabardian" "Inupiak"
"Inuktitut" "Greenlandic" "Nauruan" "Fula" "Akan" "Ewe" "Twi" "Igbo" "Cheyenne"
"Cree" "Cherokee" "Bambara" "Fijian" "Sango" "Afar" "Herero" "Kanuri" "Muscogee"
"Ndonga" "Kuanyama" "Adyghe" "Choctaw" "Marshallese" "Nuosu" "Livvi-Karelian"
"Dinka" "Atikamekw" "Ingush" "Gorontalo" "Santali")
## for each language
## submit a job to run cross-val for that language on a compute node with enough memory

# for language in "${small_languages[@]}"
# do
#   sbatch one-crossval.sh wikipedia $language
# done

for language in "${new_languages[@]}"
do
  # sbatch one-crossval.sh wikipedia $language
  sh Scripts/preprocess.sh wikipedia $language
done
