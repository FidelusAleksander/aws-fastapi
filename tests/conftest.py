import os
import shlex
import subprocess

import pytest
from mock import Mock
from service.service import Service
import boto3

TEST_DATA_DIR = os.path.join(os.path.dirname(__file__), "test_data")


@pytest.fixture(scope="session", autouse=False)
def aws_environ():
    default_values = {
        "AWS_REGION": "eu-west-1",
        "AWS_DEFAULT_REGION": "eu-west-1",
        "AWS_ACCESS_KEY": "test",
        "AWS_SECRET_ACCESS_KEY": "test",
        "S3_BUCKET_NAME": "aws-test-bucket",
    }
    patched = []

    for key, value in default_values.items():
        if key not in os.environ:
            os.environ[key] = value
            patched.append(key)

    yield

    for key in patched:
        del os.environ[key]


@pytest.fixture(scope="session")
def localstack(aws_environ):
    localstack_id = subprocess.check_output(
        shlex.split(
            'docker run --rm -d -e "SERVICES=s3" -p 4566-4599:4566-4599 localstack/localstack:0.13'
        )
    )
    localstack_id = localstack_id.decode("utf8").strip()

    yield

    subprocess.check_output(["docker", "rm", "-f", localstack_id])


@pytest.fixture(scope="session")
def s3_client(aws_environ, localstack):
    return boto3.client(
        "s3",
        aws_access_key_id=os.environ["AWS_ACCESS_KEY"],
        aws_secret_access_key=os.environ["AWS_SECRET_ACCESS_KEY"],
        endpoint_url="http://localhost:4566",
        region_name=os.environ["AWS_REGION"],
    )


@pytest.fixture(scope="session")
def s3_resource(localstack):
    return boto3.resource(
        "s3",
        aws_access_key_id=os.environ["AWS_ACCESS_KEY"],
        aws_secret_access_key=os.environ["AWS_SECRET_ACCESS_KEY"],
        endpoint_url="http://localhost:4566",
        region_name=os.environ["AWS_REGION"],
    )


@pytest.fixture(scope="session")
def s3_files_bucket(s3_client, s3_resource):
    bucket_name = os.environ["S3_BUCKET_NAME"]
    bucket = s3_resource.Bucket(bucket_name)
    bucket.create(
        CreateBucketConfiguration={"LocationConstraint": os.environ["AWS_REGION"]}
    )
    bucket.wait_until_exists()
    return bucket


@pytest.fixture(scope="session")
def test_data(s3_files_bucket, s3_client):
    filenames = os.listdir(TEST_DATA_DIR)
    for filename in filenames:
        s3_client.upload_file(
            os.path.join(TEST_DATA_DIR, filename),
            os.environ["S3_BUCKET_NAME"],
            filename,
        )
    return filenames


@pytest.fixture()
def service(s3_files_bucket, s3_client):
    return Service(s3_client=s3_client)
