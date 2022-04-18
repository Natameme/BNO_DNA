import requests
import os
import json

class RandomStreamGetter:
    def __init__(self, bearer_token, analyzer):
        self.bearer_token = bearer_token
        self.url = self.create_url()
        self.analyzer = analyzer

    def create_url(self):
        return "https://api.twitter.com/2/tweets/sample/stream"


    def bearer_oauth(self, r):
        """
        Method required by bearer token authentication.
        """

        r.headers["Authorization"] = f"Bearer {self.bearer_token}"
        r.headers["User-Agent"] = "v2SampledStreamPython"
        return r


    def connect_to_endpoint(self, url):
        response = requests.request("GET", url, auth=self.bearer_oauth, stream=True)
        averageAnalysis = {'neg': 0.0,'neu': 0.0,'pos': 0.0, 'compound' :0.0}
        count = 0
        for response_line in response.iter_lines():
            if response_line:
                json_response = json.loads(response_line)
                try:
                    analysis = self.analyzer.polarity_scores(json_response['data']['text'])
                    for i in analysis.keys():
                        averageAnalysis[i] += analysis[i]
                    count += 1
                except Exception:
                    continue
        if count <= 1: return averageAnalysis

        for i in averageAnalysis.keys():
            averageAnalysis[i] /= count
        
        if response.status_code != 200:
            print(
                "Request returned an error: {} {}".format(
                    response.status_code, response.text
                )
            )
        return averageAnalysis

    def fire(self):
        return self.connect_to_endpoint(self.url)


    
