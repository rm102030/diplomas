resource "aws_cognito_user_pool" "user_pool" {
  name = "user-pool"
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]  
  password_policy {
    minimum_length = 6
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true    
  }
 
 email_configuration {
    reply_to_email_address = var.aws_identity_ses
  # source_arn             = "arn:aws:ses:us-east-1:840021737375:identity/ricardo.martinez@pragma.com.co"
    source_arn             = "arn:aws:ses:${var.aws_region}:${var.aws_account_id}:identity/${var.aws_identity_ses}"
    email_sending_account  = "DEVELOPER"
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "cognito-client"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  refresh_token_validity = 90
  prevent_user_existence_errors = "ENABLED"
  supported_identity_providers  = ["COGNITO"]
  allowed_oauth_scopes = ["phone", "openid", "email"]
  allowed_oauth_flows  = ["code"]
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
  callback_urls = ["${local.callback_urls}"]
  allowed_oauth_flows_user_pool_client = true
}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = var.aws_domain_cognito
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
}

# Crear un usuario en cognito al inicio de sesion le pide cambio de contraseña, si necesita varios use el recurso de abajo 
resource "aws_cognito_user" "example" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = var.user_cognito

  attributes = {
    email = var.user_cognito
    email_verified = true
  }
  desired_delivery_mediums = ["EMAIL"]
}

resource "null_resource" "cognito_user" {
  depends_on = [ aws_cognito_user.example ]
provisioner "local-exec" {

  command = "aws cognito-idp admin-set-user-password --user-pool-id ${aws_cognito_user_pool.user_pool.id} --username ${var.user_cognito} --password ${var.password_user_cognito}"
}
}

# Multiples Usuarios para cognito descomentarie y ajuste en vars los users 
# resource "null_resource" "cognito_user" {
#   count   = length(var.users)
#   triggers = {
#     user_pool_id = aws_cognito_user_pool.user_pool.id
#   }
# #depends_on = [ aws_cognito_user.example ]
#     # Aqui se crean los usuarios
#     provisioner "local-exec" {
#     command = "aws cognito-idp admin-create-user --user-pool-id ${aws_cognito_user_pool.user_pool.id} --username ${element(var.users, count.index)}"    
#    }
#    # Aqui se asignan los password
#     provisioner "local-exec" {
#     command = "aws cognito-idp admin-set-user-password --user-pool-id ${aws_cognito_user_pool.user_pool.id} --username ${element(var.users, count.index)} --password ${element(var.passwords, count.index)}"
#   }
# }