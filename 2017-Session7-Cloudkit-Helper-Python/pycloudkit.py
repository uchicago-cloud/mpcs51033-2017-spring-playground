import sys
import json

import cloudkit_helper as ck

def main():

    #
    # Print out the zones
    #
    print("Print out all the zones (we are just using default.)")
    ck.dump_zones()

    #
    # Query CloudKit to get all the `joke` records.  We are also
    # writing it to a file so we can debug it
    #
    print('Querying all jokes...')
    jokes = ck.query_records('joke')
    ck.write_json_to_file(jokes, "jokes.json")
    for joke in jokes:
        print("========joke=========")
        print(joke["fields"])



    new_joke_data = {
        'operations': [{
            'operationType': 'create',
            'record': {
                'recordType': 'joke',
                'fields': {
                    'question': {
                        'value': 'What did the number 0 say to the number 8?'
                    },
                    'response': {
                        'value': 'I like you belt..'
                    },
                    'rating_negative': {
                        'value': 10
                    },
                    'rating_positive': {
                        'value': 10
                    }
                }
            }
        }]
    }
    print('Posting operation to create quote...')
    result_modify_jokes = ck.cloudkit_request(
        '/development/public/records/modify',
        json.dumps(new_joke_data))
    print(result_modify_jokes['content'])

    #
    # Create a new joke of the day record and post it to iCloud
    # Note: We are hard coming the reference here
    #
    new_joke_of_the_day_data = {
        'operations': [{
            'operationType': 'create',
            'record': {
                'recordType': 'Daily',
                'fields': {
                    'day': {
                        'value': 'today'
                    },
                    # 'joke': {
                    #     'value': {
                    #         'recordName': '60d82b7d-32ef-4e91-9c12-585c92a3bb89',
                    #         'zoneID:': {
                    #             'zoneName': '_defaultZone'
                    #         },
                    #         'action': 'DELETE_SELF'
                    #     }
                    # }
                }
            }
        }]
    }

    print('Posting operation to create quote...')
    result_modify_jokes = ck.cloudkit_request(
        '/development/public/records/modify',
        json.dumps(new_joke_of_the_day_data))
    print(result_modify_jokes['content'])



if __name__ == '__main__':
    sys.exit(main())
