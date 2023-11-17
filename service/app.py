import os

from fastapi import FastAPI
from fastapi.responses import RedirectResponse
from typing import List

from service import Service

app = FastAPI()
service = Service.from_environ()


@app.get("/")
def hello() -> str:
    return "hello world (:"


@app.get("/list_objects")
def list_objects() -> List[str]:
    return service.list_objects()


@app.get("/sign_url")
def sign_url(key: str) -> str:
    return service.generate_presigned_url(key)
