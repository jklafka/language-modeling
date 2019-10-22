#!/bin/bash

declare -a fullarr=("English" "Mandarin")

  for i in "${fullarr[@]}"
  do
    echo "$i"
    sh Scripts/wikipedia_process.sh "$i" $1
  done
