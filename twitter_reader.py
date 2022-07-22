import json
import requests
import socket
import sys
import twitter_secure as ts

#  call the Twitter API URL and return the response for a stream of tweets
my_auth = ts.secure()

host = "localhost"
port = 9999

def get_tweets():
	url = 'https://stream.twitter.com/1.1/statuses/filter.json'
	query_data = [('language', 'en'), ('locations', '-130,-20,100,50')]
	# query_data = [('language', 'en'), ('locations', '-23,-46,100,50')]
	#query_data = [('language', 'pt')]
	query_url = url + '?' + '&'.join([str(t[0]) + '=' + str(t[1]) for t in query_data])

	response = requests.get(query_url, auth=my_auth, stream=True)
	return response

def send_tweets_to_spark(http_resp, tcp_connection):
  for line in http_resp.iter_lines():

    try:
      full_tweet = json.loads(line)

      datetime = full_tweet['created_at'][:20]
      tweet = full_tweet['text']
      print (f"---------------{datetime}--------------------------")
      print(tweet)
      tcp_connection.send(bytes(tweet, "utf-8"))

    except:
      e = sys.exc_info()[0]
      print("Error KO000: %s" % e)

def main():
    TCP_IP = "localhost"
    TCP_PORT = 9009
    conn = None
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((TCP_IP, TCP_PORT))
    s.listen(1)
    print("Waiting for TCP connection...")
    conn, addr = s.accept()
    print("Connected... Starting getting tweets.")
    resp = get_tweets()
    send_tweets_to_spark(resp, conn)

if __name__ == '__main__':
    main()
