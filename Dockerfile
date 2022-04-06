FROM python:3.8-slim
WORKDIR /code
COPY ./service/ /code/
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]
