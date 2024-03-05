import json
from behave.model import Table
import os
import steps.utils as utils
import requests
if 'NODOPGDB' in os.environ:
    import steps.db_operation_pg as db
    import psycopg2
    from psycopg2 import OperationalError    
else:
    import steps.db_operation as db
    import cx_Oracle

if 'APICFG' in os.environ:
    import steps.db_operation_apicfg_testing_support as db

#import allure
import sys
from io import StringIO


def before_all(context):
    print('Global settings...')

    lib_dir = ""
    if 'NODOPGDB' not in os.environ:
        user_profile = os.environ.get("USERPROFILE")
        
        if user_profile != None:
            lib_dir = r"\Program Files\Oracle\instantclient_19_9"
            print("#####################lib_dir", lib_dir)
            setattr(context, f'user_profile', user_profile)
        else:
            lib_dir = os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, os.pardir, os.pardir, os.pardir, 'oracle', 'instantclient_21_6'))
            print("#####################lib_dir", lib_dir) 
     
        cx_Oracle.init_oracle_client(lib_dir = lib_dir)
    # -D conffile=src/integ-test/bdd-test/resources/config_sit.json
    myconfigfile = context.config.userdata["conffile"]
    #configfile = context.config.userdata.get("configfile", myconfigfile)
    more_userdata = json.load(open(myconfigfile))

    #  more_userdata = json.load(open(os.path.join(context.config.base_dir + "/../resources/config.json")))
    context.config.update_userdata(more_userdata)
    if 'APICFG' in os.environ:
        apicfg_testing_support_service = context.config.userdata.get("services").get("apicfg-testing-support")
        db.set_address(apicfg_testing_support_service)

    db_selected = context.config.userdata.get("db_configuration").get('nodo_cfg')
    selected_query = utils.query_json(context, 'select_config', 'configurations')
    conn = db.getConnection(db_selected.get('host'), db_selected.get('database'),db_selected.get('user'),db_selected.get('password'),db_selected.get('port'))

    exec_query = db.executeQuery(conn, selected_query, as_dict=True)
    db.closeConnection(conn)

    config_dict = {}
    for row in exec_query:
        config_key, config_value = row
        config_dict[config_key] = config_value
    
    setattr(context, 'configurations', config_dict)


def before_feature(context, feature):
    services = context.config.userdata.get("services")
    # add heading
    feature.background.steps[0].table = Table(headings=("name", "url", "healthcheck", "soap_service", "rest_service", "subscription_key_name"))
    # add data in the tables
    for system_name in services.keys():
        row = (system_name,
               services.get(system_name).get("url", ""),
               services.get(system_name).get("healthcheck", ""),
               services.get(system_name).get("soap_service", ""),
               services.get(system_name).get("rest_service", ""),
               services.get(system_name).get("subscription_key_name", ""))
        feature.background.steps[0].table.add_row(row)

    # DISABLE see @config-ec too 
    # for tag in feature.tags:
    #     if tag == 'config-ec':
    #         config_ec(context)

# def before_scenario(context, scenario):
#     context.stdout_capture = StringIO()
#     context.original_stdout = sys.stdout
#     sys.stdout = context.stdout_capture

# def after_scenario(context, scenario):
#     try:
#         #sys.stdout = sys.__stdout__
#         sys.stdout = context.original_stdout
        
#         context.stdout_capture.seek(0)
#         captured_stdout = context.stdout_capture.read()
        
#         allure.attach(captured_stdout, name="stdout", attachment_type=allure.attachment_type.TEXT)
#         context.stdout_capture.close()

#         print("\nCaptured stdout:\n", captured_stdout)  # Stampa l'output nel terminale

#     except Exception as e:
#         print("Eccezione " + e)



def after_feature(context, feature):
    global_configuration = context.config.userdata.get("global_configuration")

    # DISABLE see @config-ec too 
    # for tag in feature.tags:
    #     if tag == 'config-ec':
    #         # reset apiconfig
    #         context.apiconfig.delete_creditor_institution(global_configuration.get("creditor_institution_code"))

def after_all(context):
    pass
    # db_selected = context.config.userdata.get("db_configuration").get('nodo_cfg')
    # conn = db.getConnection(db_selected.get('host'), db_selected.get('database'), db_selected.get('user'), db_selected.get('password'),db_selected.get('port'))

    # config_dict = getattr(context, 'configurations')
    # update_config_query = "update_config_postgresql" if 'NODOPGDB' in os.environ else "update_config_oracle"
    # for key, value in config_dict.items():
    #     #print(key, value)
    #     selected_query = utils.query_json(context, update_config_query, 'configurations').replace('value', value).replace('key', key)
    #     db.executeQuery(conn, selected_query)  
    
    # db.closeConnection(conn)
    # headers = {'Host': 'api.dev.platform.pagopa.it:443'}  
    # requests.get(utils.get_refresh_config_url(context), verify=False, headers=headers)


def config_ec(context):
    global_configuration = context.config.userdata.get("global_configuration")

    with open(context.config.base_dir + '/../resources/creditorinstitutions.json', 'r') as reader:
        creditor_institution_code = global_configuration.get("creditor_institution_code")
        payload = reader.read().replace('#creditor_institution_code#', creditor_institution_code)

        context.apiconfig.create_creditor_institution(payload)