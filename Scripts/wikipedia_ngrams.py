import kenlm
import csv, argparse

parser = argparse.ArgumentParser()
parser.add_argument("lang_name", help="Name of the language collection you're using from CHILDES")
args = parser.parse_args()
lang_name = args.lang_name

# get model
model = kenlm.LanguageModel("Models/" + lang_name + ".klm")

# gets surprisal from string based on the model's stored probabilities
def surprisal(s):
    return -model.score(s)

# get ngrams from a string
# returns list of (ngram, ngram position and length of utterance) tuples
def ngrams(s, n):
    tokens = s.split()
    ngrams = lambda a, n: zip(*[a[i:] for i in range(n)])
    joined_grams = [' '.join(grams) for grams in ngrams(tokens, n)]
    utt_length = [len(tokens)] * len(joined_grams) # need an iterable for zip
    return list(zip(joined_grams, range(len(joined_grams)), utt_length))

# take data and turn it into ngrams
wikipedia = [utterance.strip('["\n]') for utterance in open(lang_name + ".txt", 'r')\
    .readlines()][1:]
wikipedia = [utterance for utterance in wikipedia if utterance != ""]
wikipedia_ngrams = [gram for utt in wikipedia for gram in ngrams(utt, 3)]

results = []
for gram in wikipedia_ngrams:
    results.append([gram[1], surprisal(gram[0]), gram[2]])

# # get all the utterance length we're working with
# lengths = list({gram[2] for gram in childes_ngrams})
# results = []

# # filter by length and get average surprisal for each gram position
# for length in lengths:
#     length_ngrams = list(filter(lambda x: x[2] == length, childes_ngrams))
#     max_ngram = max(length_ngrams, key = lambda x: x[1])[1]
#
#     for j in range(max_ngram):
#         jth_ngrams = list(filter(lambda x: x[1] == j, length_ngrams))
#         sum = 0
#         for ngram in jth_ngrams:
#             sum += surprisal(ngram[0])
#         sum /= len(jth_ngrams)
#         results.append((j, sum, length))

# # add in sentence ids
# wikipedia = list(zip(wikipedia, range(1, len(wikipedia))))
# wikipedia_ngrams = [list(gram) + [utt[1]] for utt in wikipedia for gram in ngrams(utt[0], 3)]
# results = []
# for gram in wikipedia_ngrams:
#     results.append([gram[1], surprisal(gram[0]), gram[2], gram[3]])

# write results
with open("Data/wikipedia_" + lang_name + ".csv", 'w') as f:
    writer = csv.writer(f)
    for line in results:
        writer.writerow(line)
