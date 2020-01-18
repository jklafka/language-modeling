from tslearn.barycenters import dtw_barycenter_averaging
import csv
import numpy as np

BARYCENTER_SIZE = 10

## read in surprisals data
X = []
with open("guja.csv", 'r') as f:
     reader = csv.reader(f)
     for row in reader:
         X.append(row)
## delete column names
del X[0]

## get barycenter of info-curves as list
X = [[float(item) for item in series if item != "NA"] for series in X]
barycenter = dtw_barycenter_averaging(X, BARYCENTER_SIZE)\
                .reshape(BARYCENTER_SIZE).tolist()

with open("barycenter.csv", 'w') as f:
    writer = csv.writer(f)
    writer.writerows(barycenter)
