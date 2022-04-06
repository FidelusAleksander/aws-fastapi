def test_list_objects(service, test_data):
    objects = service.list_objects()
    file_keys = [item["Key"] for item in objects["Contents"]]
    assert sorted(file_keys) == sorted(test_data)


def test_generate_presigned_url(service, test_data):
    service.generate_presigned_url()
