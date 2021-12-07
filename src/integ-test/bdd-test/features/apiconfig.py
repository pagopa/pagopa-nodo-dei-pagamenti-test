import requests


class ApiConfig:
    url = None

    def __init__(self, url):
        self.url = url

    def create_creditor_institution(self, body):
        headers = {'ApiKey': 'TODO', 'Content-Type': 'application/json'}  # set what your server accepts
        response = requests.post(self.url + '/creditorinstitutions', body, headers=headers)
        assert response.status_code == 201 or response.status_code == 409

    def delete_creditor_institution(self, code):
        headers = {'ApiKey': 'TODO', 'Content-Type': 'application/json'}  # set what your server accepts
        response = requests.delete(self.url + f'/creditorinstitutions/{code}', headers=headers)
        assert response.status_code == 200 or response.status_code == 404

