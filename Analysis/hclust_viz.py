# @Author: Josef Klafka <academic>
# @Date:   2020-03-27T14:19:34-04:00
# @Email:  jlklafka@gmail.com
# @Project: Noisy-nets
# @Last modified by:   academic
# @Last modified time: 2020-03-31T14:46:03-04:00

import plotly.graph_objects as go # for interactive features
import plotly.figure_factory as ff
import numpy as np
import pandas as pd
## cdist_dtw does pairwise dynamic time warping on rows in a matrix
from tslearn.metrics import cdist_dtw

# read in barycenters
barycenters = pd.read_csv("../Data/5barycenters.csv")
barycenters = barycenters[(barycenters["gram"] == "unigram") & \
    (barycenters["source"] == "wikipedia")]

# get the numerical barycenters
centers = barycenters.loc[:, '1':'5'].to_numpy()
languages = barycenters["language"].tolist()

figure = ff.create_dendrogram(centers, orientation = "left",
                                    labels = languages, distfun = cdist_dtw)
figure.update_layout(width = 800, height = 2000)
figure.show()
