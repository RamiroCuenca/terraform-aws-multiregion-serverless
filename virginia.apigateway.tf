# Create the API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "rsalinas-users-api"
  description = "serverless users api"
}

# Set up each lambda function endpoint
resource "aws_api_gateway_resource" "endpoint" {
  for_each = aws_lambda_function.function
  
  path_part   = each.value.tags.path
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

# CreateUser API method
resource "aws_api_gateway_method" "method" {
  for_each = aws_lambda_function.function

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.endpoint[each.key].id
  http_method   = each.value.tags.method
  authorization = "NONE"
}

# Integrate API Gateway w/ Lambda's
resource "aws_api_gateway_integration" "integration" {
  for_each = aws_lambda_function.function

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.endpoint[each.key].id
  http_method             = aws_api_gateway_method.method[each.key].http_method
  
  integration_http_method = each.value.tags.method
  type                    = "AWS_PROXY"
  uri                     = each.value.invoke_arn
}

# Deploy our API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_method.method,
    aws_api_gateway_integration.integration
  ]
}

# Configure the stage for our deployment
resource "aws_api_gateway_stage" "sandbox" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "sandbox"
}