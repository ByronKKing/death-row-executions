# -*- coding: utf-8 -*-
"""

Script to clean data from Texas CJ Site and scrape data 
from last statements

"""

# import packages

from bs4 import BeautifulSoup as bs
import requests
import urllib.parse as ulp
import urllib.request as ulr
import pandas as pd

# define functions to open beautiful soup object

def get_soup(url):
    return spoof_open_bs(url)

def spoof_open_bs(url):
    opener = ulr.build_opener()
    opener.addheaders = [('User-Agent', 'Mozilla/5.0')]
    return bs(opener.open(url).read(), "lxml")

# read in dataset

deathset = pd.DataFrame(pd.read_csv("/Users/Evan/Desktop/Deathset.csv"))
dslinks = pd.read_csv("/Users/Evan/Desktop/Deathsetlinks.csv", 
                      index_col="Unnamed: 0")
                      
# define function to clean up atypical html

def cleanlinks(df):
    newlinks = []
    for i in df:
        if "last.html" in i:
            data ='http://www.tdcj.state.tx.us/death_row/' + i             
            newlinks.append(data)
        elif "no_last_statement.html" in i:
            data = "None"
            newlinks.append(data)
        elif "martinezdavidlast999173.html" in i:
            data ='http://www.tdcj.state.tx.us/death_row/' + i             
            newlinks.append(data)
        elif "martinezdavidlast999288.html" in i:
            data ='http://www.tdcj.state.tx.us/death_row/' + i             
            newlinks.append(data)
            
    return newlinks

# apply function to create dataframe with webpage links

laststatelinks = pd.DataFrame(cleanlinks(dslinks.AllHtml),columns={'links'})

# concatenate dataset with cleaned links and write to desktop

deathwithLS = pd.concat([deathset,laststatelinks],axis=1)
del deathwithLS["Unnamed: 0"]
deathwithLS.to_csv('/Users/Evan/Desktop/focused.csv') 
    