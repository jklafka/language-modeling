#!/bin/bash


python3 get_all_costs.py $1 $2 $3 > all_costs.txt

# grep commands that wrangle the final cost for each barycenter into costs.txt
## find every line that's just a number: get that line and the one before it
## now take only the final decimal number and the following integer
cat all_costs.txt |
  grep -B 1 -E '^\d' |
  grep -o -A 1 -E '0\.\d+' > costs.txt

python3 costs_plotting.py --plotting=True
