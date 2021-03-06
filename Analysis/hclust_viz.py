import argparse
import plotly.graph_objects as go # for interactive features
import plotly.figure_factory as ff
import numpy as np
import pandas as pd
## cdist_dtw does pairwise dynamic time warping on rows in a matrix
from tslearn.metrics import cdist_dtw

parser = argparse.ArgumentParser()
parser.add_argument("gram", help="Unigram or trigram barycenters to cluster on")
args = parser.parse_args()

assert args.gram in ["unigram", "trigram"], "Choose 'unigram' or 'trigram' barycenters"

# read in barycenters
barycenters = pd.read_csv("Data/5barycenters_fam.csv")
barycenters = barycenters[(barycenters["gram"] == args.gram) & \
    (barycenters["source"] == "wikipedia")]

# get the numerical barycenters
centers = barycenters.loc[:, '1':'5'].to_numpy()
languages = barycenters["language"].tolist()
families = barycenters["family"].tolist()

figure = ff.create_dendrogram(centers, orientation = "left",
                                    labels = languages, distfun = cdist_dtw,
                                    colorscale = families)
figure.update_layout(width = 800, height = 2000)
figure.show()
