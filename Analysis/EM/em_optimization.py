import csv, argparse, subprocess
import numpy as np
import matplotlib.pyplot as plt
from tslearn.barycenters import dtw_barycenter_averaging

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Type of corpus you're working with")
parser.add_argument("language", help="Name of the language you're using")
parser.add_argument("gram", help="Unigram or trigram")
parser.add_argument("--plotting", help="Whether to display the plot")
args = parser.parse_args()

assert args.gram in ["unigram", "trigram"], "Only accepts 'unigram' or 'trigram'"
args.plotting = False if args.plotting is None else args.plotting = True

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

# grep commands that wrangle the final cost for each barycenter into costs.txt
subprocess.call(["sh", "get_final_costs.sh"])

costs = open("costs.txt", 'r').read().splitlines()
costs = ' '.join(costs).split("--")
costs = [item.strip(' ').split() for item in costs]
costs = [(int(barycenter_size), float(final_cost)) \
            for final_cost, barycenter_size in costs]

if args.plotting is True:
    fig = plt.figure()
    plt.plot([cost[0] for cost in costs], [cost[1] for cost in costs])
    plt.xlabel("Barycenter size")
    plt.ylabel("Final cost")
    plt.show()
