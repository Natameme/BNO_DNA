# Message Interface

This document is currently a proposal of the OSC message structure that could connect the twitter scraping modules with supercollider.

OSC messages contain 
* Address: string with words separated with slashes, like a fodler structure (it can be, for example "/BNOOSC/TweetContent/" or "/BNOOSC/CoolNumber"). NOTE: not to be confused with the IP address of the message, which will just be localhost since we will be running everything in a single machine.

* Content: ordered list of values that can be strings, floats, integers... 

## Message types

* Average positivity, neutrality, negativity and compound of the most relevant tweets on the trending topics every interval of time (like a second). Compound means an aggreate value of the positivity and negativity of the tweets, ranging from -1.0 to 1.0, the other three range from 0.0 to 1.0:
    * Address: "/BNOOSC/Sentiment/"
    * Content: float (pos), float (neu), float (neg), float (comp)

* Every time someone hashtags something and the nessage (we could have our special hashtag like #BNODNA) that could trigger something.
    * Address: "/BNOOSC/CustomHastag/"
    * Content: string (the hashtag itself, currently detecting #BNODNA), string (the rest of the text of the tweet)

* Hashtaged "notes" every hour to see what chords appear (#F, #C, #Bb...) Although I expect there to be mostly #F for the meme, but who knows!
    * Address: "/BNOOSC/HashNote/"
    * Content: string (the note), string (the rest of the text in the tweet)