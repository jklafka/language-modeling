import csv, argparse
import numpy as np
from tslearn.barycenters import dtw_barycenter_averaging
from tslearn.metrics import dtw

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Type of corpus you're working with")
parser.add_argument("language", help="Name of the language you're using")
parser.add_argument("gram", help="Unigram or trigram")
args = parser.parse_args()

assert args.gram in ["unigram", "trigram"], "Only accepts 'unigram' or 'trigram'"

## read in surprisals data
compression_costs = np.zeros((10,15))

for split in range(1,11):
    X = []
    Y = []
    with open("../../ValSurprisals/" + args.corpus + '/' + args.gram + '/' + \
                args.language + "_training" + str(split) + ".csv", 'r') as f:
         reader = csv.reader(f)
         for row in reader:
             X.append(row[1:])

    with open("../../ValSurprisals/" + args.corpus + '/' + args.gram + '/' + \
                    args.language + "_test" + str(split) + ".csv", 'r') as f:
             reader = csv.reader(f)
             for row in reader:
                 Y.append(row[1:])

    # get barycenter for each size hyperparameter value as list
    for BARYCENTER_SIZE in range(1, 16):
        X = [[float(item) for item in series if item != "NA"] for series in X]
        Y = [[float(item) for item in series if item != "NA"] for series in Y]

        barycenter = dtw_barycenter_averaging(X = X, barycenter_size = BARYCENTER_SIZE)

        total_dtw_dist = 0
        for element in Y:
            total_dtw_dist += dtw(barycenter, element)

        compression_costs[split-1, BARYCENTER_SIZE-1] = total_dtw_dist

np.savetxt("costs/" + args.corpus + '/' + args.gram + '/' + \
            args.language + "dtw_dists.csv", compression_costs, delimiter=",")
