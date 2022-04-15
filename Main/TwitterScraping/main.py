#Install everything
#pip3 install python-osc
#pip3 install twitter
#pip3 install numpy
#pip3 install nltk
#nltk.download('vader_lexicon')

# Import everything
import twitter
from pythonosc.udp_client import SimpleUDPClient
import json
from WorldTrendsManager import WorldTrendManager
from CustomHashtagScanner import CustomHashtagScanner
from NoteScraper import NoteScraper
import time
import nltk
nltk.download('vader_lexicon')
from nltk.sentiment.vader import SentimentIntensityAnalyzer

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
count = 98
client = SimpleUDPClient(ip, port)  # Create OSC client
<<<<<<< HEAD
dispatcher = dispatcher.Dispatcher()
server = osc_server.ThreadingOSCUDPServer((ip,port), dispatcher)
#server.serve_forever()
dispatcher.map("/filter", handler)
=======
>>>>>>> f52c2acf83142d12b04ead432b788396e3c1e874
analyzer = SentimentIntensityAnalyzer()

trendsManager = WorldTrendManager(client, twitter_api, analyzer)
hashtagScanner = CustomHashtagScanner(client)
noteScraper = NoteScraper(client, analyzer)
skipTrends = 0
skipScraper = 0
skipScanner = 0
while True:
    tweetsFoundForTrends = 0
    tweetsFoundForScanner = 0
    tweetsFoundForScraper = 0
    
    for i in range(4):
        thingsToLookFor = []
        try:
            if skipTrends>0:
                skipTrends -= 1
                thingsForTrends = []
            else:
                thingsForTrends = trendsManager.ThingsToLookFor()
            #thingsForTrends = []
        except:
            print("Exception (ask Juan): trends manager call failed")
            thingsForTrends = []
        thingsToLookFor += thingsForTrends

        try:
            if skipScanner>0:
                skipScanner-=1
                scannerQuery = []
                thingsForScanner = []
            else:
                scannerQuery, thingsForScanner = hashtagScanner.ThingsToLookFor()
        except:
            print("Exception (ask Juan): hashtagScanner call failed")
            scannerQuery = []
            thingsForScanner = []
        thingsToLookFor += scannerQuery

        try:
            if skipScraper>0:
                skipScraper-=1
                thingsForNoteScraper = []
            else:
                thingsForNoteScraper = noteScraper.ThingsToLookFor()
        except:
            print("Exception (ask Juan): noteScraper call failed")
            thingsForNoteScraper = []

        thingsToLookFor += thingsForNoteScraper

        #query = ' OR '.join(thingsToLookFor)
        #query = 'Reece James OR Nacho OR Valverde OR peter walton OR Big Benz OR Iago OR Alaba OR Mason Mount OR #ريال_مدريد_تشيلسي OR Good Ebening OR (#BNODNA since_id:1511015009207336964) OR #As OR #Bs OR #Cs OR #Ds OR #Es OR #Fs OR #Gs'
        query = 'Reece James OR Nacho OR Valverde OR peter walton OR Big Benz OR Iago OR Alaba OR Mason Mount OR Good Ebening OR #As OR #Bs OR #Cs OR #Ds OR #Es OR #Fs OR #Gs'

        while(len(query)>512):
            print("WARNING: query too long, taking hashtags off")
            query = query[query.find(' OR ')+len(' OR '):]
        
        query_return = twitter_api.search.tweets(q=query, count=count)

        search_results = query_return['statuses']
        #print("QUERY")
        #print(query)
        #print("RESPONSE")
        
        trendsQueryResults = {}
        scannerQueryResults = {}
        hashNoteQueryResults = {}
     
        print(query)
        print(len(search_results))
        
        for search_result in search_results:
            #print(search_result['text'][:20])
            for thingForTrends in thingsForTrends:
                if thingForTrends in search_result['text']:
                    tweetsFoundForTrends += 1
                    if thingForTrends in trendsQueryResults:
                        trendsQueryResults[thingForTrends].append(search_result)
                    else:
                        trendsQueryResults[thingForTrends] = [search_result]
            
            
            for thingForScanner in thingsForScanner:
                if thingForScanner in search_result['text']:
                    tweetsFoundForScanner += 1
                    if thingForScanner in scannerQueryResults:
                        scannerQueryResults[thingForScanner].append(search_result)
                    else:
                        scannerQueryResults[thingForScanner] = [search_result]
            
            
            for thingForNoteScraper in thingsForNoteScraper:
                if thingForNoteScraper in search_result['text']:
                    tweetsFoundForScraper += 1
                    if thingForNoteScraper in hashNoteQueryResults:
                        hashNoteQueryResults[thingForNoteScraper].append(search_result)
                    else:
                        hashNoteQueryResults[thingForNoteScraper] = [search_result]

        trendsManager.ReturnQuery(trendsQueryResults)
        hashtagScanner.ReturnQuery(scannerQueryResults)
        noteScraper.ReturnQuery(hashNoteQueryResults)
        
        time.sleep(6.5)

    # Count how many tweets have gone into each module, so none of them "starves"
    
    if tweetsFoundForScanner == 0:
        skipTrends +=1
        skipScraper += 1
    
    if tweetsFoundForScraper <= tweetsFoundForTrends//2:
        skipTrends += 1

        




