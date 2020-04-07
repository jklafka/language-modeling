import csv, argparse
import numpy as np
from tslearn.barycenters import dtw_barycenter_averaging

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Type of corpus you're working with")
parser.add_argument("language", help="Name of the language you're using")
parser.add_argument("gram", help="Unigram or trigram")
args = parser.parse_args()

assert args.gram in ["unigram", "trigram"], "Only accepts 'unigram' or 'trigram'"

## read in surprisals data
X = []
with open("../../Surprisals/" + args.corpus + '/' + args.gram + '/' + \
            args.language + "_compressed.csv", 'r') as f:
     reader = csv.reader(f)
     for row in reader:
         X.append(row)

# get barycenter for each size hyperparameter value as list
for BARYCENTER_SIZE in range(4, 15):
    X = [[float(item) for item in series if item != "NA"] for series in X]
    dtw_barycenter_averaging(X = X,
                    barycenter_size = BARYCENTER_SIZE,
                    verbose = True)\
                    .reshape(BARYCENTER_SIZE).tolist()
    print(BARYCENTER_SIZE)
