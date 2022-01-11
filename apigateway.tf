# API Gateway resource
resource "aws_api_gateway_rest_api" "apigateway" {
  name        = "rsalinas-users-api"
  description = "users api"
}

# CreateUser API endpoint
resource "aws_api_gateway_resource" "createuser" {
  path_part   = "create"
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
}

# CreateUser API method
resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.createuser.id
  http_method   = "POST"
  authorization = "NONE"
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