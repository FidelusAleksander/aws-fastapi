import os
from typing import Dict
import boto3


class Service:
    def __init__(self, s3_client):
        self._s3_client = s3_client

    @classmethod
    def from_environ(cls):
        return cls(s3_client=boto3.Session().client("s3"))

    def list_objects(self):
        return self._s3_client.list_objects(Bucket=os.environ["S3_BUCKET_NAME"])

    def generate_presigned_url(self, key, expires_in: int = 300):
        return self._s3_client.generate_presigned_url(
            ClientMethod="get_object",
            Params={"Bucket": os.environ["S3_BUCKET_NAME"], "Key": key},
            ExpiresIn=expires_in,
        )
