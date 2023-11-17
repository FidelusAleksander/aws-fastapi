import os

from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from service import Service

app = FastAPI()
service = Service.from_environ()


@app.get("/")
def hello():
    return "hello world (:"


@app.get("/list_objects")
def list_objects():
    return service.list_objects()


@app.get("/sign_url")
def sign_url(key: str):
    return RedirectResponse(url=service.generate_presigned_url(key))
