import requests
import regex as re
from bs4 import BeautifulSoup

# grab the html from the dumps page and parse it
dumps_page = requests.get("https://dumps.wikimedia.org/other/cirrussearch/current/")
dumps_content = dumps_page.content
dumps_soup = BeautifulSoup(dumps_content, "html.parser")
# get the first full wiki link with the date in it
dumps_name = dumps_soup.find_all('a')[1].get_text()
dumps_date = re.findall("\d+", dumps_name)[0]
print(dumps_date)
