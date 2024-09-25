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
from dotenv import load_dotenv

db_online = None
db_offline = None
db_re = None
db_wfesp = None

user_profile = os.environ.get("USERPROFILE")

# Variabile globale per segnalare se lo scenario "after" deve essere eseguito
execute_after_scenario = False



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
                load_dotenv()  # Carica le variabili da .env
                SUBKEY = os.getenv('SUBKEY')
            ####RUN IN REMOTO
            else:
                proxies = {
                    'http': 'http://10.79.20.33:80',
                    'https': 'http://10.79.20.33:80',
                }
                SUBKEY = context.config.userdata.get("env").get("SUBKEY")
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
            load_dotenv()  # Carica le variabili da .env
            SUBKEY = os.getenv('SUBKEY')
        ####RUN IN REMOTO
        else:
            lib_dir = os.path.abspath(os.path.join(__file__, os.pardir, os.pardir, os.pardir, os.pardir, os.pardir, 'oracle', 'instantclient_21_6'))
            print(f"#####################lib_dir {lib_dir}") 
            SUBKEY = context.config.userdata.get("env").get("SUBKEY")
        
        cx_Oracle.init_oracle_client(lib_dir = lib_dir)
        
    setattr(context, 'SUBKEY', SUBKEY)

    apicfg_testing_support_service = context.config.userdata.get("services").get("apicfg-testing-support")
    db.set_address(apicfg_testing_support_service)
        
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_name = "nodo_cfg"
        db_selected = db_config.get(db_name)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        # Call the procedure to reset test data for CONFIGURATION_KEYS table
        print(f"----> SET CONFIGURATION_KEYS...")
        reset_test_data_query = "select resettestdata();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_query)
        
        # Call the procedure to reset test data for CANALI table
        print(f"----> SET CANALI...")
        reset_test_data_canali = "select resettestcanali();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_canali)
        
        # Call the procedure to reset test data for STAZIONI table
        print(f"----> SET STAZIONI...")
        reset_test_data_stazioni = "select resetteststazioni();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_stazioni)
        
        # Call the procedure to reset test data for PA_STAZIONE_PA table
        print(f"----> SET PA_STAZIONE_PA...")
        reset_test_data_pa_stazione_pa = "select resettestpastazionepa();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_pa_stazione_pa)
        
        # Call the procedure to reset test data for CANALI_NODO table
        print(f"----> SET CANALI_NODO...")
        reset_test_data_canali_nodo = "select resettestcanalinodo();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_canali_nodo)             

        adopted_db.closeConnection(conn)
    
        selected_query = utils.query_json(context, 'select_config', 'configurations')
        adopted_db, conn = utils.get_db_connection_for_env(db_name, db, db_selected)
        exec_query = adopted_db.executeQuery(context, conn, selected_query, as_dict=True)

        adopted_db.closeConnection(conn)

        config_dict = {}
        for row in exec_query:
            config_key, config_value = row
            config_dict[row[config_key]] = row[config_value]
        
        setattr(context, 'configurations', config_dict)
        
        flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

        headers = ''
        header_host = utils.estrapola_header_host(utils.get_refresh_config_url(context))

        if flag_subscription == 'Y':
            headers = {'Host': header_host, 'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}
        else:
            headers = {'Host': header_host}

        print(f"----> REFRESH...")
    
        print(f"URL refresh: {utils.get_refresh_config_url(context)}")

        refresh_response = None

        if dbRun == 'Postgres':
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False, proxies = getattr(context,'proxies'))
        elif dbRun == 'Oracle':
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False)
        
        #CHECK NEW RECORD CACHE AFTER REFRESH
        new_record_cache = utils.query_new_record_cache(context, conn, adopted_db, dbRun)
        adopted_db.closeConnection(conn)
        assert new_record_cache == True, f"New record cache not found!"
        
        assert refresh_response.status_code == 200, f"refresh status code expected: {200} but obtained: {refresh_response.status_code}"

    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print("----->>>> Exception:", e)


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
    global execute_after_scenario

    if "after" in scenario.effective_tags:
        execute_after_scenario = True

    context.stdout_capture = StringIO()
    context.original_stdout = sys.stdout
    sys.stdout = context.stdout_capture



