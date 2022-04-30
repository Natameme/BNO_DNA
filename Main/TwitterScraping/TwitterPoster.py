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
    def __init__(self, consumer_key, consumer_secret, access_token, access_token_secret, delete_mentions = True, total_cooldown_to_tweet = 38):
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

        self.delete_mentions = delete_mentions
        self.cooldown = total_cooldown_to_tweet
        self.total_cooldown_to_tweet = total_cooldown_to_tweet
    
        
    
    def publish(self, tweet):
        if self.delete_mentions:
            tweet = tweet.replace('@', '')
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
            if self.tweetQueue.qsize()>100:
                for i in range(50):
                    self.tweetQueue.get()
            if not self.tweetQueue.empty():
                tweet = self.tweetQueue.get().item
                print(tweet)
                if self.cooldown > self.total_cooldown_to_tweet:
                    self.cooldown=0
                    self.publish(tweet)
            self.cooldown += 1
            time.sleep(1)
            
    
    def join(self):
        self.thread.join()
            

