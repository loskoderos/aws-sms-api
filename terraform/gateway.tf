resource "aws_api_gateway_rest_api" "smsapi" {
  name = "${var.project}"
  description = "SMS API"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.smsapi.id}"
  parent_id = "${aws_api_gateway_rest_api.smsapi.root_resource_id}"
  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  resource_id = "${aws_api_gateway_resource.proxy.id}"
  rest_api_id = "${aws_api_gateway_rest_api.smsapi.id}"
  http_method = "ANY"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.smsapi.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "${aws_lambda_function.smsapi.invoke_arn}"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id = "${aws_api_gateway_rest_api.smsapi.id}"
  resource_id = "${aws_api_gateway_rest_api.smsapi.root_resource_id}"
  http_method = "ANY"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.smsapi.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "${aws_lambda_function.smsapi.invoke_arn}"
}

resource "aws_api_gateway_deployment" "smsapi" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root
  ]
  rest_api_id = "${aws_api_gateway_rest_api.smsapi.id}"
  stage_name = "test"
}

# Key to use the API with the x-api-key header
resource "aws_api_gateway_api_key" "test" {
  name = "${var.project}-test"
}

# Usage plan for the api
resource "aws_api_gateway_usage_plan" "smsapi" {
  name = "${var.project}-usage-plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.smsapi.id
    stage = aws_api_gateway_deployment.smsapi.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "test" {
  key_id = aws_api_gateway_api_key.test.id
  key_type = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.smsapi.id
}
