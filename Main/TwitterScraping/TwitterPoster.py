import tweepy, queue
from dataclasses import dataclass, field
from typing import Any
from threading import Thread
import time

@dataclass(order=True)
class PrioritizedItem:
    priority: int
    item: Any=field(compare=False)

class TwitterPoster:
    def __init__(self, consumer_key, consumer_secret, access_token, access_token_secret):
        auth = tweepy.OAuthHandler(
            consumer_key,
            consumer_secret
            )
        auth.set_access_token(
                access_token,
                access_token_secret
                )
        self.api = tweepy.API(auth)
        self.tweetQueue = queue.PriorityQueue()
        self.thread = None
    
        
    
    def publish(self, tweet):
        try:
            status = self.api.update_status(status=tweet)
        except Exception as exc:
            print("Failed to tweet: " + str(exc))
            print("The tweet was " + tweet)

    def addToQueue(self, tweet, priority=1):
        item = PrioritizedItem(priority, tweet)
        self.tweetQueue.put(item)
    
    def start(self):
        self.thread = Thread(target=self.ScheduledPublish)
        self.thread.start()

    def ScheduledPublish(self):
        while True:
            if not self.tweetQueue.empty():
                tweet = self.tweetQueue.get().item
                self.publish(tweet)
                time.sleep(4.5)
            time.sleep(0.5)
    
    def join(self):
        self.thread.join()
            

