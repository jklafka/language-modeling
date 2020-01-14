import csv, sys, subprocess
import regex as re


def extract_texts(upper_bound):
    '''
    Given an upper_bound on file numbers, extracts the raw text from the files
    in the text/AA folder (produced by cirrus-extract).
    '''
    rs = ""
    for i in range(upper_bound):
        if i < 10:
            number = "0" + str(i)
        else:
            number = str(i)
        f = open("text/AA/wiki_" + number, 'r')
        text = f.read()
        rs += text
    return rs


def main(lang_name):
    '''
    Main workhorse function
    '''
    # find the number of article files we want to combine
    directory_names = subprocess.check_output(["ls", "text"]).decode("utf-8")\
                                .split('\n')[:-1]
    all_sentences = []
    for name in directory_names:
        directory = subprocess.check_output(["ls", "text/" + name]).decode("utf-8")
        highest_filenum = max(int(max(re.findall("\d\d", directory))), 1)
        upper_bound = min(highest_filenum, 99)

        # get all of the sentences from the files
        text = extract_texts(upper_bound)
        sentences = [sentence for article in text.split('\n') \
                    for sentence in article.split('.')]
        for sentence in sentences:
            all_sentences.append(sentence)

    with open("Data/wiki/" + lang_name + ".txt", 'w') as f:
        for sentence in all_sentences:
            f.write("%s\n" % sentence)


if __name__ == "__main__":
    main(sys.argv[1]) # takes the English name of a language as sole argument
