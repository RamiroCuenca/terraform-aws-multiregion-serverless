# Create the API Gateway
resource "aws_api_gateway_rest_api" "api_ohio" {
  provider = aws.ohio

  name        = "rsalinas-users-api"
  description = "serverless users api"
}

# Set up each lambda function endpoint
resource "aws_api_gateway_resource" "endpoint_ohio" {
  provider = aws.ohio

  for_each = aws_lambda_function.function_ohio

  path_part   = each.value.tags.path
  parent_id   = aws_api_gateway_rest_api.api_ohio.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api_ohio.id
}

# CreateUser API method
resource "aws_api_gateway_method" "method_ohio" {
  provider = aws.ohio

  for_each = aws_lambda_function.function_ohio

  rest_api_id   = aws_api_gateway_rest_api.api_ohio.id
  resource_id   = aws_api_gateway_resource.endpoint_ohio[each.key].id
  http_method   = each.value.tags.method
  authorization = "NONE"
}

# Integrate API Gateway w/ Lambda's
resource "aws_api_gateway_integration" "integration_ohio" {
  provider = aws.ohio

  for_each = aws_lambda_function.function_ohio

  rest_api_id = aws_api_gateway_rest_api.api_ohio.id
  resource_id = aws_api_gateway_resource.endpoint_ohio[each.key].id
  http_method = aws_api_gateway_method.method_ohio[each.key].http_method

  # integration_http_method = each.value.tags.method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = each.value.invoke_arn
}

# Deploy our API Gateway
resource "aws_api_gateway_deployment" "deployment_ohio" {
  provider = aws.ohio

  rest_api_id = aws_api_gateway_rest_api.api_ohio.id

  depends_on = [
    aws_api_gateway_method.method_ohio,
    aws_api_gateway_integration.integration_ohio
  ]
}

# Configure the stage for our deployment
resource "aws_api_gateway_stage" "sandbox_ohio" {
  provider = aws.ohio

  deployment_id = aws_api_gateway_deployment.deployment_ohio.id
  rest_api_id   = aws_api_gateway_rest_api.api_ohio.id
  stage_name    = "sandbox"
}