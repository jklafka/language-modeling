import sys, csv, kenlm, argparse

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Name of the corpus you're using in the corpus folder")
args = parser.parse_args()

# get model
model = kenlm.LanguageModel("Models/corpus_" + args.corpus + ".klm")

# gets surprisal from string based on the model's stored probabilities
def surprisal(s):
    return -model.score(s)

# get ngrams from a string
# returns list of (gram, gram position and length of utterance) tuples
def ngrams(s, n):
    tokens = s.split()
    ngrams = lambda a, n: zip(*[a[i:] for i in range(n)])
    joined_grams = [' '.join(grams) for grams in ngrams(tokens, n)]
    utt_length = [len(tokens)] * len(joined_grams) # need an iterable for zip
    return list(zip(joined_grams, range(len(joined_grams)), utt_length))

# take data and turn it into ngrams
corpus = [utterance.strip('["\n]') for utterance in open("Data/corpus/" + \
    args.corpus + ".txt", 'r').readlines()][1:]
corpus = [utterance for utterance in corpus if utterance != ""]
corpus_ngrams = [gram for s in corpus for gram in ngrams(s, 3)]

# get all the utterance length we're working with
lengths = list({gram[2] for gram in corpus_ngrams})
results = []

# filter by length and get average surprisal for each gram position
for length in lengths:
    length_ngrams = list(filter(lambda x: x[2] == length, corpus_ngrams))
    max_ngram = max(length_ngrams, key = lambda x: x[1])[1]

    for j in range(max_ngram):
        jth_ngrams = list(filter(lambda x: x[1] == j, length_ngrams))
        sum = 0
        for x in jth_ngrams:
            sum += surprisal(x[0])
        sum /= len(jth_ngrams)
        results.append((j, sum, length))

# write results
with open("Data/corpus/" + args.corpus + "_results.csv", 'w') as f:
    writer = csv.writer(f)
    for line in results:
        writer.writerow(line)
