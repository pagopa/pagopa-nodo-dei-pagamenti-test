import json
from behave.model import Table
import os
import requests
import steps.utils as utils

if 'APICFG' in os.environ:
    import steps.db_operation_apicfg_testing_support as db

try:
    import allure
except ImportError:
    print(">>>>>>>>>>>>>>>>>No import Allure for Oracle pipeline")

try:
    import cx_Oracle
except ModuleNotFoundError:
    print(">>>>>>>>>>>>>>>>>No import CX_ORACLE for Postgres pipeline")
    
import sys
from io import StringIO

user_profile = os.environ.get("USERPROFILE")


def before_all(context):
    print('Global settings...')

    myconfigfile = context.config.userdata["conffile"]
    more_userdata = json.load(open(myconfigfile))
    context.config.update_userdata(more_userdata)

    proxyEnabled = context.config.userdata.get("global_configuration").get("proxyEnabled")
    dbRun = context.config.userdata.get("global_configuration").get("dbRun")
    setattr(context, 'dbRun', dbRun)
    ####MY CREDENTIALS
    ####RUN DA LOCALE
    if dbRun == "Postgres":
        if user_profile != None:
            # username_my_system = os.environ.get("MYCREDUSER")
            # password_my_system = os.environ.get("MYCREDPASS")
            # my_cred = {
            #     'username': username_my_system,
            #     'password': password_my_system,
            # }
            #setattr(context, 'my_credentials', my_cred)
            setattr(context, 'user_profile', user_profile)

        print(f"Proxy enabled: {proxyEnabled}")
        if proxyEnabled == 'True':
            ####RUN DA LOCALE
            if user_profile != None:
                proxies = {
                    'http': 'http://cipchtritonws01.office.corp.sia.it:8080',
                    'https': 'http://cipchtritonws01.office.corp.sia.it:8080',
                }
            ####RUN IN REMOTO
            else:
                proxies = {
                    'http': 'http://10.79.20.33:80',
                    'https': 'http://10.79.20.33:80',
                }
        else:
            proxies = None
            
        setattr(context, 'proxies', proxies)

    elif dbRun == "Oracle":
        lib_dir = ""
        if user_profile != None:
            lib_dir = r"\Program Files\Oracle\instantclient_19_9"
            print(f"#####################lib_dir {lib_dir}")
            setattr(context, f'user_profile', user_profile)
        else:
            lib_dir = os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, os.pardir, os.pardir, os.pardir, 'oracle', 'instantclient_21_6'))
            print(f"#####################lib_dir {lib_dir}") 
        
        cx_Oracle.init_oracle_client(lib_dir = lib_dir)

    if 'APICFG' in os.environ:
        apicfg_testing_support_service = context.config.userdata.get("services").get("apicfg-testing-support")
        db.set_address(apicfg_testing_support_service)

    db_name = "nodo_cfg"
    db_selected = context.config.userdata.get("db_configuration").get(db_name)
    selected_query = utils.query_json(context, 'select_config', 'configurations')
    adopted_db, conn = utils.get_db_connection_for_env(db_name, db, db_selected)

    exec_query = adopted_db.executeQuery(conn, selected_query, as_dict=True)

    db.closeConnection(conn)
    print("#####CONFIG DICT")
    config_dict = {}
    for row in exec_query:
        print(f"#####ROWWWWWWW {row}")
        config_key, config_value = row
        print(f"#####CONFIGKEY {config_key} E CONFIGVALUE {config_value}")
        config_dict[row[config_key]] = row[config_value]
    
    setattr(context, 'configurations', config_dict)


def before_feature(context, feature):
    services = context.config.userdata.get("services")
    # add heading
    feature.background.steps[0].table = Table(headings=("name", "url", "healthcheck", "soap_service", "rest_service", "refresh_config_service", "subscription_key_name"))

    # add data in the tables
    for system_name in services.keys():
        row = (system_name,
               services.get(system_name).get("url", ""),
               services.get(system_name).get("healthcheck", ""),
               services.get(system_name).get("soap_service", ""),
               services.get(system_name).get("rest_service", ""),
               services.get(system_name).get("refresh_config_service", ""),
               services.get(system_name).get("subscription_key_name", ""))
        feature.background.steps[0].table.add_row(row)


def before_scenario(context, scenario):
    context.stdout_capture = StringIO()
    context.original_stdout = sys.stdout
    sys.stdout = context.stdout_capture


def after_scenario(context, scenario):
    try:
        sys.stdout = context.original_stdout

        context.stdout_capture.seek(0)
        captured_stdout = context.stdout_capture.read()

        allure.attach(captured_stdout, name="stdout", attachment_type=allure.attachment_type.TEXT)
        context.stdout_capture.close()

        # Stampa l'output nel terminale
        print(f"\nCaptured stdout:\n{captured_stdout}")

    except Exception as e:
        print(f"After scenario Eccezione {e}")


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
    #     selected_query = utils.query_json(context, 'update_config', 'configurations').replace('value', f'$${value}$$').replace('key', key)
    #     db.executeQuery(conn, selected_query)

    # db.closeConnection(conn)
    # headers = {'Host': header_host}
    # requests.get(utils.get_refresh_config_url(context),verify=False,headers=headers, proxies = getattr(context,'proxies'))



def config_ec(context):
    global_configuration = context.config.userdata.get("global_configuration")

    # with open(context.config.base_dir + '/../resources/creditorinstitutions.json', 'r') as reader:
    #     creditor_institution_code = global_configuration.get("creditor_institution_code")
    #     payload = reader.read().replace('#creditor_institution_code#', creditor_institution_code)

    #     context.apiconfig.create_creditor_institution(payload)
