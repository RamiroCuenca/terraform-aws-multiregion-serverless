# Create an IAM Role for our Lambda functions
resource "aws_iam_role" "lambda" {
  name = "lambda"

  assume_role_policy = <<EOF
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
EOF
}

# Provide access to DynamoDB for our Lambda functions
resource "aws_iam_policy" "dynamodbAccess" {
  name        = "dynamodb"
  description = "provide admin access to DynamoDB"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Scan",
            "dynamodb:UpdateItem"
        ],
        "Resource": "arn:aws:dynamodb:*:*:table/*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cloudwatchAccess" {
  name        = "cloudwatch"
  description = "let lambda create log groups"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach the policy to LambdaRole
resource "aws_iam_role_policy_attachment" "attachDynamo" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.dynamodbAccess.arn
}

resource "aws_iam_role_policy_attachment" "attachCloudWatch" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.cloudwatchAccess.arn
}