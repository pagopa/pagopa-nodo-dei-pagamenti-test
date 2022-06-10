import json
import random

import steps.db_operation as db
from behave.model import Table
import os, cx_Oracle


def before_all(context):
    print('Global settings...')

    #lib_dir = os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, os.pardir, os.pardir, os.pardir, 'instantclient_21_3'))
    #cx_Oracle.init_oracle_client(lib_dir = lib_dir)
    more_userdata = json.load(open(os.path.join(context.config.base_dir + "/../resources/pipeline_config.json")))
    context.config.update_userdata(more_userdata)
    services = context.config.userdata.get("services")
    db_config = context.config.userdata.get("db_configuration")

def before_feature(context, feature):
    services = context.config.userdata.get("services")
    # add heading
    feature.background.steps[0].table = Table(headings=("name", "url", "healthcheck", "soap_service", "rest_service"))
    # add data in the tables
    for system_name in services.keys():
        row = (system_name,
               services.get(system_name).get("url", ""),
               services.get(system_name).get("healthcheck", ""),
               services.get(system_name).get("soap_service", ""),
               services.get(system_name).get("rest_service", ""))
        feature.background.steps[0].table.add_row(row)

    # DISABLE see @config-ec too 
    # for tag in feature.tags:
    #     if tag == 'config-ec':
    #         config_ec(context)


def after_feature(context, feature):
    global_configuration = context.config.userdata.get("global_configuration")

    # DISABLE see @config-ec too 
    # for tag in feature.tags:
    #     if tag == 'config-ec':
    #         # reset apiconfig
    #         context.apiconfig.delete_creditor_institution(global_configuration.get("creditor_institution_code"))

def config_ec(context):
    global_configuration = context.config.userdata.get("global_configuration")

    with open(context.config.base_dir + '/../resources/creditorinstitutions.json', 'r') as reader:
        creditor_institution_code = global_configuration.get("creditor_institution_code")
        payload = reader.read().replace('#creditor_institution_code#', creditor_institution_code)

        context.apiconfig.create_creditor_institution(payload)
