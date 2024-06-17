data "archive_file" "json_artefact" {
  output_path = "files/json-artefact.zip"
  type        = "zip"
  source_file = "${local.lambdas_path_json}/index.js"
}

resource "aws_lambda_function" "json" {
  function_name = "exportdynamodb"
  handler       = "index.handler"
  description   = "Export Dynamodb Json File"
  role          = aws_iam_role.json_lambda.arn
  runtime       = "nodejs16.x"

  filename         = data.archive_file.json_artefact.output_path
  source_code_hash = data.archive_file.json_artefact.output_base64sha256

  timeout     = 6
  memory_size = 128
}
