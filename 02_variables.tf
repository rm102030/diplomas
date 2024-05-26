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
variable "aws_identity_ses" {
default = "ricardo.martinez@pragma.com.co"
}
variable "aws_domain_cognito"{
  default = "lugareslejanos"
}

# Usuario para Cognito... al ingresar le pide cambio de contraseña
variable "user_cognito" {
  default = "ricardomartinezcun@gmail.com"
}

variable "password_user_cognito" {
  default = "Progen2024*"
}

# #Multiples usuarios para cognito coloquelos separados por , 
# variable "users" {
#   default = ["user1@email.com", "user2@email.com"]
# }

# variable "passwords" {
#   default = ["Password1*", "Password2*"]
# }
