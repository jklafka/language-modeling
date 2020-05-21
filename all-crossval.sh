#!/bin/bash

## for each language
## submit a job to run cross-val for that language on a compute node with enough memory

for language in "${languages[@]}"
do
  sbatch -p bigmem one-crossval.sh wikipedia $language
