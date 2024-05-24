# Esta lambda es para cargar los imagenes a bucket S3 y genera las urls autofirmadas para que se puedan consultar de manera publica
data "archive_file" "email_artefact" {
  output_path = "files/email-artefact.zip"
  type        = "zip"
  source_dir  = "${path.module}/email"
  depends_on  = [local_file.deployment_template]
}

resource "aws_lambda_function" "email" {
  function_name = "email"
  handler       = "lambda_function.lambda_handler"
  description   = "Email"
  role          = aws_iam_role.front_lambda.arn
  # Se reusa el rol de front
  runtime = "python3.12"


  filename         = data.archive_file.email_artefact.output_path
  source_code_hash = data.archive_file.email_artefact.output_base64sha256

  timeout     = 10
  memory_size = 128
  #   environment {
  #     variables = {
  #       API_ENDPOINT = aws_apigatewayv2_stage.default.invoke_url
  #       DB_ENDPOINT  = var.aws_dynamodb_app

  #     }
  #   }
}
