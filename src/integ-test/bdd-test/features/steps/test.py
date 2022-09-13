def search_tag(json_file: dict, tag: str) -> bool:
    find = False
    for key, value in json_file.items():
        if key == tag: return True
        if isinstance(value, dict):
            find = search_tag(value, tag)
        elif isinstance(value, list):
            for element in value:
                if isinstance(element, dict):
                    find = search_tag(element, tag)
        if find: break
    return find

def search_value(json_file: dict, tag: str) -> bool:
    find = False
    for value in json_file.values():
        if value == tag: return True
        if isinstance(value, dict):
            find = search_value(value, tag)
        elif isinstance(value, list):
            for element in value:
                if isinstance(element, dict):
                    find = search_value(element, tag)
        if find: break
    return find

def get_value_from_key(json_file: dict, tag:str) -> bool:
    find_value = None
    for key, value in json_file.items():
        if key == tag: return value
        if isinstance(value, dict):
            find_value = get_value_from_key(value, tag)
        elif isinstance(value, list):
            for element in value:
                if isinstance(element, dict):
                    find_value = get_value_from_key(element, tag)
        if find_value: break
    return find_value


json_file = {
    "key": "value",
  "data": [{
    "type": "articles",
    "id": "1",
    "attributes": {
      "title": "JSON:API paints my bikeshed!",
      "body": "The shortest article. Ever.",
      "created": "2015-05-22T14:56:29.000Z",
      "updated": "2015-05-22T14:56:28.000Z"
    },
    "relationships": {
      "author": {
        "data": {"id": "42", "type": "people"}
      }
    }
  }],
  "included": [
    {
      "type": "people",
      "id": "42",
      "attributes": {
        "name": "John",
        "age": 80,
        "gender": "male"
      }
    }
  ],
  "prova": "ciao"
}


print(search_tag(json_file, "ciao"))