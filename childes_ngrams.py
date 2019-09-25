import sys
import kenlm

model = kenlm.LanguageModel('childes.klm')
def surprisal(s):
    return -model.score(s)

def ngrams(s, n):
    tokens = s.split()
    ngrams = lambda a, n: zip(*[a[i:] for i in range(n)])
    joined_grams = [' '.join(grams) for grams in ngrams(tokens, n)]
    return list(zip(joined_grams, range(len(joined_grams))))

childes = [utterance.strip('["\n]') for utterance in open("childes.txt", 'r')\
    .readlines()][1:]
childes = [utterance for utterance in childes if utterance != ""]
childes_ngrams = [ngrams(s, 3) for s in childes]
max_ngram = max(childes_ngrams, lambda x: x[1])[1]

results = []
for j in range(max_ngram):
    jth_ngrams = filter(lambda x: x[1] == j, childes_ngrams)
    sum = 0
    for x in jth_ngrams:
        sum += surprisal(x[0])
    sum /= len(jth_ngrams)
    results.append((j, sum))
print(results)
