def test_list_objects(service, test_data):
    objects = service.list_objects()

    assert sorted(objects) == sorted(test_data)


def test_generate_presigned_url(service, test_data):
    url = service.generate_presigned_url(key=test_data[0])
    assert test_data[0] in url
