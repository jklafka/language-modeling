import csv
import numpy as np
from tslearn.barycenters import dtw_barycenter_averaging

## python3 Scripts/dba_family.py > family_losses.txt

BARYCENTER_SIZE = 5

grams = ["unigram", "trigram"]

# read in surprisals data
X = []
families = []
genii = []
with open("Data/families_barycenters.csv", 'r') as f:
     reader = csv.reader(f)
     for row in reader:
         X.append(row)
         families.append(row[-2])
         genii.append(row[-1])

families = list(set(families))
genii = list(set(genii))

# get barycenter of info-curves as list
family_barycenters = []
genus_barycenters = []

for family in families:
    for gram in grams:
        print("family", family, gram)
        data = [row[:5] for row in X if row[-2] == family and row[-3] == gram]
        data = [[float(item) for item in series if item != "NA"] for series in data]

        data =  [[el - sum(row) / len(row) for el in row] for row in data]

        if data != []:
            barycenter = dtw_barycenter_averaging(X = data,
                            barycenter_size = BARYCENTER_SIZE,
                            verbose = True).reshape(BARYCENTER_SIZE).tolist()
            barycenter += [family, gram]
            family_barycenters.append(barycenter)

for genus in genii:
    for gram in grams:
        print("genus", genus, gram)
        data = [row[:5] for row in X if row[-1] == genus and row[-3] == gram]
        data = [[float(item) for item in series if item != "NA"] for series in data]

        data =  [[el - sum(row) / len(row) for el in row] for row in data]

        if data != []:
            barycenter = dtw_barycenter_averaging(X = data,
                            barycenter_size = BARYCENTER_SIZE,
                            verbose = True).reshape(BARYCENTER_SIZE).tolist()
            barycenter += [genus, gram]
            genus_barycenters.append(barycenter)

# output barycenter to
with open("Data/by_family_barycenters.csv", 'w') as f:
    writer = csv.writer(f)
    writer.writerow([1,2,3,4,5,"family","gram"])
    writer.writerows(family_barycenters)

with open("Data/by_genus_barycenters.csv", 'w') as f:
    writer = csv.writer(f)
    writer.writerow([1,2,3,4,5,"genus","gram"])
    writer.writerows(genus_barycenters)
