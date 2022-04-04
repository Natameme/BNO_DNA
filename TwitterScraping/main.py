#Install everything
#pip3 install python-osc
#pip3 install twitter
#pip3 install numpy
#pip3 install nltk

# Import everything
import twitter
from pythonosc.udp_client import SimpleUDPClient
import json
from WorldTrendsManager import WorldTrendManager
from CustomHashtagScanner import CustomHashtagScanner
from NoteScraper import NoteScraper
import time

#import numpy as np

# Instantiate the twitter api client
CONSUMER_KEY = 'OWAwcOfkzNSlIBGhAtQdNY4Im'
CONSUMER_SECRET = '14iE08KZpZx44b4B0WfoAqvOPF7kXNdzkkv7fmXreqKb1fCzMc'
OAUTH_TOKEN = ''
OAUTH_TOKEN_SECRET = ''

auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,
                           CONSUMER_KEY, CONSUMER_SECRET)

twitter_api = twitter.Twitter(auth=auth)

# Instantiate the OSC UDP client
ip = "127.0.0.1"
port = 57120
count = 1000
client = SimpleUDPClient(ip, port)  # Create OSC client

trendsManager = WorldTrendManager(client, twitter_api)
hashtagScanner = CustomHashtagScanner(client)
noteScraper = NoteScraper(client)

while True:
    thingsToLookFor = []
    try:
      thingsForTrends = trendsManager.ThingsToLookFor()
      #thingsForTrends = []
    except:
        print("Exception (ask Juan): trends manager call failed")
        thingsForTrends = []
    thingsToLookFor += thingsForTrends

    try:
        scannerQuery, thingsForScanner = hashtagScanner.ThingsToLookFor()
    except:
        print("Exception (ask Juan): hashtagScanner call failed")
        scannerQuery = []
        thingsForScanner = []
    thingsToLookFor += scannerQuery

    try:
        thingsForNoteScraper = noteScraper.ThingsToLookFor()
    except:
        print("Exception (ask Juan): noteScraper call failed")
        thingsForNoteScraper = []

    thingsToLookFor += thingsForNoteScraper

    query = ' OR '.join(thingsToLookFor)

    while(len(query)>512):
        print("WARNING: query too long, taking hashtags off")
        query = query[query.find(' OR ')+len(' OR '):]

    search_results = twitter_api.search.tweets(q=query, count=count)['statuses']
    trendsQueryResults = {}
    scannerQueryResults = {}
    hashNoteQueryResults = {}
   
    for search_result in search_results:
        for thingForTrends in thingsForTrends:
            if thingForTrends in search_result['text']:
                if thingForTrends in trendsQueryResults:
                    trendsQueryResults[thingForTrends].append(search_result)
                else:
                    trendsQueryResults[thingForTrends] = [search_result]
        
        
        for thingForScanner in thingsForScanner:
            if thingForScanner in search_result['text']:
                if thingForScanner in scannerQueryResults:
                    scannerQueryResults[thingForScanner].append(search_result)
                else:
                    scannerQueryResults[thingForScanner] = [search_result]
        
        
        for thingForNoteScraper in thingsForNoteScraper:
            if thingForNoteScraper in search_result['text']:
                if thingForNoteScraper in hashNoteQueryResults:
                    hashNoteQueryResults[thingForNoteScraper].append(search_result)
                else:
                    hashNoteQueryResults[thingForNoteScraper] = [search_result]

    trendsManager.ReturnQuery(trendsQueryResults)
    hashtagScanner.ReturnQuery(scannerQueryResults)
    noteScraper.ReturnQuery(hashNoteQueryResults)
    print("All Messages Fired")
    time.sleep(6)





