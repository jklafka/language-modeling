#!/bin/bash

## This script takes in all wikipedia languages and prints out the marginal and
## final cost in the DBA expectation-maximization process
declare -a langs=("Basque" "Alemannic" "Wolof" "Bosnian"
"Urdu" "Afrikaans" "Anglo-Saxon" "Slovak" "Silesian" "Acehnese" "Banyumasan"
"Wu" "Bashkir" "Chuvash" "Gagauz" "Karachay-Balkar" "Sakha" "Tamil" "Telugu"
"Georgian" "Tatar" "Uyghur" "Icelandic" "Belarusian" "Gujarati" "Marathi"
"Estonian" "Finnish" "Hungarian" "Bulgarian" "Yoruba" "Quechua"
"Croatian" "Macedonian" "Serbo-Croatian" "Pangasinan" "Kapampangan" "Khmer"
"Javanese" "Malay" "Sundanese" "Hakka" "Turkish" "Kazakh" "Kirghiz" "Turkmen"
"Persian" "Tajik" "Latin" "Galician" "Romanian" "Norman" "Corsican"
"Bengali" "Waray" "Welsh" "Armenian" "Korean" "Assamese" "Bhojpuri" "Divehi"
"Greek" "Catalan" "Walloon" "Yiddish" "Maltese" "Romansh" "Bavarian" "Faroese"
"Ripuarian" "Luxembourgish" "Limburgish" "Scots" "Zeelandic" "Aragonese"
"Asturian" "Emilian-Romagnol" "Extremaduran" "Franco-Provençal" "Friulian"
"Ladino" "Lombard" "Mirandese" "Neapolitan" "Occitan" "Picard" "Sardinian"
"Sicilian" "Venetian" "Czech" "Rusyn" "Slovenian" "Uzbek" "Amharic" "Zazaki"
"Gilaki" "Mazandarani" "Ossetian" "Pashto" "Võro" "Komi" "Vepsian" "Erzya"
"Konkani" "Odia" 	"Maithili" "Sanskrit" "Sindhi" "Sinhalese" "Esperanto"
"Ido" "Lithuanian" "Latvian" "Samogitian" "Kannada" "Malayalam"
"Breton" "Irish" "Manx" "Burmese" "Mingrelian"
"Lao" "Thai" "Lezgian" "Malagasy" "Papiamentu" "Chavacano" "Albanian"
"Luganda" "Swahili" "Tswana" "Tsonga" "Buryat" "Samoan"
"Tongan" "Nahuatl" "Somali" "Aymara" "Guarani" "Kabyle" "Hausa" "Tetum"
"Tulu" "Kabiye" "Maori" "Nepali" "Mongolian" "Hindi" "Danish" "Hebrew"
"Indonesian" "Vietnamese" "Dutch" "Serbian" "Ukrainian" "Russian" "German"
"Swedish" "Japanese" "Arabic" "Polish" "French" "Spanish"
"English" "Chinese" "Swedish" "French" "English" "Chinese")

for lang in "${langs[@]}"
  do
    echo "$lang"
    sh em_optimization.sh wikipedia "$lang" unigram
    sh em_optimization.sh wikipedia "$lang" trigram
  done
