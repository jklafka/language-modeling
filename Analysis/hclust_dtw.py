# @Author: Josef Klafka <academic>
# @Date:   2020-03-27T13:34:11-04:00
# @Email:  jlklafka@gmail.com
# @Project: language-modeling
# @Last modified by:   academic
# @Last modified time: 2020-03-30T09:20:26-04:00



import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tslearn.barycenters import dtw_barycenter_averaging
from tslearn.metrics import dtw
from scipy.cluster.hierarchy import linkage, dendrogram


# read in barycenters and filter to unigrams
barycenters = pd.read_csv("../Data/5barycenters.csv")
barycenters = barycenters[(barycenters["gram"] == "unigram") & \
    (barycenters["source"] == "wikipedia")]
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

# save data to file
##### FIX WRITING IN WEIRD SCIENTIFIC NOTATION
np.savetxt("linkage.txt", Z)
np.savetxt("expanded_centers.txt", expanded_centers)

languages = barycenters["language"].tolist()
with open("languages.txt", 'w') as language_file:
    for language in languages:
        language_file.write("%s\n" % language)
