import webapp2
import json

import cloudkit_helper as ck

class JokeOfTheDay(webapp2.RequestHandler):
    #
    # Create a new joke of the day record and post it to iCloud
    # Note: We are hard coming the reference here, you should get
    # if from the processing of the daily joke ratings
    def get(self):


        new_joke_of_the_day_data = {
        'operations': [{
            'operationType': 'create',
            'record': {
                'recordType': 'Daily',
                'fields': {
                    'day': {'value': 'today'},
                    'joke': {
                        'value': {
                            'recordName': '60d82b7d-32ef-4e91-9c12-585c92a3bb89',
                        'zoneID:': {
                            'zoneName': '_defaultZone'
                            },
                            'action': 'DELETE_SELF'
                        }
                    }
                }
            }
        }]
        }

        #print('Posting operation to create quote...')
        result_modify_jokes = ck.cloudkit_request(
        '/development/public/records/modify',
        json.dumps(new_joke_of_the_day_data))
        
        self.response.headers['Content-Type'] = 'text/json'
        self.response.write(result_modify_jokes['content'])
