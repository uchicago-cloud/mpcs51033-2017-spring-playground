import requests

for i in range(0,100):
    print i
    r = requests.post('http://localhost:8080?counter=simple')
    r = requests.post('http://localhost:8080?counter=general')