def after_scenario(context, scenario):
    global execute_after_scenario
    dbRun = getattr(context, "dbRun")

    try:
        if execute_after_scenario:
            print(f"----> AFTER SCENARIO RESTORE EXECUTING...")

            # # Resetta la variabile "after"
            execute_after_scenario = False  

            ####Invece dell'after per ogni scenario che lo richiede, per postgres, chiamo direttamente le stored procedure eliminando gli skipped dovuti agli after

            db_config = context.config.userdata.get("db_configuration")
            db_name = "nodo_cfg"
            db_selected = db_config.get(db_name)
            adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

            # Call the procedure to reset test data for CONFIGURATION_KEYS table
            print(f"----> RESTORE CONFIGURATION_KEYS...")
            reset_test_data_query = "select resettestdata();"
            exec_query = adopted_db.executeQuery(context, conn, reset_test_data_query)
            
            # Call the procedure to reset test data for CANALI table
            print(f"----> RESTORE CANALI...")
            reset_test_data_canali = "select resettestcanali();"
            exec_query = adopted_db.executeQuery(context, conn, reset_test_data_canali)
            
            # Call the procedure to reset test data for STAZIONI table
            print(f"----> RESTORE STAZIONI...")
            reset_test_data_stazioni = "select resetteststazioni();"
            exec_query = adopted_db.executeQuery(context, conn, reset_test_data_stazioni)
            
            # Call the procedure to reset test data for PA_STAZIONE_PA table
            print(f"----> RESTORE PA_STAZIONE_PA...")
            reset_test_data_pa_stazione_pa = "select resettestpastazionepa();"
            exec_query = adopted_db.executeQuery(context, conn, reset_test_data_pa_stazione_pa)
            
            # Call the procedure to reset test data for CANALI_NODO table
            print(f"----> RESTORE CANALI_NODO...")
            reset_test_data_canali_nodo = "select resettestcanalinodo();"
            exec_query = adopted_db.executeQuery(context, conn, reset_test_data_canali_nodo)

            print("----> AFTER SCENARIO RESTORE COMPLETED")

            #adopted_db.closeConnection(conn)

            ##REFRESH
            flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

            headers = ''
            header_host = utils.estrapola_header_host(utils.get_refresh_config_url(context))

            if flag_subscription == 'Y':
                headers = {'Host': header_host, 'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}
            else:
                headers = {'Host': header_host}

            print(f"----> REFRESH AFTER SCENARIO EXECUTING...")
        
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")

            refresh_response = None

            if dbRun == 'Postgres':
                refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False, proxies = getattr(context,'proxies'))
            elif dbRun == 'Oracle':
                refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False)

            #CHECK NEW RECORD CACHE AFTER REFRESH
            new_record_cache = utils.query_new_record_cache(context, conn, adopted_db, dbRun)
            adopted_db.closeConnection(conn)
            assert new_record_cache == True, f"New record cache not found!"

            assert refresh_response.status_code == 200, f"refresh status code expected: {200} but obtained: {refresh_response.status_code}"
            print(f"----> REFRESH AFTER SCENARIO COMPLETED!")

    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print("----->>>> Assertion Error: ", e)
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print("----->>>> Exception:", e)
    
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

        # Call the procedure to reset test data for CONFIGURATION_KEYS table
        print(f"----> RESTORE CONFIGURATION_KEYS...")
        reset_test_data_query = "select resettestdata();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_query)
        
        # Call the procedure to reset test data for CANALI table
        print(f"----> RESTORE CANALI...")
        reset_test_data_canali = "select resettestcanali();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_canali)
        
        # Call the procedure to reset test data for STAZIONI table
        print(f"----> RESTORE STAZIONI...")
        reset_test_data_stazioni = "select resetteststazioni();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_stazioni)
        
        # Call the procedure to reset test data for PA_STAZIONE_PA table
        print(f"----> RESTORE PA_STAZIONE_PA...")
        reset_test_data_pa_stazione_pa = "select resettestpastazionepa();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_pa_stazione_pa)
        
        # Call the procedure to reset test data for CANALI_NODO table
        print(f"----> RESTORE CANALI_NODO...")
        reset_test_data_canali_nodo = "select resettestcanalinodo();"
        exec_query = adopted_db.executeQuery(context, conn, reset_test_data_canali_nodo)

        adopted_db.closeConnection(conn)
        
        flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

        headers = ''
        header_host = utils.estrapola_header_host(utils.get_refresh_config_url(context))

        if flag_subscription == 'Y':
            headers = {'Host': header_host, 'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}
        else:
            headers = {'Host': header_host}

        refresh_response = None
        
        print(f"----> REFRESH...")
    
        if dbRun == "Postgres":
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False, proxies = getattr(context,'proxies'))
    
        elif dbRun == "Oracle":
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False)

        #CHECK NEW RECORD CACHE AFTER REFRESH
        new_record_cache = utils.query_new_record_cache(context, conn, adopted_db, dbRun)
        adopted_db.closeConnection(conn)
        assert new_record_cache == True, f"New record cache not found!"

        assert refresh_response.status_code == 200, f"refresh status code expected: {200} but obtained: {refresh_response.status_code}"
        
    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print("----->>>> Assertion Error: ", e)
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print("----->>>> Exception:", e)