# Esta lambda es para generar los codigos QR
data "archive_file" "qrgenerate_artefact" {
  output_path = "files/qr-artefact.zip"
  type        = "zip"
  source_dir  = "${path.module}/qr"
  depends_on  = [local_file.deployment_template_qr]
}

resource "aws_lambda_function" "qrgenerate" {
  function_name = "qrgenerate"
  handler       = "lambda_function.lambda_handler"
  description   = "QR-Generate"
  role          = aws_iam_role.qr_lambda.arn
  runtime       = "python3.12"
  layers        = [aws_lambda_layer_version.my-lambda-layer.arn]



  filename         = data.archive_file.qrgenerate_artefact.output_path
  source_code_hash = data.archive_file.qrgenerate_artefact.output_base64sha256

  timeout     = 20
  memory_size = 128
  #   environment {
  #     variables = {
  #       API_ENDPOINT = aws_apigatewayv2_stage.default.invoke_url
  #       DB_ENDPOINT  = var.aws_dynamodb_app

  #     }
  #   }
}

# create lambda layer from s3 object
resource "aws_lambda_layer_version" "my-lambda-layer" {
  s3_bucket           = aws_s3_bucket.lambda_layer_bucket.id
  s3_key              = aws_s3_object.lambda_layer_zip.key
  layer_name          = local.layer_name
  compatible_runtimes = ["python3.12"]
  skip_destroy        = true
  depends_on          = [aws_s3_object.lambda_layer_zip] # triggered only if the zip file is uploaded to the bucket
}