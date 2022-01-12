# Our priority is to have this working, so, we are going to create an individual Lambda function for each method... but, once it's runnning fine, the idea it's going to be to use for_each method so that we just have to create 1 resource for all lambdas.
# We are going to leave the general resource commented, in the future we may need it
/* 
# Create the Lambda function
resource "aws_lambda_function" "lambdafunction" {
  for_each      = var.lambda_functions 
  filename      = each.value.zipfile
  function_name = each.value.name
  description   = each.value.description
  role          = aws_iam_role.iamrole_for_lambda.arn
  handler       = "main"

  source_code_hash = filebase64sha256(each.value.zipfile)

  runtime = "go1.x"
}

# Provide our API Gateway with permissions to execute each Lambda function
resource "aws_lambda_permission" "apigateway_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdafunction[each.index].function_name
#   function_name = aws_lambda_function.lambda_create_user.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*//* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.apigateway.execution_arn}/users/create"
}
*/

# Here we are going to create a Lambda function for each endpoint

/*
 *  CREATE USER 
 */
# Create the Lambda function
resource "aws_lambda_function" "create" {
  filename      = "lambdas/create_user.zip"
  function_name = "rsalinas-users-create"
  description   = "creates a new user"
  role          = aws_iam_role.lambda.arn
  handler       = "main"

  source_code_hash = filebase64sha256("lambdas/create_user.zip")

  runtime = "go1.x"
}

# Provide our API Gateway permission to execute our Lambda function
resource "aws_lambda_permission" "gwLambdaAccess" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/sandbox"
}
