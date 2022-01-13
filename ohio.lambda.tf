# Create all the necessary resources for each endpoint

# Create the Lambda function
resource "aws_lambda_function" "function_ohio" {
  provider = aws.ohio

  # for_each      = var.lambda_functions
  for_each = { for record in var.lambda_functions : record.name => record }

  filename      = each.value.zipfile
  function_name = each.value.name
  description   = each.value.description
  role          = aws_iam_role.lambda.arn
  handler       = "main"

  source_code_hash = filebase64sha256(each.value.zipfile)

  runtime = "go1.x"

  tags = {
    method = each.value.method
    path = each.value.path
  }

  depends_on = [
    aws_iam_role_policy_attachment.attachCloudWatch,
    aws_iam_role_policy_attachment.attachDynamo,
    # aws_cloudwatch_log_group.logs,
  ]
}

# Provide our API Gateway with permissions to execute each Lambda function
resource "aws_lambda_permission" "apigateway_lambda_ohio" {
  provider = aws.ohio

  for_each = aws_lambda_function.function_ohio

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*//* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  # source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/${lower(each.value.tags.path)}"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
