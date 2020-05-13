import csv
import numpy as np
import pandas as pd
from tslearn.barycenters import dtw_barycenter_averaging

## within gram
X = []
with open("Data/5barycenters.csv", 'r') as f:
     reader = csv.reader(f)
     for row in reader:
         X.append(row)

## split X into unigram and trigram
unigrams = [series[:5] for series in X if series[-2] == "wikipedia" and \
                                        series[-1] == "unigram"]
trigrams = [series[:5] for series in X if series[-2] == "wikipedia" and \
                                        series[-1] == "trigram"]

unigram_barycenter = dtw_barycenter_averaging(X = unigrams,
                verbose = True).reshape(5).tolist()
trigram_barycenter = dtw_barycenter_averaging(X = trigrams,
                verbose = True).reshape(5).tolist()

## within
X = pd.read_csv("Data/5barycenters_fam.csv")
