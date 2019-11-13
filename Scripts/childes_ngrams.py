import sys, csv, kenlm, argparse

option = "wikipedia"

parser = argparse.ArgumentParser()
parser.add_argument("lang_name", help="Name of the language collection you're using from CHILDES")
parser.add_argument("speaker", help="Are we looking at parent or child speech")
args = parser.parse_args()

lang_name = args.lang_name
speaker = args.speaker

# get model
model = kenlm.LanguageModel("Models/childes_" + lang_name + '_' + speaker + ".klm")

# gets surprisal from string based on the model's stored probabilities
def backoff_surprisal(s):
    return -model.score(s, bos=True, eos=False)

def trigram_surprisal(s):
    return -model.score(s, bos=False, eos=False)

# get ngrams from a string
# returns list of (gram, gram position and length of utterance) tuples
def ngrams(s, n):
    tokens = s.split()
    ngrams = lambda a, n: zip(*[a[i:] for i in range(n)])
    joined_grams = [' '.join(grams) for grams in ngrams(tokens, n)]
    joined_grams = [tokens[0]] + [' '.join(tokens[:2])] + joined_grams
    utt_length = [len(tokens)] * len(joined_grams) # need an iterable for zip
    return list(zip(joined_grams, range(len(joined_grams)), utt_length))

# take data and turn it into ngrams
childes = [utterance.strip('["\n]') for utterance in open("Data/childes_" + lang_name + '_' + speaker + ".txt", 'r')\
    .readlines()][1:]

if option == "childes":
    childes = [utterance for utterance in childes if utterance != ""]
    childes_ngrams = [gram for s in childes for gram in ngrams(s, 3)]

    # get all the utterance length we're working with
    lengths = list({gram[2] for gram in childes_ngrams})
    results = []

    # filter by length and get average surprisal for each gram position
    for length in lengths:
        length_ngrams = list(filter(lambda x: x[2] == length, childes_ngrams))
        max_ngram = max(length_ngrams, key = lambda x: x[1])[1]

        for j in range(max_ngram):
            jth_ngrams = list(filter(lambda x: x[1] == j, length_ngrams))
            sum = 0
            for x in jth_ngrams:
                sum += surprisal(x[0])
            sum /= len(jth_ngrams)
            results.append((j, sum, length))

    # write results
    with open("Data/" + lang_name + '_' + speaker + "_results.csv", 'w') as f:
        writer = csv.writer(f)
        for line in results:
            writer.writerow(line)

elif option == "wikipedia":
    # much less memory-intensive surprisal computation process
    # utterance_id = 0
    with open("Data/childes_" + lang_name + '_' + speaker + ".csv", 'a') as f:
        writer = csv.writer(f)
        for utterance in childes:
            if utterance != "":
                # convert each utterance into a list of ngrams
                grams = ngrams(utterance, 3)
                for gram in grams:
                    # then write each gram/surprisal to a separate row of the file
                    # writer.writerow([gram[1], surprisal(gram[0]), gram[2], utterance_id])
                    if gram[1] < 2:
                        writer.writerow([gram[1] + 1, backoff_surprisal(gram[0]), gram[2]])
                    else:
                        writer.writerow([gram[1] + 1, trigram_surprisal(gram[0]), gram[2]])
                # utterance_id += 1
