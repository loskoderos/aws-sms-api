# AWS SMS API

Simple API for sending out SMS built with AWS.

Project includes a lambda function in Python to send SMS via SNS service and Terraform code to deploy all required components (API Gateway, Lambda, SNS, etc).

## Development
Init terraform
~~~
make init
~~~

Deploy API
~~~
make build apply
~~~
The URL is returned.
To get the API key you need to go to AWS console -> API Gateway -> ... -> API Keys

Destroy API
~~~
make destroy
~~~

## Testing
Send SMS to a phone number. The number must be validated in AWS SNS console if your account is in sandbox mode.
~~~
API_URL="https://xxxxxxxxxx.execute-api.eu-west-1.amazonaws.com/test"
API_KEY=XXXXXXXXXXXXXXXX
curl -i -X POST \
  -H "x-api-key: $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"phone":"+48502670711", "message":"Witamy w POC, tesowy kod 666"}' \
  $API_URL
~~~
