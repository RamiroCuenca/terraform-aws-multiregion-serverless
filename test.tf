# # API Gateway
# resource "aws_api_gateway_rest_api" "api" {
#   name = "myapi"
# }

# resource "aws_api_gateway_resource" "resource" {
#   path_part   = "resource"
#   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
#   rest_api_id = aws_api_gateway_rest_api.api.id
# }

# resource "aws_api_gateway_method" "method" {
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_resource.resource.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "integration" {
#   rest_api_id             = aws_api_gateway_rest_api.api.id
#   resource_id             = aws_api_gateway_resource.resource.id
#   http_method             = aws_api_gateway_method.method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.lambda.invoke_arn
# }

# # Lambda
# resource "aws_lambda_permission" "apigw_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda.function_name
#   principal     = "apigateway.amazonaws.com"

#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/users/create"
# }

# resource "aws_lambda_function" "lambda" {
#   filename      = "lambdas/create_user.zip"
#   function_name = "mylambda"
#   role          = aws_iam_role.role.arn
#   handler       = "lambda.lambda_handler"
#   runtime       = "python3.6"

#   source_code_hash = filebase64sha256("lambdas/create_user.zip")
# }

# # IAM
# resource "aws_iam_role" "role" {
#   name = "myrole"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# POLICY
# }