import boto3
import hashlib
import json
import urllib
import os
 
def lambda_handler(event, context):
    print(event)
    print(context)
    return "hello"