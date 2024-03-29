class CustomHashtagScanner:
    # Scan for custom Hashtags
    customHashtag = '#BNODNA'
    since_id_hashtag = 0
    init_tweet_text = 'init'
    #q = customHashtag + ' since_id:' + str(since_id_hashtag)
    count = 10
    #search_results = twitter_api.search.tweets(q=q, count=count)
    #statuses = search_results['statuses']
    #print(json.dumps(statuses[0], indent=1))
    #for status in statuses:
    #    print(status['text'])
 
    def __init__(self, messageList):
        self.messageList = messageList


    def ThingsToLookFor(self):
        #return ['(' + self.customHashtag + ' since_id:' + str(self.since_id_hashtag) + ')'], \
        #    [self.customHashtag]
        return [self.customHashtag], [self.customHashtag]

    def ReturnQuery(self, tweets):
        for hashtag in tweets:
            for tweet in tweets[hashtag]:
                if tweet['id']> self.since_id_hashtag:
                    self.since_id_hashtag = tweet['id']
                    if self.customHashtag in tweet['text'] and self.init_tweet_text in tweet['text']:
                        print("INIT HASHTAG FOUND " + tweet['created_at'])
                    else:
                        self.messageList.put(("/BNOOSC/CustomHashtag/", [self.customHashtag, tweet['text'].replace(self.customHashtag, '').strip()]))
                        #print("Hashtag Scanner Fired")
                    
