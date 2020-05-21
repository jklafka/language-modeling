#!/bin/bash
#SBATCH --job-name=
#SBATCH --error=
#SBATCH --output=
#SBATCH --mail-user=jklafka@andrew.cmu.edu
#SBATCH --mail-type=END,FAIL


sh cross-val.sh $1 $2
if no error
