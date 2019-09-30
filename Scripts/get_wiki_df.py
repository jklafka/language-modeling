import regex as re
import numpy as np
import pandas as pd
import csv
import sys
import json
import subprocess
import urllib.request


with open("language_dict.json", 'r') as f:
	file = f.read()
LANG_DICT = json.loads(file) #maps languages to their wikipedia url prefixes


def extract_texts(upper_bound):
	'''
	Given an upper_bound on file numbers, extracts the raw text from the files
	in the text/AA folder. That folder is given as output by the
	cirrus_extract program.
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


def get_sen_dict(text):
	'''
	Given the output of extract_texts as a string, constructs a
	dictionary mapping each sentence in the string to its length in words.
	'''
	text = re.sub("<doc.+>|</doc>|http:\S+|[-%,;:–'&*#/—“»]|\d+|\(|\)|\[|\]", \
		"", text)
	text = re.sub('"', '', text)
	#just the words from the articles
	text = text.replace('\n', " ")
	sens = re.split("[.!?]", text.lower())
	sen_dict = {}
	for sen in sens:
		length = len(re.findall("\w+", sen))
		if length > 0:
			sen_dict[sen] = length
	return sen_dict


def get_sen_df(text):
	'''
	Given the output of extract_texts as a string, returns a Pandas dataframe
	of the output of get_sen_dict.
	'''
	sd = get_sen_dict(text)
	s = pd.Series(sd, name = "length")
	del sd
	s.index.name = "gloss"
	df = s.reset_index() #gives a dataframe with columns "sentence" and "length" containing the sentence
					 	  #and the sentence length respectively
	return df


def main(lang_name):
	'''
	Given the English name of a language, constructs a dataframe with the
	sentences of a random subset of articles in that language from Wikipedia,
	and stores the dataframe in a csv in the working directory.
	'''
	lang_prefix = LANG_DICT[lang_name]
	url = "https://dumps.wikimedia.org/other/cirrussearch/20190520/" + \
		lang_prefix + "wiki-20190520-cirrussearch-content.json.gz"
	urllib.request.urlretrieve(url, "datafile")
	subprocess.call(["wiki_extract/cirrus_extract.py", "datafile"])

	all_dfs = pd.DataFrame(columns = ["gloss", "length"])
	# find the number of article files we want to combine
	directory_names = subprocess.check_output(["ls", "text"]).decode("utf-8").split('\n')[:-1]
	for name in directory_names:
		directory = subprocess.check_output(["ls", "text/" + name]).decode("utf-8")
		highest_filenum = max(int(max(re.findall("\d\d", directory))), 1)
		upper_bound = min(highest_filenum, 99)

		# construct the df
		text = extract_texts(upper_bound)
		df = get_sen_df(text)
		all_dfs = pd.concat([all_dfs, df])

	all_dfs.to_csv("wiki_df.csv", index = False)

	# delete the text files and datafile
	# may be several gigabytes large
	subprocess.call(["rm", "-r", "text"])
	subprocess.call(["rm", "datafile"])


if __name__ == "__main__":
	main(sys.argv[1]) # takes the English name of a language as sole argument
