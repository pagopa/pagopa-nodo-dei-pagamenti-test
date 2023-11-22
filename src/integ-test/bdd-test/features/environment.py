import json
from behave.model import Table
import os, requests
import steps.utils as utils
import time
import steps.db_operation_pg as db
import psycopg2
from psycopg2 import OperationalError    

def before_all(context):
    print('Global settings...')

    myconfigfile = context.config.userdata["conffile"]
    configfile = context.config.userdata.get("configfile", myconfigfile)
    more_userdata = json.load(open(configfile))

  #  more_userdata = json.load(open(os.path.join(context.config.base_dir + "/../resources/config.json")))
    context.config.update_userdata(more_userdata)
    proxyEnabled = context.config.userdata.get("global_configuration").get("proxyEnabled")
    proxies = {
            'http': 'http://10.79.20.33:80',
            'https': 'http://10.79.20.33:80',
        }
	
    if proxyEnabled == False:
        proxies = None
    setattr(context, 'proxies', proxies)
    print('Proxy enabled: ' , proxyEnabled)

    db_selected = context.config.userdata.get("db_configuration").get('nodo_cfg')
    selected_query = utils.query_json(context, 'select_config', 'configurations')
    conn = db.getConnection(db_selected.get('host'), db_selected.get('database'),db_selected.get('user'),db_selected.get('password'),db_selected.get('port'))

    exec_query = db.executeQuery(conn, selected_query)
    db.closeConnection(conn)

    config_dict = {}
    for row in exec_query:
        config_key, config_value = row
        config_dict[config_key] = config_value
    
    setattr(context, 'configurations', config_dict)

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

def after_all(context):
    pass
    # header_host = utils.estrapola_header_host(utils.get_refresh_config_url(context))
    # db_selected = context.config.userdata.get("db_configuration").get('nodo_cfg')
    # conn = db.getConnection(db_selected.get('host'), db_selected.get('database'), db_selected.get('user'), db_selected.get('password'),db_selected.get('port'))
    
    # config_dict = getattr(context, 'configurations')
    # for key, value in config_dict.items():
    #     #print(key, value)
    #     selected_query = utils.query_json(context, 'update_config', 'configurations').replace('value', value).replace('key', key)
    #     db.executeQuery(conn, selected_query)  
    
    # db.closeConnection(conn)
    # headers = {'Host': header_host}  
    # requests.get(utils.get_refresh_config_url(context),verify=False,headers=headers, proxies = getattr(context,'proxies'))


def config_ec(context):
    global_configuration = context.config.userdata.get("global_configuration")

    with open(context.config.base_dir + '/../resources/creditorinstitutions.json', 'r') as reader:
        creditor_institution_code = global_configuration.get("creditor_institution_code")
        payload = reader.read().replace('#creditor_institution_code#', creditor_institution_code)

        context.apiconfig.create_creditor_institution(payload)