import time
import boto3
import sys
import socket
import os                                
import io

client = boto3.client('dynamodb')



stmt = "SELECT * FROM dbapp where docnum = '79215140'"
   
response = client.execute_statement(Statement= stmt)

print(response["Items"])
