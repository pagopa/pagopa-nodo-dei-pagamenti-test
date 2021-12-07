import json

from behave.model import Table

import apiconfig


def before_all(context):
    print('Global settings...')

    more_userdata = json.load(open(context.config.base_dir + "/../resources/config.json"))
    context.config.update_userdata(more_userdata)
    services = context.config.userdata.get("services")

    # apiconfig configuration
    apiconfig_url = services.get("api-config").get("url") + services.get("api-config").get("rest_service")
    pagopa_apiconfig = apiconfig.ApiConfig(apiconfig_url)
    setattr(context, "apiconfig", pagopa_apiconfig)


def before_feature(context, feature):
    services = context.config.userdata.get("services")
    # add heading
    feature.background.steps[0].table = Table(headings=("name", "url", "healthcheck", "soap_service", "rest_service"))
    # add data in the table
    for system_name in services.keys():
        row = (system_name,
               services.get(system_name).get("url"),
               services.get(system_name).get("healthcheck"),
               services.get(system_name).get("soap_service"),
               services.get(system_name).get("rest_service"))
        feature.background.steps[0].table.add_row(row)

    for tag in feature.tags:
        if tag == 'config-ec':
            config_ec(context)


def after_feature(context, feature):
    global_configuration = context.config.userdata.get("global_configuration")

    for tag in feature.tags:
        if tag == 'config-ec':
            # reset apiconfig
            context.apiconfig.delete_creditor_institution(global_configuration.get("creditor_institution_code"))


def config_ec(context):
    global_configuration = context.config.userdata.get("global_configuration")

    with open(context.config.base_dir + '/../resources/creditorinstitutions.json', 'r') as reader:
        creditor_institution_code = global_configuration.get("creditor_institution_code")
        payload = reader.read().replace('#creditor_institution_code#', creditor_institution_code)

        context.apiconfig.create_creditor_institution(payload)
