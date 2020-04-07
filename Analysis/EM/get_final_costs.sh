#!/bin/bash

# python3 em_optimization.py adult sbc unigram > all_costs.txt
## find every line that's just a number: get that line and the one before it
## now take only the final decimal number and the following integer
cat all_costs.txt |
  grep -B 1 -E '^\d' |
  grep -o -A 1 -E '0\.\d+' > costs.txt
