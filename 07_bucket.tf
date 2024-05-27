resource "aws_s3_bucket" "urlpresigned" {
  bucket = var.aws_bucket_presigned

  tags = {
    Name        = "My bucket images"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_public_access_block" "urlpresigned" {
  bucket = aws_s3_bucket.urlpresigned.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  bucket = aws_s3_bucket.urlpresigned.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_ownership_controls" "urlpresigned" {
  bucket = aws_s3_bucket.urlpresigned.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "urlpresigned" {
  depends_on = [
    aws_s3_bucket_ownership_controls.urlpresigned,
    aws_s3_bucket_public_access_block.urlpresigned
  ]
  bucket = aws_s3_bucket.urlpresigned.id
  acl    = "public-read-write"

}


##################
# Adding S3 bucket as trigger to my lambda and giving the permissions
##################
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.urlpresigned.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.qrgenerate.arn
    events              = ["s3:ObjectCreated:*"]
    #filter_prefix       = "file-prefix"
    #filter_suffix       = "file-extension"
  }
}
resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.qrgenerate.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.urlpresigned.id}"
}
###########
# output of lambda arn
###########
output "arn" {
  value = aws_lambda_function.qrgenerate.arn
}
