variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_account_id" {
  type    = string
  default = "840021737375"
}

variable "aws_profile" {
  type    = string
  default = "840021737375_pragma-ps-cloudops-services"
}

variable "aws_bucket_presigned" {
  type    = string
  default = "urlprefirmadas"
}

variable "aws_bucket_qr" {
  type    = string
  default = "qr-diplomas"
}

variable "aws_dynamodb_app" {
  type    = string
  default = "dbapp"
}

variable "table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  default     = "PAY_PER_REQUEST"

}
variable "api_stage" {
  description = "Stage a Desplegar."
  type        = string
  default     = "dev"

}