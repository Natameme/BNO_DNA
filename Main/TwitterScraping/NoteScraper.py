class NoteScraper:
    def __init__(self, messageList, analyzer):
        self.notes = [['#A', '#B', '#C', '#D', '#E', '#F', '#G'], [], []]
        for note in self.notes[0]:
            #flats
            self.notes[1].append(note + 'f')
            #sharps
            self.notes[2].append(note + 's')
        self.messageList = messageList
        self.current_batch = 0
        self.analyzer = analyzer
    
    def ThingsToLookFor(self):
        self.current_batch = (self.current_batch+1)%len(self.notes)
        return self.notes[self.current_batch]
        
    def ReturnQuery(self, tweets):
        for hashtag in tweets:
            for tweet in tweets[hashtag]:
                polarity_scores = self.analyzer.polarity_scores(tweet['text'])
                self.messageList.put(("/BNOOSC/HashNote/", \
                    [hashtag[1:], tweet['text'].replace(hashtag, '').strip(), 
                    polarity_scores['pos'], polarity_scores['neu'], polarity_scores['neg'],
                    polarity_scores['compound']]))
                #print("Note Scraper Fired")