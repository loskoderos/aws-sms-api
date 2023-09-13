resource "aws_lambda_function" "smsapi" {
  function_name = "${var.project}"
  filename = "../build/${var.zip_file}"
  handler = "handler.lambda_handler"
  runtime = "python3.8"
  role = "${aws_iam_role.smsapi.arn}"
}

resource "aws_lambda_permission" "smsapi" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.smsapi.arn}"
  principal = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.smsapi.execution_arn}/*/*"
}
