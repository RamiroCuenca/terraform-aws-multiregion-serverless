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
resource "aws_api_gateway_method" "apigatewaymethod" {
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.createuser.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.apigateway.id
  resource_id             = aws_api_gateway_resource.createuser.id
  http_method             = aws_api_gateway_method.apigatewaymethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_create_user.invoke_arn
}

# Provide our API Gateway with permissions to executi each Lambda function
resource "aws_lambda_permission" "apigateway_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_create_user.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.apigateway.execution_arn}/users/create"
}

# Create the Lambda function
resource "aws_lambda_function" "lambda_create_user" {
  filename      = "lambdas/create_user.zip"
  function_name = "rsalinas-users-create"
  description = "creates a new user at DynamoDB"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambdas/create_user.zip")

  runtime = "go1.x"
}

# Create an IAM Role for our Lambda function
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}