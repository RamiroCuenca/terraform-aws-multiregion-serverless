# Create an IAM Role for our Lambda functions
resource "aws_iam_role" "lambdaRole" {
  name = "iamrole_for_lambda"

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
resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"

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
        "Resource": "arn:aws:dynamodb:us-east-1:730269305302:table/*"
    }
  ]
}
EOF
}

# Attach the policy to LambdaRole
resource "aws_iam_role_policy_attachment" "policyAttach" {
  role       = aws_iam_role.iamrole_for_lambda.name
  policy_arn = aws_iam_policy.policy.arn
}