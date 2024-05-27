import qrcode
import io
import boto3
import base64
import json

def lambda_handler(event, context):
    from datetime import datetime

    import boto3
   
    s3 = boto3.resource('s3')

    my_bucket = s3.Bucket('urlprefirmadas')

    last_modified_date = datetime(1939, 9, 1).replace(tzinfo=None)
    for file in my_bucket.objects.all():
        file_date = file.last_modified.replace(tzinfo=None)
        if last_modified_date < file_date:
            last_modified_date = file_date

    #print(last_modified_date)

    # you can have more than one file with this date, so you must iterate again
    for file in my_bucket.objects.all():
        if file.last_modified.replace(tzinfo=None) == last_modified_date:
            #print(file.key)
            #print(last_modified_date)
            archivo =file.key
            print(archivo)
            url = f"https://{'urlprefirmadas'}.s3.us-east-1.amazonaws.com/{archivo}"
            print(url)
            
    # Initialize a session using Amazon S3
    s3 = boto3.client('s3')        
    # Generate QR code
    img = qrcode.make(url)
    img_bytes = io.BytesIO()
    img.save(img_bytes)
    img_bytes = img_bytes.getvalue()
    
    # Generate a unique filename
    filename = url.split("://")[1].replace("/", "_") + '.png'
    
    # Upload the QR code to the S3 bucket
    s3.put_object(Bucket='qr-diplomas', Key=filename, Body=img_bytes, ContentType='image/png', ACL='public-read')
    
    # Generate the URL of the uploaded QR code
    location = s3.get_bucket_location(Bucket='qr-diplomas')['LocationConstraint']
    region = '' if location is None else f'{location}'
    qr_code_url = f"https://{'qr-diplomas'}.s3{region}.amazonaws.com/{filename}"
    
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'QR code generated and uploaded to S3 bucket successfully!', 'qr_code_url': qr_code_url})
    }


