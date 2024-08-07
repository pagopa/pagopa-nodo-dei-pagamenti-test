import json
from behave.model import Table
import os
import requests
import steps.utils as utils
import time

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

db_online = None
db_offline = None
db_re = None
db_wfesp = None

SUBKEY = "2da21a24a3474673ad8464edb4a71011"

user_profile = os.environ.get("USERPROFILE")

# Variabile globale per segnalare se lo scenario "after" deve essere eseguito
execute_after_scenario = False

# Lista nome scenari After
list_name_scenario_after = []

# Dict after n nome scenario after n
dict_after_n_name_scenario_n = {}

# Tag after da eseguire
tag_after_selected = '' 

def before_all(context):
    print('Global settings...')
    global user_profile

    myconfigfile = context.config.userdata["conffile"]
    more_userdata = json.load(open(myconfigfile))
    context.config.update_userdata(more_userdata)

    proxyEnabled = context.config.userdata.get("global_configuration").get("proxyEnabled")
    dbRun = context.config.userdata.get("global_configuration").get("dbRun")
    setattr(context, 'dbRun', dbRun)

    if user_profile != None:
        setattr(context, 'user_profile', user_profile)

    if dbRun == "Postgres":
        print(f"Proxy enabled: {proxyEnabled}")
        if proxyEnabled == 'True':
            ####RUN DA LOCALE
            if user_profile != None:
                proxies = {
                    'http': 'http://172.31.253.47:8080',
                    'https': 'http://172.31.253.47:8080',
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
        ####RUN DA LOCALE
        if user_profile != None:
            lib_dir = r"\Program Files\Oracle\instantclient_19_9"
            print(f"#####################lib_dir {lib_dir}")
            setattr(context, f'user_profile', user_profile)
        ####RUN IN REMOTO
        else:
            lib_dir = os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, os.pardir, os.pardir, os.pardir, 'oracle', 'instantclient_21_6'))
            print(f"#####################lib_dir {lib_dir}") 
        
        cx_Oracle.init_oracle_client(lib_dir = lib_dir)


    apicfg_testing_support_service = context.config.userdata.get("services").get("apicfg-testing-support")
    db.set_address(apicfg_testing_support_service)
    
    db_config = context.config.userdata.get("db_configuration")
    db_name = "nodo_cfg"
    db_selected = db_config.get(db_name)
    
    if dbRun == "Oracle":
        db_name = "nodo_cfg"
        db_selected = context.config.userdata.get("db_configuration").get(db_name)
        selected_query = utils.query_json(context, 'select_config', 'configurations')
        adopted_db, conn = utils.get_db_connection_for_env(db_name, db, db_selected)
        exec_query = adopted_db.executeQuery(conn, selected_query, as_dict=True)

        db.closeConnection(conn)

        config_dict = {}
        for row in exec_query:
            config_key, config_value = row
            config_dict[row[config_key]] = row[config_value]
        
        setattr(context, 'configurations', config_dict)
    
    elif dbRun == "Postgres":
        try:
            dbRun = getattr(context, "dbRun")
            db_config = context.config.userdata.get("db_configuration")
            db_name = "nodo_cfg"
            db_selected = db_config.get(db_name)

            adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

            # Call the procedure to reset test data for CONFIGURATION_KEYS table
            print(f"----> SET CONFIGURATION_KEYS...")
            reset_test_data_query = "select nodo4_cfg.resettestdata();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_query)
            
            # Call the procedure to reset test data for CANALI table
            print(f"----> SET CANALI...")
            reset_test_data_canali = "select nodo4_cfg.resettestcanali();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_canali)
            
            # Call the procedure to reset test data for STAZIONI table
            print(f"----> SET STAZIONI...")
            reset_test_data_stazioni = "select nodo4_cfg.resetteststazioni();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_stazioni)
            
            # Call the procedure to reset test data for PA_STAZIONE_PA table
            print(f"----> SET PA_STAZIONE_PA...")
            reset_test_data_pa_stazione_pa = "select nodo4_cfg.resettestpastazionepa();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_pa_stazione_pa)
            
            # Call the procedure to reset test data for CANALI_NODO table
            print(f"----> SET CANALI_NODO...")
            reset_test_data_canali_nodo = "select nodo4_cfg.resettestcanalinodo();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_canali_nodo)             

            adopted_db.closeConnection(conn)
            
            flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

            headers = ''
            header_host = utils.estrapola_header_host(utils.get_refresh_config_url(context))

            if flag_subscription == 'Y':
                headers = {'Host': header_host, 'Ocp-Apim-Subscription-Key': SUBKEY}
            else:
                headers = {'Host': header_host}

            refresh_response = None
        
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False, proxies = getattr(context,'proxies'))

            time.sleep(3)
            assert refresh_response.status_code == 200, f"refresh status code expected: {200} but obtained: {refresh_response.status_code}"

        except Exception as e:
            # Gestione di tutte le altre eccezioni
            print("----->>>> Exception:", e)
            # Interrompiamo il test
            raise e


def before_feature(context, feature):
    global list_name_scenario_after
    global dict_after_n_name_scenario_n

    i = 1
    for scenario in feature.scenarios:
        if f"after{i}" in scenario.tags:
            list_name_scenario_after.append(scenario.name)
            dict_after_n_name_scenario_n[f"after_{i}"] = scenario.name
            i += 1

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
    global execute_after_scenario
    global list_name_scenario_after
    global tag_after_selected

    for i in range(1, len(list_name_scenario_after)+1):
        if f"after_{i}" in scenario.effective_tags:
            execute_after_scenario = True
            tag_after_selected = f"after_{i}"
            break

    context.stdout_capture = StringIO()
    context.original_stdout = sys.stdout
    sys.stdout = context.stdout_capture



