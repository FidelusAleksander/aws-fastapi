import os

from fastapi import FastAPI
from service import Service

app = FastAPI()
service = Service.from_environ()


@app.get("/")
def hello():
    return "hello world :)"


@app.get("/listObjects")
def list_objects():
    return service.list_objects()


@app.get("/cv")
def get_cv():
    return service.generate_presigned_url("cv_Fidelus_Aleksander.pdf")
