import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

WORLD_WOE_ID = 1
US_WOE_ID = 23424977
base_sentiment = {'neg': 0.0, 'neu': 0.0, 'pos': 0.0, 'compound': 0.0, 'count': 0}

class WorldTrendManager:
    current_batch = 1
    batch_size = 10
    standard_trends_size = 50
    sentiment = base_sentiment.copy()
    def __init__(self, _client, _api):
        self.client = _client
        # Instantiate the sentiment analyzer
        nltk.download('vader_lexicon')
        self.analyzer = SentimentIntensityAnalyzer()
        self.api = _api
        # Obtain world trends
        self.WorldTrendsInit()
        self.current_results = [''] * self.standard_trends_size
        self.UpdateBatchIndexes()
        self.sentiment_keys=['neg', 'neu', 'pos', 'compound']
        
    
    def UpdateTrends(self):
        new_trends = self.api.trends.place(_id=self.WORLD_WOE_ID)[:self.standard_trends_size]
        not_trendy_anymore = self.world_trends.keys().copy()
        for trend in new_trends:
            if trend in self.world_trends:
                # This one is still trendy
                not_trendy_anymore.remove(trend)
            else:
                self.world_trends[trend] = None
        
        for trend in not_trendy_anymore:
            del self.world_trends[trend]


    
    def ThingsToLookFor(self):
        return list(self.world_trends.keys())[self.starting_index:self.ending_index]
    
    def ReturnQuery(self, results):
        self.AnalyzeTweets(results)
        self.RecalculateAveragePositivity()
        self.FireOSCMessage()
        # Increase batch indexes and update them
        if (self.ending_index >= self.standard_trends_size-1):
            self.current_batch = 1
        else:
            self.current_batch += 1
        self.UpdateBatchIndexes()
    
        

    def UpdateBatchIndexes(self):
        self.starting_index = (self.current_batch-1)*self.batch_size
        self.ending_index = (self.current_batch)*self.batch_size

    def RecalculateAveragePositivity(self):
        self.sentiment = base_sentiment.copy()
        for trend in self.world_trends:
            self.sentiment['count'] += self.world_trends[trend]['count']
            for key in base_sentiment.keys():
                self.sentiment[key] += self.world_trends[trend][key]
        # Make sure we don't divide by 0        
        if self.sentiment['count'] == 0:
            self.sentiment = base_sentiment.copy()
        else:
            for key in base_sentiment.keys():
                if key!='count':
                    self.sentiment[key] /= self.sentiment['count']

            self.sentiment['count'] = 1

    def AnalyzeTweets(self, hashtag_dict):
        for hashtag in hashtag_dict:
            sentiment = base_sentiment.copy()
            for tweet in hashtag_dict[hashtag]:
                tweet_sentiment = self.analyzer.polarity_scores(tweet['text'])
                for key in self.sentiment_keys:
                    sentiment[key] += tweet_sentiment[key]
                sentiment['count'] += 1
            self.world_trends[hashtag] = sentiment

    def FireOSCMessage(self):
        self.client.send_message("/BNOOSC/Sentiment/", \
             [self.sentiment['neg'], self.sentiment['neu'], self.sentiment['pos'],\
                  self.sentiment['compound']])

    def WorldTrendsInit(self):
        trend_names = []
        twitter_trends = self.api.trends.place(_id=WORLD_WOE_ID)[0]['trends'][:self.standard_trends_size]
        for trend in twitter_trends:
            trend_names.append(trend['name'])
        self.world_trends = dict.fromkeys(trend_names, \
            base_sentiment.copy())

    