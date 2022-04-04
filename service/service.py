import os

import boto3


class Service:
    def __init__(self, s3_client):
        self._s3_client = s3_client

    @classmethod
    def from_environ(cls):
        return cls(s3_client=boto3.Session().client("s3"))

    def list_objects(self):
        return self._s3_client.list_objects(Bucket=os.environ["S3_BUCKET_NAME"])
