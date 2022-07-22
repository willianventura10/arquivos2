import json
import requests_oauthlib

def secure():

    ACCESS_TOKEN = '54046601-mDtNWUETwW62Y7ODWTLE5m1JI9rkM4B8eGARCZCci'
    ACCESS_SECRET = 'xhRlq1jeV0qJg0U3DgoM1pWLTBd9N5TAcNZjgsekwrGKu'
    CONSUMER_KEY = 'IQWF9aWXZfyVubbj7Hkgg'
    CONSUMER_SECRET = 'AeF3YRUCTGXM722dKBp1RC1mrKcOXQBuiXlqJiuoE4'


    # api_key = secrets['API_key']
    # api_secret_key = secrets['API_secret_key']
    # access_token = secrets['access_token']
    # access_token_secret = secrets['access_token_secret']
    my_auth = requests_oauthlib.OAuth1('IQWF9aWXZfyVubbj7Hkgg', 'AeF3YRUCTGXM722dKBp1RC1mrKcOXQBuiXlqJiuoE4', ACCESS_TOKEN, ACCESS_SECRET)

    return my_auth
