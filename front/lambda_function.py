import json
import os, re, base64
import boto3
from urllib.parse import unquote
from datetime import datetime

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
    lista = x[5]
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
        
        htmlFile = open('contactus.html', 'r')
        htmlContent = htmlFile.read()
        return {
        'statusCode': 200, 
        'headers': {"Content-Type":"text/html"},
        'body': htmlContent
        }

def insert_record(formbody):
    #Se agrega la variable ARCHIVO para guardar el nombre de la imagen que esta en el bucket S3 y que se guarda en Dybamodb
    #Por eso agregamos la letra c al final de formbody
    s3 = boto3.resource('s3') 
    my_bucket = s3.Bucket('urlprefirmadas')    
    last_modified_date = datetime(1939, 9, 1).replace(tzinfo=None)
    for file in my_bucket.objects.all():
        file_date = file.last_modified.replace(tzinfo=None)
        if last_modified_date < file_date:
            last_modified_date = file_date    
            
    for file in my_bucket.objects.all():
            if file.last_modified.replace(tzinfo=None) == last_modified_date:
                #print(file.key)
                #print(last_modified_date)
                archivo =file.key                
                print(archivo)
    
    formbodyc = f"{formbody}&certificado={archivo}"
    print (formbodyc)
    formbodyc = formbodyc.replace("=", "' : '")
    formbodyc = formbodyc.replace("&", "', '")
    formbodyc = "INSERT INTO dbapp value {'" + formbodyc +  "'}"
    
    client = boto3.client('dynamodb')    
    response = client.execute_statement(Statement= formbodyc)

