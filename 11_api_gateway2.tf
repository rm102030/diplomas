# Este API es la principal del Front
resource "aws_api_gateway_rest_api" "front" {
  name        = "front"
  description = "Front"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.front.id
  parent_id   = aws_api_gateway_rest_api.front.root_resource_id
  path_part   = "front"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.front.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "GET"
  authorization = "NONE"

}

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.front.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration_post" {
  rest_api_id             = aws_api_gateway_rest_api.front.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.front.invoke_arn
}


resource "aws_api_gateway_integration" "lambda_integration_get" {
  rest_api_id             = aws_api_gateway_rest_api.front.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.front.invoke_arn
}

resource "aws_api_gateway_deployment" "front" {
  rest_api_id = aws_api_gateway_rest_api.front.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.front.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.post, aws_api_gateway_integration.lambda_integration_post, aws_api_gateway_method.get, aws_api_gateway_integration.lambda_integration_get]
}
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.front.id
  rest_api_id   = aws_api_gateway_rest_api.front.id
  stage_name    = var.api_stage
}

#Autorizador de Lambda para ejecutar la invovacion desde el Api Gateway

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = aws_lambda_function.front.function_name
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.front.execution_arn}/*/*/*"
}