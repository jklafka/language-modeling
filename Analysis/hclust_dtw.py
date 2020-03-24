import numpy as np
import pandas as pd
from tslearn.barycenters import dtw_barycenter_averaging
from tslearn.metrics import dtw
from scipy.cluster.hierarchy import linkage, dendrogram

# with open("Data/5barycenters.csv", 'r') as barycenters_file:
#     reader = csv.reader(f)
#     for line in reader

# read in barycenters and filter to unigrams
barycenters = pd.read_csv("Data/5barycenters.csv")
barycenters = barycenters[barycenters["gram"] == "unigram"]
# fetch languages
languages = barycenters["language"].copy()
# get the numerical barycenters
centers = barycenters.loc[:, '1':'5'].to_numpy()

# linkage is the workhorse: it produces an array with pairwise clusters in the
# first two columns, then the distance in the third column, then the number of
# members of the created cluster in the fourth column
Z = linkage(centers, method = "single", metric = dtw)

expanded_centers = centers.copy()

for row in Z:
    cluster = np.vstack([expanded_centers[int(row[0])], expanded_centers[int(row[1])]])
    new_center = dtw_barycenter_averaging(cluster)
    expanded_centers = np.vstack((expanded_centers, new_center.T))
## HOW TO MAP BETWEEN LOCATION ON CLUSTERING PLOT AND BARYCENTER OR LEAF NODE??
## INTERACTIVE PLOT??
