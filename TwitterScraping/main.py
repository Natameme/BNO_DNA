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
from NoteScrapper import NoteScraper
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

client = SimpleUDPClient(ip, port)  # Create OSC client

trendsManager = WorldTrendManager(client, twitter_api)
hashtagScanner = CustomHashtagScanner(client)
noteScraper = NoteScraper(client)

#while True:
thingsToLookFor = []
thigsForTrends = trendsManager.ThingsToLookFor()
thingsToLookFor += thigsForTrends
scannerQuery, thingsForScanner = hashtagScanner.ThingsToLookFor()
thingsToLookFor += scannerQuery
thingsForNoteScrapper = noteScraper.ThingsToLookFor()
thingsToLookFor += thingsForNoteScrapper

query = ' OR '.join(thingsToLookFor)

print(query)


