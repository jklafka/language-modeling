#!/bin/bash

# the largest language corpora (over 1.5gb) are on the last two lines
declare -a fullarr=("Basque" "Alemannic" "Wolof" "Bosnian"
	"Urdu" "Afrikaans" "Anglo-Saxon" "Icelandic" "Belarusian" "Bulgarian"
	"Croatian" "Macedonian" "Serbo-Croatian" "Pangasinan" "Kapampangan" "Khmer"
	"Javanese" "Malay" "Sundanese" "Hakka" "Turkish" "Kazakh" "Kirghiz" "Turkmen"
	"Persian" "Tajik" "Latin" "Galician" "Romanian" "Norman" "Corsican"
	"Estonian" "Finnish" "Hungarian" "Bengali" "Waray" "Welsh" "Armenian" "Korean"
	"Greek" "Catalan" "Walloon" "Yiddish" "Maltese" "Romansh" "Bavarian" "Faroese"
	"Ripuarian" "Luxembourgish" "Limburgish" "Scots" "Zeelandic" "Aragonese"
	"Asturian" "Emilian-Romagnol" "Extremaduran" "Franco-Provençal" "Friulian"
	"Ladino" "Lombard" "Mirandese" "Neapolitan" "Occitan" "Picard" "Sardinian"
	"Sicilian" "Venetian" "Czech" "Rusyn" "Slovenian" "Slovak"
	"Silesian" "Acehnese" "Banyumasan" "Wu" "Bashkir" "Chuvash"
	"Gagauz" "Karachay-Balkar" "Sakha" "Tatar" "Uyghur" "Uzbek" "Amharic" "Zazaki"
	"Gilaki" "Mazandarani" "Ossetian" "Pashto" "Võro" "Komi" "Vepsian" "Erzya"
	"Assamese" "Bhojpuri" "Divehi" "Konkani" "Gujarati" "Marathi" "Odia"
	"Maithili" "Sanskrit" "Sindhi" "Sinhalese" "Esperanto"
	"Ido" "Lithuanian" "Latvian" "Samogitian" "Kannada" "Malayalam"
	"Tamil" "Telugu" "Breton" "Irish" "Manx" "Burmese" "Georgian" "Mingrelian"
	"Lao" "Thai" "Lezgian" "Malagasy" "Papiamentu" "Chavacano" "Albanian"
	"Luganda" "Swahili" "Tswana" "Tsonga" "Yoruba" "Quechua" "Buryat" "Samoan"
	"Tongan" "Nahuatl" "Somali" "Aymara" "Guarani" "Kabyle" "Hausa" "Tetum"
	"Tulu" "Kabiye" "Maori" "Nepali" "Mongolian" "Hindi" "Danish" "Hebrew"
	"Indonesian" "Vietnamese" "Dutch" "Serbian" "Ukrainian" "Russian" "German"
	"Swedish" "Japanese" "Arabic" "Polish" "French" "Spanish")

declare -a biglangs=("English" "Chinese" )

for i in "${biglangs[@]}"
  do
    echo "$i"
    sh Scripts/wikipedia_process.sh "$i" $1
  done
