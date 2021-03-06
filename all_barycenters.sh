#!/bin/bash

declare -a languages=("Alemannic" "Wolof" "Urdu" "Silesian" "Acehnese"
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
"Kabyle" "Hausa" "Tetum" "Tulu" "Kabiye" "Maori" "Nepali" "Mongolian"
"Basque" "Bosnian" "Afrikaans" "Anglo-Saxon" "Slovak"
"Banyumasan" "Karachay" "Balkar" "Marathi" "Estonian" "Finnish"
"Hungarian" "Bulgarian" "Croatian" "Serbo" "Malay" "Turkish"
"Persian" "Galician" "Romanian" "Waray" "Korean" "Catalan"
"Asturian" "Emilian" "Romagnol" "Extremaduran" "Franco" "Provençal"
"Czech" "Slovenian" "Võro" "Esperanto" "Lithuanian" "Latvian"
"Samogitian" "Chavacano" "Danish" "Indonesian" "Vietnamese" "Dutch"
"Ukrainian" "Russian" "German" "Arabic" "Polish" "French" "Spanish"
"English" "Chinese" "Japanese" "French" "Swedish" "Hebrew" "Serbian"
"Hindi" "Chavacano" "Marathi" "Extremaduran" "Karachay-Balkar" "Samogitian")

for language in "${languages[@]}"
do
  python3 Scripts/dba.py wikipedia $language unigram
  python3 Scripts/dba.py wikipedia $language trigram
done
