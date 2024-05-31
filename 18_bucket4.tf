# Este bucket es para guardar el fondo de pantalla para el front
resource "aws_s3_bucket" "fondo_front_bucket" {
  bucket = var.aws_bucket_fondo_de_pantalla
}

# upload zip file to s3
resource "aws_s3_object" "fondo_front_bucket" {
  bucket = aws_s3_bucket.fondo_front_bucket.id
  key    = "fondo_de_pantalla.png"
  source = "fondo_de_pantalla.png"
}

resource "aws_s3_bucket_public_access_block" "fondo_de_pantalla" {
  bucket = aws_s3_bucket.fondo_front_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "fondo_de_pantalla" {
  bucket = aws_s3_bucket.fondo_front_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

output "url_fondo" {
    description = "url of the bucket"
    value       = "https://${aws_s3_bucket.fondo_front_bucket.id}.s3.${aws_s3_bucket.fondo_front_bucket.region}.amazonaws.com/${aws_s3_object.fondo_front_bucket.key}"
}
