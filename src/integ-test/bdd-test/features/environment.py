import requests
import json

# TODO remove the following variable
ec="77777777777"


def before_all(context):
    print('Global settings...')

    more_userdata = json.load(open(context.config.base_dir + "/../resources/config.json"))
    context.config.update_userdata(more_userdata)

    url_api_config = context.config.userdata.get("api-config").get("url") + context.config.userdata.get("api-config").get("service") + "/creditorinstitutions"
    headers = {'Content-Type': 'application/json'}  # set what your server accepts

    with open(context.config.base_dir + '/../resources/creditorinstitutions.json', 'r') as reader:
        payload = reader.read().replace('#creditor_institution_code#', ec)
        nodo_response = requests.post(url_api_config, payload, headers=headers)
        # check created or conflict
        assert nodo_response.status_code == 201 or nodo_response.status_code == 409, f"creditorinstitutions {ec}"


def before_feature(context, feature):
    keys = [key for key in context.config.userdata.keys() if not key.startswith("_")]
    for system_name in keys:
        row = (system_name,
               context.config.userdata.get(system_name).get("url"),
               context.config.userdata.get(system_name).get("healthcheck"),
               context.config.userdata.get(system_name).get("service"))
        feature.background.steps[0].table.add_row(row)
