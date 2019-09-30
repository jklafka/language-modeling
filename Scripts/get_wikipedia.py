import json
import urllib.request
import subprocess
import sys

with open("../language_dict.json", 'r') as f:
    file = f.read()
LANG_DICT = json.loads(file) #maps languages to their wikipedia url prefixes

def main(lang_name):

    lang_prefix = LANG_DICT[lang_name]
    # url = "https://dumps.wikimedia.org/other/cirrussearch/20190923/" + lang_prefix + \
    #     "wiki-20190923-cirrussearch-content.json.gz"
    # urllib.request.urlretrieve(url, "datafile") #"Data/Files/" + lang_name + "_file")
    subprocess.call(["python3", "cirrus-extract.py", \
                    "datafile"])
                    #"Data/Files/" + lang_name + "_file"])

if __name__ == "__main__":
    main(sys.argv[1]) # takes the English name of a language as sole argument
