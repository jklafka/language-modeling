import csv
import numpy as np
import pandas as pd
from tslearn.barycenters import dtw_barycenter_averaging
from tslearn.metrics import dtw

# with open("Data/5barycenters.csv", 'r') as barycenters_file:
#     reader = csv.reader(f)
#     for line in reader

barycenters = pd.read_csv("Data/5barycenters.csv")
## COMPUTE PAIRWISE DTW AND STORE
## HOW TO STORE PAIRWISE DISTANCES
## FIND CLOSEST PAIRS
## COMPUTE BARYCENTERS AND STORE
## ITERATE
