# Aqui se configura la variable del  Endpoint de la API de las Urls Prefirmadas 
resource "local_file" "deployment_template" {
  content = templatefile("scr_front/contactus.html", {
    #API_ENDPOINT = "API_ENDPOINT"
    #API_ENDPOINT = var.aws_region
    API_ENDPOINT = aws_apigatewayv2_stage.default.invoke_url
    STAGE        = var.api_stage
    #API_ENDPOINT = "${aws_apigatewayv2_stage.default.invoke_url}"
    }
  )
  filename = "${path.module}/front/contactus.html"
}

# Aqui se configura la variable del  Endpoint de la DynamoDB 
resource "local_file" "deployment_template_DB" {
  content = templatefile("scr_front/lambda_function.py", {
    #API_ENDPOINT = "API_ENDPOINT"
    #API_ENDPOINT = var.aws_region
    DB_ENDPOINT = var.aws_dynamodb_app
    PRESIGNED = aws_s3_bucket.urlpresigned.id
    #API_ENDPOINT = "${aws_apigatewayv2_stage.default.invoke_url}"
    }
  )
  filename = "${path.module}/front/lambda_function.py"
}


locals {
  layer_zip_path = "qr/layerqr.zip"
  layer_name     = "qr_layer"
  #requirements_path = "${path.root}/../requirements.txt"
}

# Aqui se configura dos variables que llaman a 2 Bucket S3 el de origen y el de destino para generar los QRs  
resource "local_file" "deployment_template_qr" {
  content = templatefile("src_qr/lambda_function.py", {
    PRESIGNED = aws_s3_bucket.urlpresigned.id
    QR        = aws_s3_bucket.qrdiplomas.id
    }
  )
  filename = "${path.module}/qr/lambda_function.py"
}