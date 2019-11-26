#!/bin/bash

# the largest language corpora (over 1.5gb) are on the last two lines
declare -a fullarr=("Basque" "Alemannic" "Wolof" "Bosnian"
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
	"English" "Chinese" )

for i in "${fullarr[@]}"
  do
    echo "$i"
    sh Scripts/wikipedia_process.sh "$i" $1
  done
