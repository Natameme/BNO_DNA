class NoteScraper:
    def __init__(self, client):
        self.notes = [['#A', '#B', '#C', '#D', '#E', '#F', '#G'], [], []]
        for note in self.notes[0]:
            #flats
            self.notes[1].append(note + 'f')
            #sharps
            self.notes[2].append(note + 's')
        self.client = client
        self.current_batch = 0
    
    def ThingsToLookFor(self):
        self.current_batch = (self.current_batch+1)%len(self.notes)
        return self.notes[self.current_batch]
        
    def ReturnQuery(self, tweets):
        for hashtag in tweets:
            for tweet in tweets[hashtag]:
                self.client.send_message("/BNOOSC/HashNote/", \
                    [hashtag[1:], tweet['text'].replace(hashtag, '').strip()])