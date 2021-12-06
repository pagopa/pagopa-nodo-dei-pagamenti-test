import requests

ec="77777777777"

def before_all(context):
    print('Global settings...')
    url_api_config = "http://localhost:8080/apiconfig/api/v1/creditorinstitutions"
    headers = {'Content-Type': 'application/json'}  # set what your server accepts

    with open('src/integ-test/bdd-test/resources/creditorinstitutions.json', 'r') as reader:
        payload=reader.read().replace('#creditor_institution_code#', ec)
        nodo_response = requests.post(url_api_config, payload, headers=headers)
        # check created or conflict
        assert nodo_response.status_code == 201 or nodo_response.status_code == 409, f"creditorinstitutions {ec}"
    
