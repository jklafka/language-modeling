import json, sys, subprocess, csv
import urllib.request
import regex as re

with open("../language_dict.json", 'r') as f:
    file = f.read()
LANG_DICT = json.loads(file) #maps languages to their wikipedia url prefixes


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
    # get the Wikipedia dump file from the internet
    lang_prefix = LANG_DICT[lang_name]
    url = "https://dumps.wikimedia.org/other/cirrussearch/20190923/" + lang_prefix + \
        "wiki-20190923-cirrussearch-content.json.gz"
    urllib.request.urlretrieve(url, "datafile") #"Data/Files/" + lang_name + "_file")
    subprocess.call(["python3", "cirrus-extract.py", \
                    "datafile"])
                    #"Data/Files/" + lang_name + "_file"])

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

    with open(lang_name + "_df.csv", 'w') as f:
        writer = csv.writer(f)
        for sentence in all_sentences:
            writer.writerow([sentence])

    # delete the text files and datafile
    # may be several gigabytes large
    subprocess.call(["rm", "-r", "text"])
    subprocess.call(["rm", "datafile"])

if __name__ == "__main__":
    main(sys.argv[1]) # takes the English name of a language as sole argument
