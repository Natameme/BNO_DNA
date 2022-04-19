#Install everything
#pip3 install python-osc
#pip3 install twitter
#pip3 install numpy
#pip3 install nltk
#nltk.download('vader_lexicon')
#pip3 install python-telegram-bot
from threading import Thread
import random
import queue
from tracemalloc import start

# Import everything
import twitter
from pythonosc.udp_client import SimpleUDPClient
import json
from WorldTrendsManager import WorldTrendManager
from CustomHashtagScanner import CustomHashtagScanner
from NoteScraper import NoteScraper
import time
import nltk
#nltk.download('vader_lexicon')
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from pythonosc.dispatcher import Dispatcher
from pythonosc import osc_server
from TwitterPoster import *
from RandomStreamGetter import *
from TelegramBot import *

#import numpy as np

# Instantiate the twitter api client
#CONSUMER_KEY = 'OWAwcOfkzNSlIBGhAtQdNY4Im'
#CONSUMER_SECRET = '14iE08KZpZx44b4B0WfoAqvOPF7kXNdzkkv7fmXreqKb1fCzMc'
#OAUTH_TOKEN = '1350156541282889729-H02Tl1JLxqSjijz9pSgGapt2yshGIW'
#OAUTH_TOKEN_SECRET = 'AEAAnbmcA75WHHjXUOButwwjE2ZzSLy4H5S7XfnHHZFvm'
#BEARER_TOKEN = 'AAAAAAAAAAAAAAAAAAAAANMUZwEAAAAAhXSpl9O1vl8lX8n070X%2FUNV7cuc%3DoB2hOYYIle3sLXpadsgXa9UaWF5IyyfgLgDruApTqhvwWQuvBl'

API_KEY = 'aAfQM9o1ImAcFQ447YJnA722Y'
API_KEY_SECRET = 'QRLu7XVozilwKjrxFjImACAswr5yrlSpCd85dLxwc3wyduYqTm'
BEARER_TOKEN = 'AAAAAAAAAAAAAAAAAAAAAHx1bgEAAAAAf5xF3NRIrS6gdx3NLe9Z4by8i84%3DtWDBFdk8hP5CjGYiVuDdxlEwhldo2EA0xNsMWmoLkmQp4JfkS2'
ACCESS_TOKEN = '1515914358739640321-7fs1KGnw2W9i9Yn85qziDDAYWlxGRR'
ACCESS_TOKEN_SECRET = 'ovTaAfKUqCZRtQ22UoXZzKuDayavsbZZV2KVrSUawC6XE'
CLIENT_ID = 'enZ1dE56dU1iTWlWQVd0bmpMYlk6MTpjaQ'
CLIENT_ID_SECRET = 'YR78CWF8jt86oCp0E15olqVtkDI0dZ5Gx9J9U-EoE7VkVvYoHM'

auth = twitter.oauth.OAuth(ACCESS_TOKEN, ACCESS_TOKEN_SECRET,
                           API_KEY, API_KEY_SECRET)

twitter_api = twitter.Twitter(auth=auth)

# Instantiate the OSC UDP client
ip = "127.0.0.1"
port = 57120
count = 98
  # Create OSC client
analyzer = SentimentIntensityAnalyzer()
messageList = queue.SimpleQueue()

poster = TwitterPoster(API_KEY, API_KEY_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
poster.start()

def handleOSC(address, *args):
    print(f"{address}: {args}")

def launchOSCHandler():
    dispatcher = Dispatcher()
    dispatcher.map("/BNOINTERNAL/*", handleOSC)

    serverIp = "128.0.0.2"
    serverPort = 1345

    server = osc_server.BlockingOSCUDPServer((ip, port), dispatcher)
    server.serve_forever()  # Blocks forever

def clientOSC():
    client = SimpleUDPClient(ip, port)
    while(True):
        if not messageList.empty():
            item = messageList.get()
            client.send_message(item[0], item[1])
            print(item[0])
            print(item[1])
        time.sleep(1)

#OSCServerThread = Thread(target=launchOSCHandler)
OSCClientThread = Thread(target=clientOSC)
OSCClientThread.start()
#OSCServerThread.start()

telegramBot = None

def startBot():
    telegramBot = BNODNABot(messageList, analyzer, poster)

botThread = Thread(target=startBot)
botThread.start()

randomStream = RandomStreamGetter(BEARER_TOKEN, analyzer)
try:
    trendsManager = WorldTrendManager(messageList, twitter_api, analyzer)
    hashtagScanner = CustomHashtagScanner(messageList)
    noteScraper = NoteScraper(messageList, analyzer)
    skipTrends = 0
    skipScraper = 0
    skipScanner = 0
    while True:
        
        #randomStreamSentiment = randomStream.fire()
        #if(randomStreamSentiment != [0.0, 0.0, 0.0, 0.0]):
        #    trendsManager.SetRandomQueryResult(randomStreamSentiment)
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

            query = ' OR '.join(thingsToLookFor)
            #query = 'Flop of the Season OR Player of the Season OR Mark Harper OR Woippy OR Most Improved Player OR Taylor Lorenz OR Xenoblade 3 OR Wordle 305 OR WE LOVE YOU JUNGKOOK OR Priti Patel OR (#BNODNA since_id:0) OR #As OR #Bs OR #Cs OR #Ds OR #Es OR #Fs OR #Gs'
            #query = 'Flop of the Season'

            while(len(query)>128):
                print("WARNING: query too long, taking hashtags off")
                query = query[query.find(' OR ')+len(' OR '):]
            
            query_return = twitter_api.search.tweets(q=query, count=count)
            
            search_results = query_return['statuses']
            #if(len(search_results)==0):
            #    print(query)
            #    print(query_return)
            trendsQueryResults = {}
            scannerQueryResults = {}
            hashNoteQueryResults = {}
        
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
            
            if len(trendsQueryResults.keys())>0:
                poster.addToQueue(random.choice(trendsQueryResults[random.choice(list(trendsQueryResults.keys()))])['text'])

            if len(scannerQueryResults.keys())>0:
                poster.addToQueue(random.choice(scannerQueryResults[random.choice(list(scannerQueryResults.keys()))])['text'])
            
            if len(hashNoteQueryResults.keys())>0:
                poster.addToQueue(random.choice(hashNoteQueryResults[random.choice(list(hashNoteQueryResults.keys()))])['text'])

            time.sleep(6.5)

        # Count how many tweets have gone into each module, so none of them "starves"
        
        if tweetsFoundForScanner == 0:
            skipTrends +=1
            skipScraper += 1
        
        if tweetsFoundForScraper <= tweetsFoundForTrends//2:
            skipTrends += 1
except KeyboardInterrupt:
    #OSCServerThread.join()
    OSCClientThread.join()
    poster.join()
    botThread.join()
    exit()