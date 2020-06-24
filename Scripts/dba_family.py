import csv
import numpy as np
from tslearn.barycenters import dtw_barycenter_averaging

## python3 Scripts/dba_family.py > family_losses.txt

BARYCENTER_SIZE = 5

grams = ["unigram", "trigram"]

# read in surprisals data
X = []
# genealogy is a dict mapping families to lists of genii
genealogy = {}

with open("Data/families_barycenters.csv", 'r') as f:
     reader = csv.reader(f)
     for row in reader:
         X.append(row)
         if row[-2] not in genealogy:
             genealogy[row[-2]] = []
         genealogy[row[-2]].append(row[-1])
# get unique genii
genealogy = {family : list(set(genii)) for family, genii in genealogy.items()}
barycenters = []

for gram in grams:
    ## create gram mean barycenter
    data = [row[:5] for row in X if row[-3] == gram]
    data = [[float(item) for item in series] for series in data]

    data =  [[el - sum(row) / len(row) for el in row] for row in data]

    if data != []:
        barycenter = dtw_barycenter_averaging(X = data,
                        barycenter_size = BARYCENTER_SIZE,
                        verbose = True).reshape(BARYCENTER_SIZE).tolist()
        barycenter += ["mean", "mean", gram]
        barycenters.append(barycenter)

    for family in genealogy:
        ## create family mean barycenter
        # print("family", family, gram)
        data = [row[:5] for row in X if row[-2] == family and row[-3] == gram]
        data = [[float(item) for item in series] for series in data]

        data =  [[el - sum(row) / len(row) for el in row] for row in data]

        if data != []:
            barycenter = dtw_barycenter_averaging(X = data,
                            barycenter_size = BARYCENTER_SIZE,
                            verbose = True).reshape(BARYCENTER_SIZE).tolist()
            barycenter += [family, "mean", gram]
            barycenters.append(barycenter)

        for genus in genealogy[family]:
            ## create genus mean barycenter
            data = [row[:5] for row in X if row[-1] == genus and row[-3] == gram]
            data = [[float(item) for item in series] for series in data]

            data =  [[el - sum(row) / len(row) for el in row] for row in data]

            if data != []:
                barycenter = dtw_barycenter_averaging(X = data,
                                barycenter_size = BARYCENTER_SIZE,
                                verbose = True).reshape(BARYCENTER_SIZE).tolist()
                barycenter += [family, genus, gram]
                barycenters.append(barycenter)


# output barycenter to
with open("Data/genealogy_barycenters.csv", 'w') as f:
    writer = csv.writer(f)
    writer.writerow([1,2,3,4,5,"family", "genus", "gram"])
    writer.writerows(barycenters)
