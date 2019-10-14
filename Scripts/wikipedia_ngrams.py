import kenlm
import csv, argparse

parser = argparse.ArgumentParser()
parser.add_argument("lang_name", help="Name of the language collection you're using from CHILDES")
args = parser.parse_args()
lang_name = args.lang_name


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


# get model
model = kenlm.LanguageModel("Models/" + lang_name + ".klm")

# take data and turn it into ngrams
wikipedia = [utterance.strip('["\n]') for utterance in open(lang_name + ".txt", 'r')\
    .readlines()][1:]

# much less memory-intensive surprisal computation process
with open("Data/wikipedia_" + lang_name + ".csv", 'a') as f:
    writer = csv.writer(f)
    for utterance in wikipedia:
        if utterance != "":
            # convert each utterance into a list of ngrams
            grams = ngrams(utterance, 3)
            for gram in grams:
                #then write each gram/surprisal to a separate row of the file
                writer.writerow([gram[1], surprisal(gram[0]), gram[2]])
