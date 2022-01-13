# resource "aws_cloudwatch_log_subscription_filter" "logging" {
#   for_each = aws_lambda_function.function

#   # depends_on      = [aws_lambda_permission.function]
#   destination_arn = each.value.arn
# #   role_arn        = aws_iam_role.lambda.arn
#   filter_pattern  = ""
#   log_group_name  = aws_cloudwatch_log_group.logs[each.key].name
#   name            = "${each.value.function_name}_logs"
# }

resource "aws_cloudwatch_log_group" "logs" {
  for_each = aws_lambda_function.function

  name = "/aws/lambda/${each.value.function_name}"
}
