output "gateway_virginia_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

output "gateway_ohio_url" {
  value = aws_api_gateway_deployment.deployment_ohio.invoke_url
}