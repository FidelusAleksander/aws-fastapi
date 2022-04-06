import os

from fastapi import FastAPI
from service.service import Service

app = FastAPI()
service = Service.from_environ()


@app.get("/")
def hello():
    return "hello world :)"


@app.get("/listObjects")
def list_objects():
    return service.list_objects()


@app.get("/bucketName")
def bucket_name():
    return os.environ.get("S3_BUCKET_NAME")
