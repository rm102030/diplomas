resource "aws_s3_bucket" "exportdynamojson" {
  bucket = var.aws_bucket_json
  tags = {
    Name        = "My bucket export json"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_public_access_block" "json" {
  bucket = aws_s3_bucket.exportdynamojson.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors_json" {
  bucket = aws_s3_bucket.exportdynamojson.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_ownership_controls" "json" {
  bucket = aws_s3_bucket.exportdynamojson.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "json" {
  depends_on = [
    aws_s3_bucket_ownership_controls.json,
    aws_s3_bucket_public_access_block.json
  ]
  bucket = aws_s3_bucket.exportdynamojson.id
  acl    = "public-read-write"

}