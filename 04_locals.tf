locals {
  lambdas_path      = "${path.module}/src"
  lambdas_path_json = "${path.module}/json"

  common_tags = {
    Project   = "Lambda Presigned with Terraform"
    CreatedAt = formatdate("YYYY-MM-DD", timestamp())
    ManagedBy = "Terraform"
    Owner     = "Ricardo Martinez"
  }
}
locals {
  callback_urls = "${aws_api_gateway_deployment.front.invoke_url}${aws_api_gateway_stage.stage.stage_name}/${aws_api_gateway_resource.root.path_part}"

}