data "archive_file" "src_artefact" {
  output_path = "files/src-artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path}/app.js"
}

resource "aws_lambda_function" "src" {
  function_name = "src"
  handler       = "app.handler"
  description   = "Upload image to s3 Presigned"
  role          = aws_iam_role.src_lambda.arn
  runtime       = "nodejs16.x"



  filename         = data.archive_file.src_artefact.output_path
  source_code_hash = data.archive_file.src_artefact.output_base64sha256

  timeout     = 7
  memory_size = 128
  environment {
    variables = {
      UploadBucket = var.aws_bucket_presigned

    }
  }
}
