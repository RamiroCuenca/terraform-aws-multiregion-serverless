# DynamoDB main table
resource "aws_dynamodb_table" "users_virginia" {
  name             = "rcs-serverless-users"
  hash_key         = "id"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }
}

# Dynamo Replica table
resource "aws_dynamodb_table" "users_ohio" {
  provider = aws.ohio

  name             = "rcs-serverless-users"
  hash_key         = "id"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_global_table" "users" {
  depends_on = [
    aws_dynamodb_table.users_virginia,
    aws_dynamodb_table.users_ohio,
  ]

  name = "rcs-serverless-users"

  replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "us-east-2"
  }
}