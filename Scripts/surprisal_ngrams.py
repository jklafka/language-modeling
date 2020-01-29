import sys, csv, kenlm, argparse

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Type of corpus you're working with")
parser.add_argument("language", help="Name of the language you're using")
# parser.add_argument("order", help="Order of ngram you're working with")
args = parser.parse_args()

model = kenlm.LanguageModel("Models/" + args.corpus + "/trigram/" + \
    args.language + ".klm")


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
def ngrams(sentence, n):
    tokens = sentence.split()
    if len(tokens) == 1:
        return [(sentence, 0, 1)]
    elif len(tokens) == 2:
        return [(tokens[0], 0, 2), (sentence, 1, 2)]
    else:
        ngrams = lambda a, n: zip(*[a[i:] for i in range(n)])
        joined_grams = [' '.join(grams) for grams in ngrams(tokens, n)]
        joined_grams = [tokens[0]] + [' '.join(tokens[:2])] + joined_grams
        utt_length = [len(tokens)] * len(joined_grams) # need an iterable for zip
        return list(zip(joined_grams, range(len(joined_grams)), utt_length))

# take data and turn it into ngrams
corpus = [utterance.strip('["\n]') for utterance in open("Data/" + \
    args.corpus + '/' + args.language + "_temp.txt", 'r').readlines()]

corpus = [utterance for utterance in corpus if utterance.strip() != ""]

with open("Surprisals/" + args.corpus + "/trigram/" + \
            args.language + ".csv", 'w') as f:
    writer = csv.writer(f)
    writer.writerow(['position', 'surprisal', 'length'])

    for utterance in corpus:
     # convert each utterance into a list of ngrams
        grams = ngrams(utterance, 3)
        for gram in grams:
         # then write each gram/surprisal to a separate row of the file
         # writer.writerow([gram[1], surprisal(gram[0]), gram[2], utterance_id])
            if gram[1] == 0:
                writer.writerow([gram[1] + 1, unigram_surprisal(gram[0]), gram[2]])
            elif gram[1] == 1:
                writer.writerow([gram[1] + 1, bigram_surprisal(gram[0]), gram[2]])
            else:
                writer.writerow([gram[1] + 1, trigram_surprisal(gram[0]), gram[2]])
