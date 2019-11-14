import kenlm
import csv, argparse

parser = argparse.ArgumentParser()
parser.add_argument("lang_name", help="Name of the language collection you're using from CHILDES")
args = parser.parse_args()
lang_name = args.lang_name


# gets surprisal from string based on the model's stored probabilities
def unigram_surprisal(s):
    return -model.score(s, eos=False)

def bigram_surprisal(s):
    return -model.score(s, eos=False) + \
        model.score(s.split()[0], eos=False)

def trigram_surprisal(s):
    return -model.score(s, bos=False, eos=False) + \
        model.score(' '.join(s.split()[:2]), bos=False, eos=False)

# get ngrams from a string
# returns list of (gram, gram position and length of utterance) tuples
def ngrams(s, n):
    tokens = s.split()
    if len(tokens) == 1:
        return [(s, 0, 1)]
    else:
        ngrams = lambda a, n: zip(*[a[i:] for i in range(n)])
        joined_grams = [' '.join(grams) for grams in ngrams(tokens, n)]
        if joined_grams != []:
            joined_grams = [tokens[0]] + [' '.join(tokens[:2])] + joined_grams
            utt_length = [len(tokens)] * len(joined_grams) # need an iterable for zip
            return list(zip(joined_grams, range(len(joined_grams)), utt_length))

# get model
model = kenlm.LanguageModel("Models/" + lang_name + ".klm")

# take data and turn it into ngrams
wikipedia = [utterance.strip('["\n]') for utterance in open(lang_name + ".txt", 'r')\
    .readlines()][1:]
wikipedia = [utterance for utterance in wikipedia if utterance != ""]
# much less memory-intensive surprisal computation process
# utterance_id = 0
with open("Data/wikipedia_" + lang_name + ".csv", 'w') as f:
    writer = csv.writer(f)

    writer.writerow(['position', 'surprisal', 'length'])

    for utterance in wikipedia:
        # convert each utterance into a list of ngrams
        grams = ngrams(utterance, 3)
        if grams is not None:
            for gram in grams:
                # then write each gram/surprisal to a separate row of the file
                # writer.writerow([gram[1], surprisal(gram[0]), gram[2], utterance_id])
                if gram[1] == 0:
                    writer.writerow([gram[1] + 1, unigram_surprisal(gram[0]), gram[2]])
                elif gram[1] == 1:
                    writer.writerow([gram[1] + 1, bigram_surprisal(gram[0]), gram[2]])
                else:
                    writer.writerow([gram[1] + 1, trigram_surprisal(gram[0]), gram[2]])
