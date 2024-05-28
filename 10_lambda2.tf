# Esta lambda es para cargar los imagenes a bucket S3 y genera las urls autofirmadas para que se puedan consultar de manera publica
data "archive_file" "front_artefact" {
  output_path = "files/front-artefact.zip"
  type        = "zip"
  source_dir  = "${path.module}/front"
  depends_on  = [local_file.deployment_template, local_file.deployment_template_DB]
}

resource "aws_lambda_function" "front" {
  function_name = "front"
  handler       = "lambda_function.lambda_handler"
  description   = "Front"
  role          = aws_iam_role.front_lambda.arn
  runtime       = "python3.12"



  filename         = data.archive_file.front_artefact.output_path
  source_code_hash = data.archive_file.front_artefact.output_base64sha256

  timeout     = 10
  memory_size = 128
  environment {
    variables = {
      API_ENDPOINT = aws_apigatewayv2_stage.default.invoke_url
      DB_ENDPOINT  = var.aws_dynamodb_app

    }
  }
}

