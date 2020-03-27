# @Author: Josef Klafka <academic>
# @Date:   2020-03-27T13:34:11-04:00
# @Email:  jlklafka@gmail.com
# @Project: Noisy-nets
# @Last modified by:   academic
# @Last modified time: 2020-03-27T14:09:04-04:00



import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tslearn.barycenters import dtw_barycenter_averaging
from tslearn.metrics import dtw
from scipy.cluster.hierarchy import linkage, dendrogram


# read in barycenters and filter to unigrams
barycenters = pd.read_csv("../Data/5barycenters.csv")
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

## plot entire dendrogram
plt.figure(figsize = (50, 20), dpi = 100)
dendro = dendrogram(Z, labels = languages.to_numpy())
plt.savefig("dendro.png")
