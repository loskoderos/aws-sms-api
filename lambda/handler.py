import json
import datetime
import boto3

def lambda_handler(event, context):
    sns = boto3.client('sns')

    request = json.loads(event['body'])
    print("Sending SMS to {}: {}".format(request['phone'], request['message']))
    sns.publish(PhoneNumber=request['phone'], Message=request['message'])

    response = {
        'time': datetime.datetime.now().strftime("%m/%d/%Y, %H:%M:%S")
    }
    return {
        'statusCode': 201,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps(response)
    } 