def after_scenario(context, scenario):
    global execute_after_scenario
    global dict_after_n_name_scenario_n
    global tag_after_selected

    if execute_after_scenario:
        for after, name_scenario_after in dict_after_n_name_scenario_n.items():
            if after == tag_after_selected:
                print(f"----> AFTER STEP: {name_scenario_after} EXECUTING...")
                name = name_scenario_after
                # # Resetta la variabile per evitare di eseguire lo scenario "after" più volte
                execute_after_scenario = False  

                # # Esegue tutti gli step dello scenario "after"
                phase = ([phase for phase in context.feature.scenarios if name in phase.name] or [None])[0]
                text_step = ''.join([step.keyword + " " + step.name + "\n\"\"\"\n" + (step.text or '') + "\n\"\"\"\n" for step in phase.steps])
                context.execute_steps(text_step)
        print("----> AFTER STEP COMPLETED")

    dbRun = getattr(context, "dbRun")
    if dbRun == "Postgres":
        sys.stdout = context.original_stdout
        context.stdout_capture.seek(0)
        captured_stdout = context.stdout_capture.read()

        allure.attach(captured_stdout, name="stdout", attachment_type=allure.attachment_type.TEXT)

        context.stdout_capture.close()

        # Stampa l'output nel terminale
        print(f"\nCaptured stdout:\n{captured_stdout}")

    elif dbRun == "Oracle":
        ####RUN DA LOCALE
        if user_profile != None:
            sys.stdout = context.original_stdout
            context.stdout_capture.seek(0)
            captured_stdout = context.stdout_capture.read()

            allure.attach(captured_stdout, name="stdout", attachment_type=allure.attachment_type.TEXT)

            context.stdout_capture.close()

            # Stampa l'output nel terminale
            print(f"\nCaptured stdout:\n{captured_stdout}")




def after_feature(context, feature):
    global_configuration = context.config.userdata.get("global_configuration")

    # DISABLE see @config-ec too
    # for tag in feature.tags:
    #     if tag == 'config-ec':
    #         # reset apiconfig
    #         context.apiconfig.delete_creditor_institution(global_configuration.get("creditor_institution_code"))


def after_all(context):
    global user_profile
    
    dbRun = getattr(context, "dbRun")
    
    if dbRun == "Postgres":
        proxyEnabled = context.config.userdata.get("global_configuration").get("proxyEnabled")
        print(f"Proxy enabled: {proxyEnabled}")
        if proxyEnabled == 'True':
            ####RUN DA LOCALE
            if user_profile != None:
                proxies = {
                    'http': 'http://172.31.253.47:8080',
                    'https': 'http://172.31.253.47:8080',
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
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_name = "nodo_cfg"
        db_selected = db_config.get(db_name)
        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)
        if dbRun == "Postgres":

            # Call the procedure to reset test data for CONFIGURATION_KEYS table
            reset_test_data_query = "select nodo4_cfg.resettestdata();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_query)
            
            # Call the procedure to reset test data for CANALI table
            reset_test_data_canali = "select nodo4_cfg.resettestcanali();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_canali)
            
            # Call the procedure to reset test data for STAZIONI table
            reset_test_data_stazioni = "select nodo4_cfg.resetteststazioni();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_stazioni)
            
            # Call the procedure to reset test data for PA_STAZIONE_PA table
            reset_test_data_pa_stazione_pa = "select nodo4_cfg.resettestpastazionepa();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_pa_stazione_pa)
            
            # Call the procedure to reset test data for CANALI_NODO table
            reset_test_data_canali_nodo = "select nodo4_cfg.resettestcanalinodo();"
            exec_query = adopted_db.executeQuery(conn, reset_test_data_canali_nodo)
        
        elif dbRun == "Oracle":
            config_dict = getattr(context, 'configurations')
            update_config_query = "update_config_postgresql" if dbRun == "Postgres" else "update_config_oracle"

            for key, value in config_dict.items():

                selected_query = utils.query_json(context, update_config_query, 'configurations').replace('value', f"'{value}'").replace('key', key)
                
                adopted_db.executeQuery(conn, selected_query, as_dict=True)

        adopted_db.closeConnection(conn)
        
        flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

        headers = ''
        header_host = utils.estrapola_header_host(utils.get_refresh_config_url(context))

        if flag_subscription == 'Y':
            headers = {'Host': header_host, 'Ocp-Apim-Subscription-Key': SUBKEY}
        else:
            headers = {'Host': header_host}

        refresh_response = None
    
        if dbRun == "Postgres":
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False, proxies = getattr(context,'proxies'))
    
        elif dbRun == "Oracle":
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False)

        time.sleep(3)
        assert refresh_response.status_code == 200, f"refresh status code expected: {200} but obtained: {refresh_response.status_code}"
        
    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print("----->>>> Assertion Error: ", e)
        # Interrompiamo il test
        raise AssertionError(str(e))
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print("----->>>> Exception:", e)
        # Interrompiamo il test
        raise e



def config_ec(context):
    global_configuration = context.config.userdata.get("global_configuration")

    # with open(context.config.base_dir + '/../resources/creditorinstitutions.json', 'r') as reader:
    #     creditor_institution_code = global_configuration.get("creditor_institution_code")
    #     payload = reader.read().replace('#creditor_institution_code#', creditor_institution_code)

    #     context.apiconfig.create_creditor_institution(payload)
