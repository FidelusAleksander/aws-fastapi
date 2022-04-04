import os
import shlex
import subprocess

import pytest
from mock import Mock
from service.service import Service
import boto3


@pytest.fixture(scope="session", autouse=True)
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
    if os.environ.get("DONT_RUN_DOCKER_FOR_TESTS"):
        yield
    else:
        localstack_id = subprocess.check_output(
            shlex.split(
                'docker run --rm -d -e "SERVICES=s3" -p 4566-4599:4566-4599 localstack/localstack:0.13'
            )
        )
        localstack_id = localstack_id.decode("utf8").strip()

        yield

        subprocess.check_output(["docker", "rm", "-f", localstack_id])


@pytest.fixture(scope="session")
def s3_client_factory(aws_environ, localstack):
    return lambda: boto3.client(
        "s3",
        aws_access_key_id=os.environ["AWS_ACCESS_KEY"],
        aws_secret_access_key=os.environ["AWS_SECRET_ACCESS_KEY"],
        endpoint_url="http://localhost:4566",
        region_name=os.environ["AWS_REGION"],
    )


@pytest.fixture(scope="session")
def s3_client(s3_client_factory):
    return s3_client_factory()


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


@pytest.fixture()
def service(s3_files_bucket, s3_client):
    return Service(s3_client=s3_client)
