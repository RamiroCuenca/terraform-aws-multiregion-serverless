# API Gateway resource
resource "aws_api_gateway_rest_api" "APIGateway" {
  name        = "rsalinas-users-api"
  description = "users api"
}

# Provide our API Gateway with permissions to executi each Lambda function
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "rsalinas-users-create"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.MyDemoAPI.execution_arn}/*/*/*"
}