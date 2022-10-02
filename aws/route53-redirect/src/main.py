import os


def redirect_request(event, context):
    return {"statusCode": 301, "headers": {"Location": os.environ["TO_URL"]}}
