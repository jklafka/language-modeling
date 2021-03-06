import csv, argparse, random
import numpy as np
from tslearn.barycenters import dtw_barycenter_averaging

BARYCENTER_SIZE = 7
OUTPUT_FILE = "Data/7crossval_barycenters.csv"

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Type of corpus you're working with")
parser.add_argument("language", help="Name of the language you're using")
parser.add_argument("gram", help="Unigram or trigram")
args = parser.parse_args()

assert args.gram in ["unigram", "trigram"], "Only accepts 'unigram' or 'trigram'"

# read in surprisals data
X = []
weights = []
with open("ValSurprisals/" + args.corpus + '/' + args.gram + '/' + \
            args.language + "_compressed.csv", 'r') as f:
     reader = csv.reader(f)
     for row in reader:
         X.append(row[1:])
         weights.append(int(row[0]))

# get barycenter of info-curves as list
data = [[float(item) for item in series if item != "NA"] for series in X]

barycenter = dtw_barycenter_averaging(X = data,
                barycenter_size = BARYCENTER_SIZE,
                weights = np.array(weights)).reshape(BARYCENTER_SIZE).tolist()
barycenter += [args.language, args.corpus, args.gram]

# output barycenter to
with open(OUTPUT_FILE, 'a') as f:
    writer = csv.writer(f)
    writer.writerow(barycenter)
# X = []
# with open("ValSurprisals/" + args.corpus + '/' + args.gram + '/' + \
#             args.language + "_compressed.csv", 'r') as f:
#      reader = csv.reader(f)
#      for row in reader:
#          X.append(row)
#
# # get barycenter of info-curves as list
# data = [[float(item) for item in series if item != "NA"] for series in X]
#
# barycenter = dtw_barycenter_averaging(X = data,
#                 barycenter_size = BARYCENTER_SIZE).reshape(BARYCENTER_SIZE).tolist()
# barycenter += [args.language, args.corpus, args.gram]
#
# # output barycenter to
# with open(OUTPUT_FILE, 'a') as f:
#     writer = csv.writer(f)
#     writer.writerow(barycenter)
