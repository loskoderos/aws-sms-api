output "api_url" {
  value = "${aws_api_gateway_deployment.smsapi.invoke_url}"
}

output "api_key" {
  value = aws_api_gateway_api_key.test.value
  sensitive = true
}
