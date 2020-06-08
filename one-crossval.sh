#!/bin/bash
#SBATCH --job-name=crossval
#SBATCH --partition=bigmem2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --error=crossval.err
#SBATCH --mail-user=jklafka@andrew.cmu.edu
#SBATCH --mail-type=END,FAIL


sh Scripts/cross-val.sh $1 $2
