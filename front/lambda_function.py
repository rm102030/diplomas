import json
import os, re, base64
import boto3
from urllib.parse import unquote

def lambda_handler(event, context):
    
    mypage = page_router(event['httpMethod'],event['queryStringParameters'],event['body'])    
    return mypage

def page_router(httpmethod,querystring,formbody):   
   
    if httpmethod == 'GET':
        htmlFile = open('contactus.html', 'r')
        htmlContent = htmlFile.read()
        return {
        'statusCode': 200, 
        'headers': {"Content-Type":"text/html;charset=UTF-8"},
        'body': htmlContent
        }
    
    response = unquote(formbody)
    print(response)
    string = response
    print(string)
    indice_c = string.index('email=') 
    indice_h = string.index('&')
    substring = string[indice_c:indice_h]
    print(string )

    txt = string
    x = txt.split("&")
    print(x)
    ########################################################################
    # Importante si ud coloca un campo antes del email en la tabla debe increntar el valor de X , si tiene error revise los logs de la lambda front
    lista = x[4]
    print(lista)
    
    spl_word = 'email='
    res = lista.split(spl_word, 1)
    global splitString
    splitString = res[1]
    print(splitString)    
    
    client = boto3.client('lambda')
    response = client.update_function_configuration(
        FunctionName= "email",
        Environment={
            'Variables': {
            'RECIPIENT': splitString
                    }
                }
            )
    print(response)
    ########################################################################
    # Proceso que envia a SES el email que recibe de la variable "splitString" para la verificacion de la identidad, ingresar a SES y aceptarla
    client = boto3.client('ses')
    response = client.verify_email_identity(
        EmailAddress = splitString,
    )
    print(response)
    ########################################################################

    if httpmethod == 'POST':
        
        insert_record(formbody)
        
        htmlFile = open('confirm.html', 'r')
        htmlContent = htmlFile.read()
        return {
        'statusCode': 200, 
        'headers': {"Content-Type":"text/html"},
        'body': htmlContent
        }

def insert_record(formbody):
    
    formbody = formbody.replace("=", "' : '")
    formbody = formbody.replace("&", "', '")
    formbody = "INSERT INTO dbapp value {'" + formbody +  "'}"
    
    client = boto3.client('dynamodb')    
    response = client.execute_statement(Statement= formbody)

