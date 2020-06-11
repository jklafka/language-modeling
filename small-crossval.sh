#!/bin/bash
#SBATCH --job-name=crossval
#SBATCH --error=crossval.err
#SBATCH --mail-user=jklafka@andrew.cmu.edu
#SBATCH --mail-type=END,FAIL


sh Scripts/cross-val.sh $1 $2
