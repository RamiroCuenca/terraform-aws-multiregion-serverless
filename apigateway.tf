# Create the API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "rsalinas-users-api"
  description = "serverless users api"
}

# Set up create (lambda function) endpoint
resource "aws_api_gateway_resource" "create" {
  path_part   = "create"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

# CreateUser API method
resource "aws_api_gateway_method" "create" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.create.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integrate API Gateway w/ Lambda's
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.create.id
  http_method             = aws_api_gateway_method.create.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create.invoke_arn
}


