# API Gateway resource
resource "aws_api_gateway_rest_api" "APIGateway" {
  name        = "rsalinas-users-api"
  description = "users api"
}

