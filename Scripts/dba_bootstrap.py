import csv, argparse, random
import numpy as np
from tslearn.barycenters import dtw_barycenter_averaging

BARYCENTER_SIZE = 5
OUTPUT_FILE = "Data/sbc_weighted_barycenters.csv"

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Type of corpus you're working with")
parser.add_argument("language", help="Name of the language you're using")
parser.add_argument("gram", help="Unigram or trigram")
args = parser.parse_args()

assert args.gram in ["unigram", "trigram"], "Only accepts 'unigram' or 'trigram'"

# read in surprisals data
X = dict()
weights = dict()
with open("Surprisals/" + args.corpus + '/' + args.gram + '/' + \
            args.language + "_compressed.csv", 'r') as f:
     reader = csv.reader(f)
     for row in reader:
         if row[0] not in X:
             X[row[0]] = [row[2:]]
             weights[row[0]] = [int(row[1])]
         else:
             X[row[0]].append(row[2:])
             weights[row[0]].append(int(row[1]))

# get barycenter of info-curves as list
for key in X:
    data = [[float(item) for item in series if item != ''] for series in X[key]]

    barycenter = dtw_barycenter_averaging(X = data,
                    barycenter_size = BARYCENTER_SIZE,
                    weights = np.array(weights[key])).reshape(BARYCENTER_SIZE).tolist()
    barycenter += [args.language, args.corpus, args.gram, key]

    # output barycenter to
    with open(OUTPUT_FILE, 'a') as f:
        writer = csv.writer(f)
        writer.writerow(barycenter)
