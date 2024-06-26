# Este bucket es para guardar los codigos QR generados con la lambda de generacion que trae un source que es el primer bucket y el detino que es este 
#con las imagenes de los qr
resource "aws_s3_bucket" "qrdiplomas" {
  bucket = var.aws_bucket_qr
  tags = {
    Name        = "My bucket_qr"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_public_access_block" "qrdiplomas" {
  bucket = aws_s3_bucket.qrdiplomas.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors_qr" {
  bucket = aws_s3_bucket.qrdiplomas.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_ownership_controls" "qrdiplomas" {
  bucket = aws_s3_bucket.qrdiplomas.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "qrdiplomas" {
  depends_on = [
    aws_s3_bucket_ownership_controls.qrdiplomas,
    aws_s3_bucket_public_access_block.qrdiplomas
  ]
  bucket = aws_s3_bucket.qrdiplomas.id
  acl    = "public-read-write"

}

##################
# Adding S3 bucket as trigger to my lambda and giving the permissions
##################
resource "aws_s3_bucket_notification" "aws-lambda-trigger-qr" {
  bucket     = aws_s3_bucket.qrdiplomas.id
  depends_on = [aws_lambda_function.qrgenerate]
  lambda_function {
    lambda_function_arn = aws_lambda_function.email.arn
    events              = ["s3:ObjectCreated:*"]
    #filter_prefix       = "file-prefix"
    #filter_suffix       = "file-extension"
  }
}
resource "aws_lambda_permission" "email" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.qrdiplomas.id}"
}
###########
# output of lambda arn
###########
output "arn-qr" {
  value = aws_lambda_function.email.arn
}
