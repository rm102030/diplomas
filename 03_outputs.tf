output "Api_S3_Presigned_url" {
  description = "Url Apigateway S3 Presigned."
  value       = aws_apigatewayv2_stage.default.invoke_url
}
output "Api_Front_url" { 
  description = "Url Apigateway Front"
  value = "${aws_api_gateway_deployment.front.invoke_url}${aws_api_gateway_stage.stage.stage_name}/${aws_api_gateway_resource.root.path_part}"
  }
output "Cognito_login_url" {
  value = "https://${aws_cognito_user_pool_domain.cognito-domain.domain}.auth.${var.aws_region}.amazoncognito.com/login?response_type=code&client_id=${aws_cognito_user_pool_client.client.id}&redirect_uri=${local.callback_urls}"
}