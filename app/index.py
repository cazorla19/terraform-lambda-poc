import os
import json
import requests

# Using a Blockchain API
url = 'https://blockchain.info/latestblock'

# Global variables to cache the latest block
cache = {}
cold_start = True

def lambda_handler(event, context):
    global cold_start
    global cache

    # Purge the cache if necessary
    if cold_start:
        print("Cold start")
        cold_start = False
    else:
        print("Warm start, reset cache")
        cache = {}

    # Prepare the message for SNS if the latest hash is different
    # from what we've fetched the last time
    resp = requests.get(url=url)
    data = resp.json() # Check the JSON Response Content documentation below
    latest = data['hash']
    latest_cached = cache.get('latest', 'none')

    if latest is not latest_cached:
        response = json.dumps({"block": "new", "hash": latest})
    else:
        response = {}

    ## Write the latest value to the cache
    cache['latest'] = latest

    return response
