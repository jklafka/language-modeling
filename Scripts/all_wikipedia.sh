#!/bin/bash

declare -a fullarr=("Macedonian" "Serbo-Croatian" "Pangasinan" "Kapampangan" "Khmer"
	"Javanese" "Malay" "Sundanese" "Hakka" "Turkish" "Kazakh" "Kirghiz" "Turkmen"
	"Persian" "Tajik" "Latin" "French" "Galician" "Romanian" "Norman" "Corsican"
	"Estonian" "Finnish" "Hungarian" "Bengali" "Waray" "Welsh" "Armenian" "Korean"
	"Greek" "Catalan" "Walloon" "Yiddish" "Maltese" "Romansh" "Bavarian" "Faroese"
	"Ripuarian" "Luxembourgish" "Limburgish" "Scots" "Zeelandic" "Aragonese"
	"Asturian" "Emilian-Romagnol" "Extremaduran" "Franco-Provençal" "Friulian"
	"Ladino" "Lombard" "Mirandese" "Neapolitan" "Occitan" "Picard" "Sardinian"
	"Sicilian" "Venetian" "Czech" "Rusyn" "Slovenian" "Serbian" "Slovak"
	"Silesian" "Acehnese" "Banyumasan" "Wu" "Azerbaijani" "Bashkir" "Chuvash"
	"Gagauz" "Karachay-Balkar" "Sakha" "Tatar" "Uyghur" "Uzbek" "Amharic" "Zazaki"
	"Gilaki" "Mazandarani" "Ossetian" "Pashto" "Võro" "Komi" "Vepsian" "Erzya"
	"Assamese" "Bhojpuri" "Divehi" "Konkani" "Gujarati" "Marathi" "Odia"
	"Maithili" "Sanskrit" "Sindhi" "Sinhalese" "Esperanto" "Interlingua"
	"Interlingue" "Ido" "Lithuanian" "Latvian" "Samogitian" "Kannada" "Malayalam"
	"Tamil" "Telugu" "Breton" "Irish" "Manx" "Burmese" "Georgian" "Mingrelian"
	"Lao" "Thai" "Lezgian" "Malagasy" "Papiamentu" "Chavacano" "Albanian"
	"Luganda" "Swahili" "Tswana" "Tsonga" "Yoruba" "Quechua" "Buryat" "Samoan"
	"Tongan" "Nahuatl" "Somali" "Aymara" "Guarani" "Kabyle" "Hausa" "Tetum"
	"Tulu" "Kabiye" "Maori" "Nepali" "Mongolian")

declare -a biglangs=("Dutch" "Hindi" "Danish" "Russian" "German" "Swedish"
	"Ukrainian" "Vietnamese" "Japanese" "Indonesian" "Arabic" "Hebrew" "Polish"
	"English" "Mandarin" "Spanish")

declare -a donelangs=("Basque" "Alemannic" "Wolof" "Bosnian"
	"Urdu" "Afrikaans" "Anglo-Saxon" "Icelandic" "Belarusian" "Bulgarian"
	"Croatian")

  for i in "${fullarr[@]}"
  do
    echo "$i"
    sh Scripts/wikipedia_process.sh "$i" $1
  done
