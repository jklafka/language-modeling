import sys, csv, kenlm, argparse

parser = argparse.ArgumentParser()
parser.add_argument("corpus", help="Type of corpus you're working with")
parser.add_argument("language", help="Name of the language you're using")
# parser.add_argument("order", help="Order of ngram you're working with")
args = parser.parse_args()

# assert args.order in ["unigram", "trigram"], "enter unigram or trigram order"

# # get model
# if args.order == "unigram":
#     model = kenlm.LanguageModel("Models/" + args.corpus + '/' + args.order + \
#         '/' + args.language + ".klm")

# elif args.order == "trigram":
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
        return [(tokens[0], 0, 2), (s, 1, 2)]
    else:
        ngrams = lambda a, n: zip(*[a[i:] for i in range(n)])
        joined_grams = [' '.join(grams) for grams in ngrams(tokens, n)]
        joined_grams = [tokens[0]] + [' '.join(tokens[:2])] + joined_grams
        return list(zip(joined_grams, range(len(joined_grams))))

# take data and turn it into ngrams
corpus = [utterance.strip('["\n]') for utterance in open("Data/corpus/" + \
    args.corpus + ".txt", 'r').readlines()]

corpus = [utterance for utterance in corpus if utterance.strip() != ""]

    # much less memory-intensive surprisal computation process
    # utterance_id = 0
    with open("Surprisals/" + args.corpus + "/trigram/" + \
                args.language + ".csv", 'r') as f:
        writer = csv.writer(f)
        for utterance in corpus:
            # convert each utterance into a list of ngrams
            grams = ngrams(utterance, 3)
            for gram in grams:
                # write each sentence as a row of surprisals
                sups = []
                if gram[1] == 0:
                    sups.append(unigram_surprisal(gram[0]))
                elif gram[1] == 1:
                    sups.append(bigram_surprisal(gram[0]))
                else:
                    sups.append(trigram_surprisal(gram[0]))
                writer.writerow([sups])
