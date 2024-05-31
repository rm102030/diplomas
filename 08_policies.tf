resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket     = aws_s3_bucket.urlpresigned.id
  #depends_on = [aws_s3_bucket.urlpresigned]
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicListGet",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:List*",
                "s3:Get*",
                "s3:Put*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.aws_bucket_presigned}/*"               
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_policy" "bucket_policy_qr" {
  bucket = aws_s3_bucket.qrdiplomas.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicListGet1",
            "Effect": "Allow",
            "Principal": "*",
            "Principal": {
            "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.front_lambda.name}"
            },
            "Action": [
                "s3:List*",
                "s3:Get*"
            ],
            "Resource": [                
                "arn:aws:s3:::${var.aws_bucket_qr}/*"
            ]
        }              
    ]
}
EOF
}

# Policy para permitir get al fondo de pantalla del front desde el bucket S3

resource "aws_s3_bucket_policy" "bucket_policy_fondo_pantalla" {
  bucket = aws_s3_bucket.fondo_front_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.fondo_de_pantalla]
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicListGet",
            "Effect": "Allow",
            "Principal": "*",
            "Principal": "*",            
            "Action": [                
                "s3:Get*"
            ],
            "Resource": [                
                "arn:aws:s3:::${var.aws_bucket_fondo_de_pantalla}/*"
            ]
        }              
    ]
}
EOF
}

data "aws_caller_identity" "current" {}

# Rol para la lambda de QR que permite hacer put de los archivos (cod¡gos qr) en S3

resource "aws_iam_role_policy" "sts_assumerole_lambda" {
  name   = "sts-assumerole-lambda"
  role   = aws_iam_role.qr_lambda.name
  policy = <<-EOF
{
    "Statement": [
        {
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:PutLifecycleConfiguration",
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.aws_bucket_presigned}/*"             
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}