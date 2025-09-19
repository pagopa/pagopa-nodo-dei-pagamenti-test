import base64 as b64
import datetime
import json
import os
import random

import time
from datetime import timedelta
from multiprocessing.sharedctypes import Value
from sre_constants import ASSERT

from xml.dom.minidom import parseString
import xmltodict

import db_operation_postgres
import db_operation_oracle

import db_operation_apicfg_testing_support as db

import json_operations as jo
import pytz
import requests
import utils as utils
from behave import *

from lxml import etree

try:
    import cx_Oracle
except ModuleNotFoundError:
    print(">>>>>>>>>>>>>>>>>No import CX_ORACLE for Postgres pipeline")

import urllib3

# Constants
RESPONSE = "Response"
REQUEST = "Request"

db_online = None
db_offline = None
db_re = None
db_wfesp = None

#disabilita gli avvisi relativi alle richieste non sicure (nessuna verifica SSL alla richiesta https)
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


# Steps definitions
@given('systems up')
def step_impl(context):
    try:
        """
            health check for 
                - nodo-dei-pagamenti ( application under test )
                - mock-ec ( used by nodo-dei-pagamenti to forwarding EC's requests )
                - pagopa-api-config ( used in tests to set DB's nodo-dei-pagamenti correctly according to input test ))
        """

        apicfg_testing_support_service = context.config.userdata.get("services").get("apicfg-testing-support")
        db.set_address(apicfg_testing_support_service)

        dbRun = getattr(context, "dbRun")
        print(f"DB SELECTED -> {dbRun}")

        global db_online
        global db_offline
        global db_re
        global db_wfesp

        if dbRun == "Postgres":
            db_online = db_operation_postgres
            db_offline = db_operation_postgres
            db_re = db_operation_postgres
            db_wfesp = db_operation_postgres
        elif dbRun == "Oracle":
            db_online = db_operation_oracle
            db_offline =  db_operation_oracle
            db_re = db_operation_oracle
            db_wfesp = db_operation_oracle

        responses = True
        user_profile = None

        try:
            user_profile = getattr(context, "user_profile")
            print(f"User Profile: {user_profile} ->>> local run!")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        for row in context.table:
            print(f"calling: {row.get('name')} -> {row.get('url')}")
            url = row.get("url") + row.get("healthcheck")
            flag_subscription = row.get("subscription_key_name")

            print(f"calling -> {url}")
            print(f"flag subscription -> {flag_subscription}")

            headers = ''
            header_host = utils.estrapola_header_host(row.get("url"))

            if flag_subscription == 'Y':
                headers = {'Host': header_host, 'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}
            else:
                headers = {'Host': header_host}
        
            #CHECK SE LANCIO DA DB POSTGRES O ORACLE
            if dbRun == "Postgres":
                ####RUN DA LOCALE E REMOTO
                if "https://api.dev.platform.pagopa.it/" in url:
                    print(f"############URL:{url} and headers: {headers}")
                    resp = requests.get(url, headers=headers, verify=False)
                else:
                    print(f"############URL:{url} and headers: {headers} and proxies: {getattr(context,'proxies')}")
                    resp = requests.get(url, headers=headers, verify=False, proxies = getattr(context,'proxies'))

            elif dbRun == "Oracle":
                print(f"############URL:{url} and headers: {headers}")
                resp = requests.get(url, headers=headers, verify=False)

            print(f"response: {resp.status_code}")
            responses &= (resp.status_code == 200)

        assert responses, f"System up service expected: {200} but obtained: {resp.status_code}"

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



@step('from body with datatable {type_table} {filebody} initial XML {primitive}')
def step_impl(context, primitive, type_table, filebody):
    try:
        # Legge la datatable e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
            ###RUN DA REMOTO
            else:      
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xml/{filebody}.xml"             
                
                print("Il file path corrente è:", file_path)

        # Leggi il contenuto del file XML come stringa
        with open(file_path, 'r') as file:
            payload = file.read()

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        payload = utils.replace_local_variables(payload, context)
        payload = utils.replace_context_variables(payload, context)
        payload = utils.replace_global_variables(payload, context)

        if len(payload) > 0:
            my_document = parseString(payload)
            idBrokerPSP = "70000000001"
            if len(my_document.getElementsByTagName('idBrokerPSP')) > 0:
                idBrokerPSP = my_document.getElementsByTagName('idBrokerPSP')[
                    0].firstChild.data

            payload = payload.replace('#idempotency_key#', f"{idBrokerPSP}_{str(random.randint(1000000000, 9999999999))}")

            payload = payload.replace('#idempotency_key_IOname#',
                                    "IOname" + "_" + str(random.randint(1000000000, 9999999999)))

        if "#timedate#" in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
            payload = payload.replace('#timedate#', timedate)
            setattr(context, 'timedate', timedate)

        if '#date#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            payload = payload.replace('#date#', date)
            setattr(context, 'date', date)

        if '#yesterday_date#' in payload:
            yesterday_date = (datetime.datetime.now() - datetime.timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3]
            payload = payload.replace('#yesterday_date#', yesterday_date)
            setattr(context, 'yesterday_date', yesterday_date)

        if '#tomorrow_date#' in payload:
            tomorrow_date = (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3]
            payload = payload.replace('#tomorrow_date#', tomorrow_date)
            setattr(context, 'tomorrow_date', tomorrow_date)

        if '#identificativoFlusso#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            identificativoFlusso = date + context.config.userdata.get("global_configuration").get("psp") + "-" + str(
                random.randint(0, 10000))

            payload = payload.replace('#identificativoFlusso#', identificativoFlusso)
            setattr(context, 'identificativoFlusso', identificativoFlusso)

        if '#iubd#' in payload:
            iubd = '' + str(random.randint(10000000, 20000000)) + \
                str(random.randint(10000000, 20000000))
            payload = payload.replace('#iubd#', iubd)
            setattr(context, 'iubd', iubd)

        if "#ccp#" in payload:
            ccp = str(random.randint(100000000000000, 999999999999999))
            payload = payload.replace('#ccp#', ccp)
            setattr(context, "ccp", ccp)

        if "#ccpms#" in payload:
            ccpms = str(utils.current_milli_time())
            payload = payload.replace('#ccpms#', ccpms)
            setattr(context, "ccpms", ccpms)

        if "#ccpms2#" in payload:
            ccpms2 = str(utils.current_milli_time()) + '1'
            payload = payload.replace('#ccpms2#', ccpms2)
            setattr(context, "ccpms2", ccpms2)

        if "#iuv#" in payload:
            iuv = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv#', iuv)
            setattr(context, "iuv", iuv)

        if "#iuv1#" in payload:
            iuv1 = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv1#', iuv1)
            setattr(context, "iuv1", iuv1)

        if "#iuv2#" in payload:
            iuv2 = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv2#', iuv2)
            setattr(context, "iuv2", iuv2)
        
        if "#iuv3#" in payload:
            iuv3 = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv3#', iuv3)
            setattr(context, "iuv3", iuv3)

        if "#iuv4#" in payload:
            iuv4 = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv4#', iuv4)

        if '#IUV#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            IUV = 'IUV' + str(random.randint(0, 10000)) + '-' + date + \
                datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3]
            payload = payload.replace('#IUV#', IUV)
            setattr(context, 'IUV', IUV)

        if '#IUV2#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            IUV2 = str(date + datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3] + '-' + str(random.randint(0, 100000)))
            payload = payload.replace('#IUV2#', IUV2)
            setattr(context, 'IUV2', IUV2)

        if '#notice_number#' in payload:
            notice_number = f"30211{str(random.randint(1000000000000, 9999999999999))}"
            payload = payload.replace('#notice_number#', notice_number)
            setattr(context, "iuv", notice_number[1:])

        if '#notice_number_old#' in payload:
            notice_number = f"31211{str(random.randint(1000000000000, 9999999999999))}"
            payload = payload.replace('#notice_number_old#', notice_number)
            setattr(context, "iuv", notice_number[1:])

        if '#carrello#' in payload:
            carrello = "77777777777" + "302" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#carrello#', carrello)
            setattr(context, 'carrello', carrello)

        if '#carrello1#' in payload:
            carrello1 = "77777777777" + "302" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + utils.random_s()
            payload = payload.replace('#carrello1#', carrello1)
            setattr(context, 'carrello1', carrello1)

        if '#secCarrello#' in payload:
            secCarrello = "77777777777" + "301" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#secCarrello#', secCarrello)
            setattr(context, 'secCarrello', secCarrello)

        if '#carrNOTENABLED#' in payload:
            carrNOTENABLED = "11111122223" + "311" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#carrNOTENABLED#', carrNOTENABLED)
            setattr(context, 'carrNOTENABLED', carrNOTENABLED)

        if '#thrCarrello#' in payload:
            thrCarrello = "77777777777" + "088" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#thrCarrello#', thrCarrello)
            setattr(context, 'thrCarrello', thrCarrello)

        if '#CARRELLO#' in payload:
            CARRELLO = "CARRELLO" + "-" + \
                    str(getattr(context, 'date') +
                        datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])
            payload = payload.replace('#CARRELLO#', CARRELLO)
            setattr(context, 'CARRELLO', CARRELLO)

        if '#CARRELLO1#' in payload:
            CARRELLO1 = "CARRELLO" + str(random.randint(0, 100000))
            payload = payload.replace('#CARRELLO1#', CARRELLO1)
            setattr(context, 'CARRELLO1', CARRELLO1)

        if '#CARRELLO2#' in payload:
            CARRELLO2 = "CARRELLO" + str(random.randint(0, 10000))
            payload = payload.replace('#CARRELLO2#', CARRELLO2)
            setattr(context, 'CARRELLO2', CARRELLO2)

        if '#carrelloMills#' in payload:
            carrello = str(utils.current_milli_time())
            payload = payload.replace('#carrelloMills#', carrello)
            setattr(context, 'carrelloMills', carrello)

        if '#ccp3#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            timedate = date + datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3]
            ccp3 = str(random.randint(0, 10000)) + timedate
            payload = payload.replace('#ccp3#', ccp3)
            setattr(context, 'ccp3', ccp3)
            
        if '$iuv' in payload:
            payload = payload.replace('$iuv', getattr(context, 'iuv'))

        if '$intermediarioPA' in payload:
            payload = payload.replace(
                '$intermediarioPA', getattr(context, 'intermediarioPA'))

        if '$identificativoFlusso' in payload:
            payload = payload.replace('$identificativoFlusso', getattr(
                context, 'identificativoFlusso'))

        if '$1ccp' in payload:
            payload = payload.replace('$1ccp', getattr(context, 'ccp1'))

        if '$2ccp' in payload:
            payload = payload.replace('$2ccp', getattr(context, 'ccp2'))

        if '$rendAttachment' in payload:
            rendAttachment = getattr(context, 'rendAttachment')
            rendAttachment_b = bytes(rendAttachment, 'UTF-8')
            rendAttachment_uni = b64.b64encode(rendAttachment_b)
            rendAttachment_uni = f"{rendAttachment_uni}".split("'")[1]
            payload = payload.replace('$rendAttachment', rendAttachment_uni)

        if '#carrello#' in payload:
            carrello = "77777777777" + "311" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#carrello#', carrello)
            setattr(context, 'carrello', carrello)

        if "#cityspo#" in payload:
            cityspo = str("city" + utils.random_s())
            payload = payload.replace('#cityspo#', cityspo)
            setattr(context, "cityspo", cityspo)

        setattr(context, primitive, payload)

    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print("----->>>> Assertion Error: ", e)
        # Interrompiamo il test
        raise AssertionError(str(e))
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print(f"----->>>> Exception: {e} for primitive {primitive}")
        # Interrompiamo il test
        raise e




@given('from body with datatable {type_table} {filebody} initial JSON {primitive}')
def step_impl(context, primitive, type_table, filebody):
    try:
        # Legge la datatable e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        file_json = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_json = open(f"src/integ-test/bdd-test/resources/json/{filebody}.json")
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_json = open(f"src/integ-test/bdd-test/resources/json/{filebody}.json")
            ###RUN DA REMOTO
            else:      
                # Specifica il percorso del tuo file XML da remoto
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)
                
                file_json = open(f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/json/{filebody}.json")
                
                print("Il file path corrente è:", file_json)
            
        data_json = json.load(file_json)

        payload = json.dumps(data_json)

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        payload = utils.replace_local_variables(payload, context)
        payload = utils.replace_context_variables(payload, context)
        payload = utils.replace_global_variables(payload, context)
        setattr(context, f"{primitive}JSON", payload)
        
        jsonDict = json.loads(payload)
        payload = utils.json2xml(jsonDict)
        payload = '<root>' + payload + '</root>'

        if "#iuv#" in payload:
            iuv = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv#', iuv)
            setattr(context, "iuv", iuv)
        if "#iuv1#" in payload:
            iuv1 = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv1#', iuv1)
            setattr(context, "iuv1", iuv1)
        if "#iuv2#" in payload:
            iuv2 = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv2#', iuv2)
            setattr(context, "iuv2", iuv2)
        if "#iuv3#" in payload:
            iuv3 = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv3#', iuv3)
            setattr(context, "iuv3", iuv3)
        if "#iuv4#" in payload:
            iuv4 = '11' + str(random.randint(1000000000000, 9999999999999))
            payload = payload.replace('#iuv4#', iuv4)
            setattr(context, "iuv4", iuv4)
        if '#transaction_id#' in payload:
            transaction_id = str(random.randint(10000000, 99999999))
            payload = payload.replace('#transaction_id#', transaction_id)
            setattr(context, 'transaction_id', transaction_id)
        if '#psp_transaction_id#' in payload:
            psp_transaction_id = str(random.randint(10000000, 99999999))
            payload = payload.replace('#psp_transaction_id#', psp_transaction_id)
            setattr(context, 'psp_transaction_id', psp_transaction_id)
        if '$iuv' in payload:
            payload = payload.replace('$iuv', getattr(context, 'iuv'))
        if '$transaction_id' in payload:
            payload = payload.replace('$transaction_id', getattr(context, 'transaction_id'))
        if '$psp_transaction_id' in payload:
            payload = payload.replace('$psp_transaction_id', getattr(context, 'psp_transaction_id'))
            
        setattr(context, primitive, payload)

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


    
@step('RPT{number:d} generation {filebody} with datatable {type_table}')
def step_impl(context, number, filebody, type_table):
    try:

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
            ###RUN DA REMOTO
            else:      
                # Specifica il percorso del tuo file XML da remoto
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xml/{filebody}.xml"             
                
                print("Il file path corrente è:", file_path)

        # Leggi il contenuto del file XML come stringa
        with open(file_path, 'r') as file:
            payload = file.read()

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        date = datetime.date.today().strftime("%Y-%m-%d")
        timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]

        setattr(context, 'date', date)
        setattr(context, 'timedate', timedate)
        payload = utils.replace_local_variables(payload, context)
        payload = utils.replace_context_variables(payload, context)

        pa = context.config.userdata.get(
            'global_configuration').get('creditor_institution_code')

        if f'#iuv{number}#' in payload:
            iuv = "IUV" + str(random.randint(0, 10000)) + "-" + \
                datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S.%f")[:-3]
            payload = payload.replace(f'#iuv{number}#', iuv)
            setattr(context, f'{number}iuv', iuv)

        if f"#ccp{number}#" in payload:
            ccp = str(int(time.time() * 1000))
            payload = payload.replace(f'#ccp{number}#', ccp)
            setattr(context, f"{number}ccp", ccp)


        payload = utils.replace_global_variables(payload, context)

        setattr(context, f'rpt{number}', payload)
        payload_b = bytes(payload, 'UTF-8')
        payload_uni = b64.b64encode(payload_b)
        payload = f"{payload_uni}".split("'")[1]

        print(f"RPT{number} generato: ", payload)
        setattr(context, f'rpt{number}Attachment', payload)

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



@step('RPT generation {filebody} with datatable {type_table}')
def step_impl(context, filebody, type_table):
    try:

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
            ###RUN DA REMOTO
            else:      
                # Specifica il percorso del tuo file XML da remoto
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xml/{filebody}.xml"             
                
                print("Il file path corrente è:", file_path)

        # Leggi il contenuto del file XML come stringa
        with open(file_path, 'r') as file:
            payload = file.read()

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        date = datetime.date.today().strftime("%Y-%m-%d")
        timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]

        setattr(context, 'date', date)
        setattr(context, 'timedate', timedate)
        payload = utils.replace_local_variables(payload, context)
        payload = utils.replace_context_variables(payload, context)

        pa = context.config.userdata.get(
            'global_configuration').get('creditor_institution_code')

        if "#iuv#" in payload:
            iuv = f"14{str(random.randint(1000000000000, 9999999999999))}"
            payload = payload.replace('#iuv#', iuv)
            setattr(context, 'iuv', iuv)

        if "#ccp#" in payload:
            ccp = str(int(time.time() * 1000))
            payload = payload.replace('#ccp#', ccp)
            setattr(context, "ccp", ccp)

        if "#ccp1#" in payload:
            ccp1 = str(utils.current_milli_time())
            payload = payload.replace('#ccp1#', ccp1)
            setattr(context, "1ccp", ccp1)

        if "#CCP#" in payload:
            CCP = 'CCP' + '-' + \
                str(date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])
            payload = payload.replace('#CCP#', CCP)
            setattr(context, "CCP", CCP)

        if '#date#' in payload:
            payload = payload.replace('#date#', date)

        if "#timedate#" in payload:
            payload = payload.replace('#timedate#', timedate)
            setattr(context, 'timedate', timedate)

        if '#IuV#' in payload:
            iuv = '0' + str(random.randint(1000, 2000)) + str(random.randint(1000,
                                                                            2000)) + str(random.randint(1000, 2000)) + '00'
            payload = payload.replace('#IuV#', iuv)
            setattr(context, 'IuV', iuv)

        if '#iuv2#' in payload:
            iuv = 'IUV' + '-' + \
                str(date + '-' +
                    datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3])
            payload = payload.replace('#iuv2#', iuv)
            setattr(context, '2iuv', iuv)

        if '#IUVspecial#' in payload:
            IUVspecial = '!ìUV[#à°]_' + \
                        datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3] + '$§'
            payload = payload.replace('#IUVspecial#', IUVspecial)
            setattr(context, 'IUVspecial', IUVspecial)

        if '#IUV_#' in payload:
            IUV_ = 'IUV' + str(random.randint(0, 10000)) + '_' + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
            payload = payload.replace('#IUV_#', IUV_)
            setattr(context, 'IUV_', IUV_)

        if '#IUV#' in payload:
            IUV = 'IUV' + str(random.randint(0, 10000)) + '-' + date + \
                datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
            payload = payload.replace('#IUV#', IUV)
            setattr(context, 'IUV', IUV)

        if '#idCarrello#' in payload:
            idCarrello = "09812374659" + "311" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#idCarrello#', idCarrello)
            setattr(context, 'idCarrello', idCarrello)

        if '#CARRELLO#' in payload:
            CARRELLO = "CARRELLO" + "-" + \
                    str(date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])
            payload = payload.replace('#CARRELLO#', CARRELLO)
            setattr(context, 'CARRELLO', CARRELLO)

        if '#carrello#' in payload:
            prova = utils.random_s()
            print('############', prova)
            carrello = pa + "302" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + prova
            print(carrello)
            payload = payload.replace('#carrello#', carrello)
            setattr(context, 'carrello', carrello)

        if '#carrello1#' in payload:
            carrello1 = pa + "311" + "0" + str(random.randint(1000, 2000)) + str(random.randint(
                1000, 2000)) + str(random.randint(1000, 2000)) + "00" + utils.random_s()
            payload = payload.replace('#carrello1#', carrello1)
            setattr(context, 'carrello1', carrello1)

        if '#secCarrello#' in payload:
            secCarrello = pa + "301" + "0" + str(random.randint(1000, 2000)) + str(random.randint(
                1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#secCarrello#', secCarrello)
            setattr(context, 'secCarrello', secCarrello)

        if '#thrCarrello#' in payload:
            thrCarrello = pa + "088" + "0" + str(random.randint(1000, 2000)) + str(random.randint(
                1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#thrCarrello#', thrCarrello)
            setattr(context, 'thrCarrello', thrCarrello)

        if '#carrNOTENABLED#' in payload:
            carrNOTENABLED = "11111122223" + "311" + "0" + str(random.randint(1000, 2000)) + str(
                random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
            payload = payload.replace('#carrNOTENABLED#', carrNOTENABLED)
            setattr(context, 'carrNOTENABLED', carrNOTENABLED)

        if '#date#' in payload:
            payload = payload.replace('#date#', date)

        if '#sdf#' in payload:
            timedate = date + datetime.datetime.now().strftime("-%H:%M:%S.%f")[:-3]
            payload = payload.replace('#sdf#', timedate)
            setattr(context, 'sdf', timedate)

        if '#mills_time#' in payload:
            millisec = str(int(time.time() * 1000))
            payload = payload.replace('#mills_time#', millisec)
            setattr(context, 'mills_time', millisec)

        payload = utils.replace_global_variables(payload, context)

        setattr(context, 'rpt', payload)
        payload_b = bytes(payload, 'UTF-8')
        payload_uni = b64.b64encode(payload_b)
        payload = f"{payload_uni}".split("'")[1]

        print("RPT generato: ", payload)
        setattr(context, 'rptAttachment', payload)

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



@given('generate {number:d} notice number and iuv with aux digit {aux_digit:d}, segregation code {segregation_code} and application code {application_code}')
def step_impl(context, number, aux_digit, segregation_code, application_code):
    try:
        segregation_code = utils.replace_global_variables(segregation_code, context)
        application_code = utils.replace_global_variables(application_code, context)
        if aux_digit == 0 or aux_digit == 3:
            iuv = f"11{random.randint(10000000000, 99999999999)}00"
            reference_code = application_code if aux_digit == 0 else segregation_code
            notice_number = f"{aux_digit}{reference_code}{iuv}"
        elif aux_digit == 1 or aux_digit == 2:
            iuv = random.randint(10000000000000000, 99999999999999999)
            notice_number = f"{aux_digit}{iuv}"
        else:
            assert False, f"aux digit {aux_digit} wrong!!!"

        setattr(context, f"{number}iuv", str(iuv))
        setattr(context, f'{number}noticeNumber', notice_number)

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


@given('generate {number:d} cart with PA {pa} and notice number {notice_number}')
def step_impl(context, number, pa, notice_number):
    try:
        pa = utils.replace_local_variables(pa, context)
        pa = utils.replace_context_variables(pa, context)
        pa = utils.replace_global_variables(pa, context)

        notice_number = utils.replace_local_variables(notice_number, context)
        notice_number = utils.replace_context_variables(notice_number, context)

        carrello = f"{pa}{notice_number}-{utils.random_s()}"
        setattr(context, f'{number}carrello', carrello)

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





@given('MB generation {filebody} with datatable {type_table}')
def step_impl(context, filebody, type_table):
    try:
        to_change = False

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        
        if "to_change" in dict_fields_values:
            to_change = True

        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
            ###RUN DA REMOTO
            else:      
                # Specifica il percorso del tuo file XML da remoto
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xml/{filebody}.xml"             
                
                print("Il file path corrente è:", file_path)

        # Leggi il contenuto del file XML come stringa
        with open(file_path, 'r') as file:
            payload = file.read()

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        payload = utils.replace_local_variables(payload, context)
        payload = utils.replace_context_variables(payload, context)
        payload = utils.replace_global_variables(payload, context)

        if '#iubd#' in payload:
            iubd = '' + str(random.randint(10000000, 20000000)) + \
                str(random.randint(10000000, 20000000))
            payload = payload.replace('#iubd#', iubd)
            setattr(context, 'iubd', iubd)
        print(">>>>>>>>>>>>", payload)

        if to_change:
            print("payload change after")
            setattr(context, 'bollo', payload)
        else:
            print("payload change now")

            payload_b = bytes(payload, 'UTF-8')
            payload_uni = b64.b64encode(payload_b)
            payload = f"{payload_uni}".split("'")[1]

            setattr(context, 'bollo', payload)

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
    
    
    
@given('MB{number:d} generation {filebody} with datatable {type_table}')
def step_impl(context, number, filebody, type_table):
    try:
        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
            ###RUN DA REMOTO
            else:      
                # Specifica il percorso del tuo file XML da remoto
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xml/{filebody}.xml"             
                
                print("Il file path corrente è:", file_path)

        # Leggi il contenuto del file XML come stringa
        with open(file_path, 'r') as file:
            payload = file.read()

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        payload = utils.replace_local_variables(payload, context)
        payload = utils.replace_context_variables(payload, context)
        payload = utils.replace_global_variables(payload, context)

        if f'#iubd{number}#' in payload:
            iubd = '' + str(random.randint(10000000, 20000000)) + \
                str(random.randint(10000000, 20000000))
            payload = payload.replace(f'#iubd{number}#', iubd)
            setattr(context, f'{number}iubd', iubd)
        print(">>>>>>>>>>>>", payload)
        
        payload_b = bytes(payload, 'UTF-8')
        payload_uni = b64.b64encode(payload_b)
        payload = f"{payload_uni}".split("'")[1]

        setattr(context, f'{number}bollo', payload)

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



@step('RT generation {filebody} with datatable {type_table}')
def step_impl(context, filebody, type_table):
    try:
        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")
        
        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
            ###RUN DA REMOTO
            else:      
                # Specifica il percorso del tuo file XML da remoto
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xml/{filebody}.xml"             
                
                print("Il file path corrente è:", file_path)

        # Leggi il contenuto del file XML come stringa
        with open(file_path, 'r') as file:
            payload = file.read()

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        payload = utils.replace_global_variables(payload, context)
        payload = utils.replace_local_variables(payload, context)
        payload = utils.replace_context_variables(payload, context)

        if '#date#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            payload = payload.replace('#date#', date)
            setattr(context, 'date', date)

        if "#timedate#" in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
            payload = payload.replace('#timedate#', timedate)
            setattr(context, 'timedate', timedate)

        if "#ccp#" in payload:
            ccp = str(utils.current_milli_time())
            payload = payload.replace('#ccp#', ccp)
            setattr(context, "ccp", ccp)

        setattr(context, 'rt', payload)

        payload_b = bytes(payload, 'UTF-8')
        payload_uni = b64.b64encode(payload_b)
        payload = f"{payload_uni}".split("'")[1]

        print("RT generato: ", payload)
        setattr(context, 'rtAttachment', payload)

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
    
    
@step('RT{number:d} generation {filebody} with datatable {type_table}')
def step_impl(context, filebody, type_table, number):
    try:
        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")
        
        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
            ###RUN DA REMOTO
            else:      
                # Specifica il percorso del tuo file XML da remoto
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xml/{filebody}.xml"             
                
                print("Il file path corrente è:", file_path)

        # Leggi il contenuto del file XML come stringa
        with open(file_path, 'r') as file:
            payload = file.read()

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        payload = utils.replace_global_variables(payload, context)
        payload = utils.replace_local_variables(payload, context)
        payload = utils.replace_context_variables(payload, context)

        if '#date#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            payload = payload.replace('#date#', date)
            setattr(context, 'date', date)

        if "#timedate#" in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
            payload = payload.replace('#timedate#', timedate)
            setattr(context, 'timedate', timedate)

        if f"#ccp{number}#" in payload:
            ccp = str(int(time.time() * 1000))
            payload = payload.replace(f'#ccp{number}#', ccp)
            setattr(context, f"{number}ccp", ccp)

        setattr(context, f'rt{number}', payload)

        payload_b = bytes(payload, 'UTF-8')
        payload_uni = b64.b64encode(payload_b)
        payload = f"{payload_uni}".split("'")[1]

        print(f"RT{number} generato: ", payload)
        setattr(context, f'rt{number}Attachment', payload)

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
    

    
    
@step('REND generation {filebody} with datatable {type_table}')
def step_impl(context, filebody, type_table):
    try:

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XML da locale
                file_path = f"src/integ-test/bdd-test/resources/xml/{filebody}.xml"
            ###RUN DA REMOTO
            else:      
                # Specifica il percorso del tuo file XML da remoto
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xml/{filebody}.xml"             
                
                print("Il file path corrente è:", file_path)

        # Leggi il contenuto del file XML come stringa
        with open(file_path, 'r') as file:
            payload = file.read()

        #replace placeHolder with value by datatable
        for fields, values in dict_fields_values.items():
            for value in values:
                payload = payload.replace(f"${fields}", value)

        date = datetime.date.today().strftime("%Y-%m-%d")
        timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]

        if '#date#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            payload = payload.replace('#date#', date)
            setattr(context, 'date', date)

        if '#timedate+1#' in payload:
            date = datetime.date.today() + datetime.timedelta(hours=1)
            date = date.strftime("%Y-%m-%d")
            timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
            payload = payload.replace('#timedate+1#', timedate)
            setattr(context, 'futureTimedate', timedate)

        if "#timedate#" in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
            payload = payload.replace('#timedate#', timedate)
            setattr(context, 'timedate', timedate)

        if '#identificativoFlusso#' in payload:
            date = datetime.date.today().strftime("%Y-%m-%d")
            identificativoFlusso = date + context.config.userdata.get(
                "global_configuration").get("psp") + "-" + str(random.randint(0, 10000))
            payload = payload.replace(
                '#identificativoFlusso#', identificativoFlusso)
            setattr(context, 'identificativoFlusso', identificativoFlusso)

        if '#iuv#' in payload:
            iuv = "IUV" + str(random.randint(0, 10000)) + "-" + \
                datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S.%f")[:-3]
            payload = payload.replace('#iuv#', iuv)
            setattr(context, 'iuv', iuv)

        payload = utils.replace_context_variables(payload, context)
        payload = utils.replace_global_variables(payload, context)

        payload_b = bytes(payload, 'UTF-8')
        payload_uni = b64.b64encode(payload_b)
        payload = f"{payload_uni}".split("'")[1]
        print(payload)

        print("REND generata: ", payload)
        setattr(context, 'rendAttachment', payload)

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


@given('for {type} replace {tag} with {value} in {primitive}')
def step_impl(context, type, tag, value, primitive):
    try:
        if tag != "-":
            value = utils.replace_local_variables(value, context)
            value = utils.replace_context_variables(value, context)
            value = utils.replace_global_variables(value, context)
            type_string = type.upper()
            if type_string == "XML":
                xml = utils.manipulate_soap_action(getattr(context, primitive), tag, value)
                setattr(context, primitive, xml)
            elif type_string == "JSON":
                json = utils.manipulate_json(getattr(context, primitive), tag, value)
                setattr(context, primitive, json)
    
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


@given('{elem} with {value} in {action}')
def step_impl(context, elem, value, action):
    try:
        # use - to skip
        if elem != "-":
            value = utils.replace_local_variables(value, context)
            value = utils.replace_context_variables(value, context)
            value = utils.replace_global_variables(value, context)
            xml = utils.manipulate_soap_action(getattr(context, action), elem, value)

            if action == "bollo":
                xml_b = bytes(xml, 'UTF-8')
                xml_uni = b64.b64encode(xml_b)
                xml = f"{xml_uni}".split("'")[1]

            setattr(context, action, xml)
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

@given('replace {old_tag} tag in {action} with {new_tag}')
def step_impl(context, old_tag, new_tag, action):
    if old_tag != '-':
        my_document = parseString(getattr(context, action))
        tag = my_document.getElementsByTagName(old_tag)[0]
        tag.tagName = new_tag
        setattr(context, action, my_document.toxml())


@given('{attribute} set {value} for {elem} in {primitive}')
def step_impl(context, attribute, value, elem, primitive):
    my_document = parseString(getattr(context, primitive))
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    setattr(context, primitive, my_document.toxml())


@step('{sender} sends soap {soap_primitive} to {receiver}')
def step_impl(context, sender, soap_primitive, receiver):
    try:
        myconfigfile = getattr(context, 'myconfigfile')
        #Check se l'ultimo carattere della soap primitive è un numero, in questo caso lo taglia
        soap_primitive_original = ''

        if soap_primitive[-1].isdigit():
            if 'nodoInviaRPT' in soap_primitive or 'nodoInviaCarrelloRPT' in soap_primitive:
                soap_primitive_original = soap_primitive[:-1]
            else:
                soap_primitive_original = soap_primitive
        else:
            soap_primitive_original = soap_primitive

        url_nodo = utils.get_soap_url_nodo(context, soap_primitive_original)

        flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

        headers = ''
        header_host = utils.estrapola_header_host(url_nodo)

        if flag_subscription == 'Y':
            headers = {'Content-Type': 'application/xml', 'SOAPAction': soap_primitive_original, 'Host': header_host, 'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}
        else:
            headers = {'Content-Type': 'application/xml', 'SOAPAction': soap_primitive_original, 'Host': header_host}
        
        print("url_nodo: ", url_nodo)
        print("nodo soap_request sent >>>", getattr(context, soap_primitive))
        print("headers: ", headers)

        user_profile = None

        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        soap_response = ''
        if 'postgres_apim' in myconfigfile or 'oracle' in myconfigfile:
            soap_response = requests.post(url_nodo, getattr(context, soap_primitive), headers=headers, verify=False)
        else:
            soap_response = requests.post(url_nodo, getattr(context, soap_primitive), headers=headers, verify=False, proxies=getattr(context, "proxies"))

        print('soap response content: ' + soap_response.content.decode('utf-8'))
        print(f'soap response status code: {soap_response.status_code}')
        print(f'soap response header: {soap_response.headers}')
        setattr(context, soap_primitive + RESPONSE, soap_response)

        assert (soap_response.status_code == 200), f"status_code {soap_response.status_code}"

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




@when('job {job_name} triggered after {seconds} seconds')
def step_impl(context, job_name, seconds):
    try:
        user_profile = None

        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        seconds = utils.replace_local_variables(seconds, context)
        time.sleep(int(seconds))

        dbRun = getattr(context, "dbRun")

        url_nodo = ''
        if dbRun == "Postgres":
            url_nodo = (context.config.userdata.get("services").get("nodo-dei-pagamenti").get("refresh_config_service")).split("config")[0]
        elif dbRun == 'Oracle':
            url_nodo = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url")       

        flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

        headers = ''
        header_host = utils.estrapola_header_host(url_nodo)

        if flag_subscription == 'Y':
            headers = {'Content-Type': 'application/xml', 'Host': header_host, 'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}
        else:
            headers = {'Content-Type': 'application/xml', 'Host': header_host}

        nodo_response = None 
        
        if dbRun == "Postgres":
            nodo_response = requests.get(f"{url_nodo}jobs/trigger/{job_name}", headers=headers, verify=False, proxies = getattr(context,'proxies'))
            print(f">>>>>>>>>>>>>>>>>> {url_nodo}jobs/trigger/{job_name} with proxies {getattr(context,'proxies')}")
        elif dbRun == "Oracle":
            #RUN DA LOCALE
            if user_profile != None:
                nodo_response = requests.get(f"{url_nodo}/jobs/trigger/{job_name}", headers=headers, verify=False)
                print(f">>>>>>>>>>>>>>>>>> {url_nodo}/jobs/trigger/{job_name}")
            #RUN DA REMOTO
            else:
                nodo_response = requests.get(f"{url_nodo}-monitoring/monitoring/v1/jobs/trigger/{job_name}", headers=headers, verify=False)
                print(f">>>>>>>>>>>>>>>>>> {url_nodo}-monitoring/monitoring/v1/jobs/trigger/{job_name}")
                
        assert nodo_response.status_code == 200, f"Expected status code 200 but got {nodo_response.status_code}" 
        setattr(context, job_name + RESPONSE, nodo_response)

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

# verifica che il valore cercato corrisponda all'intera sottostringa del tag
@then('check {tag} is {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    try:
        soap_response = getattr(context, primitive + RESPONSE)
        value = utils.replace_local_variables(value, context)
        value = utils.replace_context_variables(value, context)
        value = utils.replace_global_variables(value, context)

        fault_code = ''
        fault_string = ''
        description = ''

        if 'xml' in soap_response.headers['content-type']:
            my_document = parseString(soap_response.content)
            if len(my_document.getElementsByTagName('faultCode')) > 0:
                fault_code = my_document.getElementsByTagName('faultCode')[0].firstChild.data
                fault_string = my_document.getElementsByTagName('faultString')[0].firstChild.data
                
                if my_document.getElementsByTagName('description') and my_document.getElementsByTagName('description')[0].firstChild:
                    description = my_document.getElementsByTagName('description')[0].firstChild.data
                else:
                    description = 'description empty!!!'

            data = my_document.getElementsByTagName(tag)[0].firstChild.data
            
            assert value == data, f"""check tag {tag} - expected: {value}, obtained: {data} in xml
                                      description: {description}
                                      fault code: {fault_code}
                                      fault string: {fault_string}
                                   """
            print(f'check tag "{tag}" - expected: {value}, obtained: {data}')
        else:
            node_response = getattr(context, primitive + RESPONSE)
            status_code = node_response.status_code
            print(f'status code obtained: {status_code}')
            json_response = node_response.json()
            founded_value = jo.get_value_from_key(json_response, tag)

            if status_code != 200:
                description = jo.get_value_from_key(json_response, 'descrizione')
                   
            assert str(founded_value) == value, f"""check tag {tag} - expected: {value}, obtained: {founded_value} in json
                                                 description: {description}
                                                 """
            print(f'check tag "{tag}" - expected: {value}, obtained: {founded_value}')
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



# a partire da un path tag passato in input, la funzione verifica che il valore cercato corrisponda all'intera sottostringa del tag 
@then('check from {path_tag} the {value} of {primitive} response')
def step_impl(context, path_tag, value, primitive):
    try:
        soap_response = getattr(context, primitive + RESPONSE)
        value = utils.replace_local_variables(value, context)
        value = utils.replace_context_variables(value, context)
        value = utils.replace_global_variables(value, context)

        if 'xml' in soap_response.headers['content-type']:
            my_document_xml = soap_response.content
            list_tag_value = []
            list_tag_value = utils.searchValueTag(my_document_xml, path_tag, False)
            data = list_tag_value[0]
            print(f'check path tag "{path_tag}" - expected: {value}, obtained: {data}')
            assert value == data

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

@then('from {key} check the {value} in {path_tag}')
def step_impl(context, path_tag, value, key):
    query_body = getattr(context, key)
    value = utils.replace_local_variables(value, context)
    value = utils.replace_context_variables(value, context)
    value = utils.replace_global_variables(value, context)

    if 'xml' in query_body:
        list_tag_value = []
        list_tag_value = utils.searchValueTag(query_body, path_tag, False)
        data = list_tag_value[0]
        print(f'check path tag "{path_tag}" - expected: {value}, obtained: {data}')
        assert value == data
    else:
        assert False




@then('checks {tag} is not {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    value = utils.replace_local_variables(value, context)
    value = utils.replace_context_variables(value, context)
    value = utils.replace_global_variables(value, context)

    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        if len(my_document.getElementsByTagName('faultCode')) > 0:
            print("fault code: ", my_document.getElementsByTagName(
                'faultCode')[0].firstChild.data)
            print("fault string: ", my_document.getElementsByTagName(
                'faultString')[0].firstChild.data)
            # if my_document.getElementsByTagName('description'):
            #     print("description: ", my_document.getElementsByTagName(
            #         'description')[0].firstChild.data)
        data = my_document.getElementsByTagName(tag)[0].firstChild.data
        print(f'check tag "{tag}" - expected: {value}, obtained: {data}')
        assert value != data
    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        founded_value = jo.get_value_from_key(json_response, tag)
        print(f'check tag "{tag}" - expected: {value}, obtained: {founded_value}')
        assert str(founded_value) != value



@step('checks {tag} contains {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    try:
        soap_response = getattr(context, primitive + RESPONSE)
        if 'xml' in soap_response.headers['content-type']:
            my_document = parseString(soap_response.content)
            nodeList = my_document.getElementsByTagName(tag)
            values = [node.childNodes[0].nodeValue for node in nodeList]
            print(values)
            assert value in values, f"{tag} doesn't contains {value} in {primitive} response"
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


@then('check {tag} contains {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    try:
        value = utils.replace_local_variables(value, context)
        value = utils.replace_context_variables(value, context)
        soap_response = getattr(context, primitive + RESPONSE)

        fault_code = ''
        fault_string = ''
        description = ''
        if 'xml' in soap_response.headers['content-type']:
            my_document = parseString(soap_response.content)
            if len(my_document.getElementsByTagName('faultCode')) > 0:
                fault_code = my_document.getElementsByTagName('faultCode')[0].firstChild.data
                fault_string = my_document.getElementsByTagName('faultString')[0].firstChild.data

                if my_document.getElementsByTagName('description') and my_document.getElementsByTagName('description')[0].firstChild:
                    description = my_document.getElementsByTagName('description')[0].firstChild.data
                else:
                    description = 'description empty!!!'

            data = my_document.getElementsByTagName(tag)[0].firstChild.data
            
            assert value in data, f"""check tag {tag} contains - expected: {value} in {primitive} response, obtained: {data} in xml
                            description: {description}
                            fault code: {fault_code}
                            fault string: {fault_string}
                        """
            print(f'check tag "{tag}" - expected: {value}, obtained: {data}')
        else:
            node_response = getattr(context, primitive + RESPONSE)
            json_response = node_response.json()
            json_response = jo.convert_json_values_toString(json_response)

            founded_value = jo.get_value_from_key(json_response, tag)
            find = jo.search_value(json_response, tag, value)
            assert find, f"check tag {tag} contains - expected: {value} in {primitive} response, obtained: {founded_value} in json"
            
            print('>>>>>>>>>>>>>>', json_response)
            print(value)

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



@then('check {tag} field exists in {primitive} response')
def step_impl(context, tag, primitive):
    try:
        soap_response = getattr(context, primitive + RESPONSE)

        if 'xml' in soap_response.headers['content-type']:
            my_document = parseString(soap_response.content)
            assert len(my_document.getElementsByTagName(tag)) > 0,f"size: {len(my_document.getElementsByTagName(tag))} by tag: {tag} in soap response: {soap_response.content} is <= 0"

        else:
            node_response = getattr(context, primitive + RESPONSE)
            json_response = node_response.json()
            find = jo.search_tag(json_response, tag)
            assert find,f"find tag: {tag} in json response: {json_response} is: {find}"

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


@then('check {tag} field not exists in {primitive} response')
def step_impl(context, tag, primitive):
    try:
        soap_response = getattr(context, primitive + RESPONSE)
        if 'xml' in soap_response.headers['content-type']:
            my_document = parseString(soap_response.content)
            assert len(my_document.getElementsByTagName(tag)) == 0,f"size: {len(my_document.getElementsByTagName(tag))} by tag: {tag} in soap response: {soap_response.content} is != 0"
        else:
            node_response = getattr(context, primitive + RESPONSE)
            json_response = node_response.json()
            find = jo.search_tag(json_response, tag)
            assert not find,f"find tag: {tag} in json response: {json_response} is: {find}"

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





@step('the {name} scenario executed successfully')
def step_impl(context, name):
    phase = ([phase for phase in context.feature.scenarios if name in phase.name] or [None])[0]
    text_step = ''.join([step.keyword + " " + step.name + "\n\"\"\"\n" + (step.text or '') + "\n\"\"\"\n" for step in phase.steps])
    context.execute_steps(text_step)





@when(u'{sender} sends rest {method} {service} to {receiver}')
def step_impl(context, sender, method, service, receiver):
    try:
        myconfigfile = getattr(context, 'myconfigfile')
        url_nodo = utils.get_rest_url_nodo(context, service)
        print(url_nodo)

        flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

        headers = ''
        header_host = utils.estrapola_header_host(url_nodo)

        if flag_subscription == 'Y':
            headers = {'Content-Type': 'application/json', 'Host': header_host, 'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}
        else:
            headers = {'Content-Type': 'application/json', 'Host': header_host}

        body = context.text or ""
        if '_json' in service:
            service = service.split('_')[0]
            print(service)
            bodyXml = getattr(context, service)
            body = xmltodict.parse(bodyXml)
            body = body["root"]
            if body != None:
                if ('paymentTokens' in body.keys()) and (
                        body["paymentTokens"] != None and (type(body["paymentTokens"]) != str)):
                    body["paymentTokens"] = body["paymentTokens"]["paymentToken"]
                    if type(body["paymentTokens"]) != list:
                        l = list()
                        l.append(body["paymentTokens"])
                        body["paymentTokens"] = l
                if ('totalAmount' in body.keys()) and (body["totalAmount"] != None):
                    body["totalAmount"] = float(body["totalAmount"])
                if ('fee' in body.keys()) and (body["fee"] != None):
                    body["fee"] = float(body["fee"])
                if ('RRN' in body.keys()) and (body["RRN"] != None):
                    body["RRN"] = float(body["RRN"])
                if ('importoTotalePagato' in body.keys()) and (body["importoTotalePagato"] != None):
                    body["importoTotalePagato"] = float(body["importoTotalePagato"])
                if ('primaryCiIncurredFee' in body.keys()) and (body["primaryCiIncurredFee"] != None):
                    body["primaryCiIncurredFee"] = float(body["primaryCiIncurredFee"])
                if ('positionslist' in body.keys()) and (body["positionslist"] != None):
                    body["positionslist"] = body["positionslist"]["position"]
                    if type(body["positionslist"]) != list:
                        l = list()
                        l.append(body["positionslist"])
                        body["positionslist"] = l
                body = json.dumps(body, indent=4)
            else:
                body = """{}"""

        body = utils.replace_local_variables(body, context)
        body = utils.replace_context_variables(body, context)
        body = utils.replace_global_variables(body, context)

        run_local = False
        if service in url_nodo:
            url_nodo = utils.replace_local_variables(url_nodo, context)
            url_nodo = utils.replace_context_variables(url_nodo, context)
            run_local = True
        else:
            service = utils.replace_local_variables(service, context)
            service = utils.replace_context_variables(service, context)
        if len(body) > 1:
            json_body = json.loads(body)
        else:
            json_body = None

        nodo_response = None
        #RUN DA LOCALE
        if run_local:
            if '_json' in url_nodo:
                url_nodo = url_nodo.split('_')[0]

            print(f"URL REST: {url_nodo}")
            print(f"Body: {json_body}")

            nodo_response = ''
            if 'postgres_apim' in myconfigfile or 'oracle' in myconfigfile:
                nodo_response = requests.request(method, f"{url_nodo}", headers=headers, json=json_body, verify=False)
            else:
                nodo_response = requests.request(method, f"{url_nodo}", headers=headers, json=json_body, verify=False, proxies=getattr(context, "proxies"))
        #RUN DA REMOTO
        else:
            print(f"URL REST: {url_nodo}/{service}")
            print(f"Body: {json_body}")

            nodo_response = requests.request(method, f"{url_nodo}/{service}", headers=headers, json=json_body, verify=False)   
        
        print(f"rest response content: {nodo_response.content}")
        print(f'rest response headers: {nodo_response.headers}')
        print(service.split('?')[0] + RESPONSE)
        
        setattr(context, service.split('?')[0], json_body)
        setattr(context, service.split('?')[0] + RESPONSE, nodo_response)

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


@then('verify the HTTP status code of {action} response is {value}')
def step_impl(context, action, value):
    try:
        assert int(value) == getattr(context, action + RESPONSE).status_code,f'HTTP status expected: {value} - obtained:{getattr(context, action + RESPONSE).status_code}'
        print(f'HTTP status expected: {value} - obtained:{getattr(context, action + RESPONSE).status_code}')
    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print(f"----->>>> Assertion Error: {e} and description error is: {getattr(context, action + RESPONSE).text}")
        # Interrompiamo il test
        raise AssertionError(str(e))


@given('{mock} replies to {destination} with the {primitive}')
def step_impl(context, mock, destination, primitive):
    try:
        if context.text:
            pa_verify_payment_notice_res = context.text
        else:
            pa_verify_payment_notice_res = getattr(context, primitive)
        pa_verify_payment_notice_res = str(pa_verify_payment_notice_res).replace("#fiscalCodePA#", context.config.userdata.get("global_configuration").get("creditor_institution_code"))

        if '$iuv' in pa_verify_payment_notice_res:
            pa_verify_payment_notice_res = pa_verify_payment_notice_res.replace(
                '$iuv', getattr(context, 'iuv'))

        setattr(context, primitive, pa_verify_payment_notice_res)
        print(pa_verify_payment_notice_res)
        if mock == 'EC':
            print(utils.get_soap_mock_ec(context))
            response_status_code = utils.save_soap_action(context, utils.get_soap_mock_ec(context), primitive, pa_verify_payment_notice_res, override=True)
        elif mock == 'EC2':
            print(utils.get_soap_mock_ec2(context))
            response_status_code = utils.save_soap_action(context, utils.get_soap_mock_ec2(context), primitive, pa_verify_payment_notice_res, override=True)
        elif mock == 'PSP':
            print(utils.get_soap_mock_psp(context))
            response_status_code = utils.save_soap_action(context, utils.get_soap_mock_psp(context), primitive, pa_verify_payment_notice_res, override=True)
        elif mock == 'PSP2':
            print(utils.get_soap_mock_psp2(context))
            response_status_code = utils.save_soap_action(context, utils.get_soap_mock_psp2(context), primitive, pa_verify_payment_notice_res, override=True)
        else:
            assert False, "Invalid mock"
        assert response_status_code == 200

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



@step('if {field} is {field_value} set {elem} to {value} in {primitive}')
def step_impl(context, field, field_value, elem, value, primitive):
    xml = getattr(context, primitive)
    my_document = parseString(xml)
    field_data = my_document.getElementsByTagName(field)
    if len(field_data) > 0 and len(field_data[0].childNodes) > 0 and field_data[0].firstChild.data == field_value:
        xml = utils.manipulate_soap_action(xml, elem, value)
        setattr(context, primitive, xml)



@step('save {primitive} response in {new_primitive}')
def step_impl(context, primitive, new_primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    print(f"RESPONSE of primitive {primitive} with payload {soap_response.content} saving in {new_primitive + RESPONSE}")
    setattr(context, new_primitive + RESPONSE, soap_response)


@step('saving {primitive} request in {new_primitive}')
def step_impl(context, primitive, new_primitive):
    soap_request = getattr(context, primitive)
    print(f"REQUEST of primitive {primitive} with payload {soap_request} saving in {new_primitive}")
    setattr(context, new_primitive, soap_request)


@step('random iuv in context')
def step_impl(context):
    iuv = '11' + str(random.randint(1000000000000, 9999999999999))
    setattr(context, "iuv", iuv)




@step('current date plus {minutes:d} minutes generation')
def step_impl(context, minutes):
    date_plus_minutes = (datetime.datetime.now().astimezone(pytz.timezone('Europe/Rome')) + datetime.timedelta(
        minutes=minutes)).strftime("%Y-%m-%d %H:%M:%S")
    setattr(context, 'date_plus_minutes', date_plus_minutes)


@then('{response} response is equal to {response_1} response')
def step_impl(context, response, response_1):
    soap_response = getattr(
        context, response + RESPONSE).content.decode('utf-8')
    soap_response_1 = getattr(context, response_1 +
                              RESPONSE).content.decode('utf-8')

    assert soap_response == soap_response_1



@step("random idempotencyKey having {value} as idPSP in {primitive}")
def step_impl(context, value, primitive):
    try:
        value = utils.replace_local_variables(value, context)
        value = utils.replace_context_variables(value, context)
        value = utils.replace_global_variables(value, context)

        xml = utils.manipulate_soap_action(getattr(context, primitive), "idempotencyKey",
                                        f"{value}_{str(random.randint(1000000000, 9999999999))}")
        setattr(context, primitive, xml)
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




@step("nodo-dei-pagamenti has config parameter {param} set to {value}")
def step_impl(context, param, value):
    try:
        dbRun = getattr(context, "dbRun")
        db_name = "nodo_cfg"
        db_selected = context.config.userdata.get("db_configuration").get(db_name)

        update_config_query = "update_config_postgresql" if dbRun == "Postgres" else "update_config_oracle"

        if utils.contiene_carattere_apice(value):
            value = value.replace("'", "''")

        if value == 'empty':
            value = ''

        selected_query = utils.query_json(context, update_config_query, 'configurations').replace('value', f"'{value}'").replace('key', param)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        setattr(context, param, value)
        print(">>>>>>>>>>>>>>>", getattr(context, param))

        exec_query = adopted_db.executeQuery(context, conn, selected_query, as_dict=True)
        if exec_query is not None:
            print(f'executed query: {exec_query}')

        adopted_db.closeConnection(conn)

        flag_subscription = context.config.userdata.get("services").get("nodo-dei-pagamenti").get("subscription_key_name")

        headers = ''
        header_host = utils.estrapola_header_host(utils.get_refresh_config_url(context))

        if flag_subscription == 'Y':
            headers = {'Host': header_host, 'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}
        else:
            headers = {'Host': header_host}

        user_profile = None

        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")
        
        print("Refreshing...")
        refresh_response = None
        if dbRun == "Postgres":
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False, proxies = getattr(context,'proxies'))
        elif dbRun == "Oracle":
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False)

        time.sleep(5)
        
        print('refresh_response: ', refresh_response)
        assert refresh_response.status_code == 200, f"Refresh Failed!!!!"

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
    
    
@step("update parameter {param} on configuration keys with value {value}")
def step_impl(context, param, value):
    try:
        dbRun = getattr(context, "dbRun")
        db_name = "nodo_cfg"
        db_selected = context.config.userdata.get("db_configuration").get(db_name)

        update_config_query = "update_config_postgresql" if dbRun == "Postgres" else "update_config_oracle"

        if utils.contiene_carattere_apice(value):
            value = value.replace("'", "''")

        selected_query = utils.query_json(context, update_config_query, 'configurations').replace('value', f"'{value}'").replace('key', param)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        setattr(context, param, value)
        print(">>>>>>>>>>>>>>>", getattr(context, param))

        exec_query = adopted_db.executeQuery(context, conn, selected_query, as_dict=True)
        if exec_query is not None:
            print(f'executed query: {exec_query}')

        adopted_db.closeConnection(conn)

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


@step("waiting after triggered refresh job {job_name}")
def step_impl(context, job_name):
    try:
        headers = {'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}

        dbRun = getattr(context, "dbRun")

        user_profile = None

        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        print("Refreshing...")
        refresh_response = None

        if dbRun == "Postgres":
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False, proxies = getattr(context,'proxies'))
        elif dbRun == "Oracle":
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False)

        setattr(context, job_name + RESPONSE, refresh_response)

        #CHECK NEW RECORD CACHE AFTER REFRESH
        db_name = "nodo_cfg"
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        new_record_cache = utils.query_new_record_cache(context, conn, adopted_db, dbRun)

        adopted_db.closeConnection(conn)

        assert new_record_cache == True, f"New record cache not found!"
        assert refresh_response.status_code == 200, f"refresh status code expected: {200} but obtained: {refresh_response.status_code}"

        print("Refresh Completed!")

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


@step("refresh job {job_name} triggered after 10 seconds")
def step_impl(context, job_name):
    try:
        headers = {'Ocp-Apim-Subscription-Key': getattr(context, "SUBKEY")}

        dbRun = getattr(context, "dbRun")

        user_profile = None

        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        print("Refreshing...")
        refresh_response = None
        if dbRun == "Postgres":
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False, proxies = getattr(context,'proxies'))
        elif dbRun == "Oracle":
            print(f"URL refresh: {utils.get_refresh_config_url(context)}")
            refresh_response = requests.get(utils.get_refresh_config_url(context), headers=headers, verify=False)

        setattr(context, job_name + RESPONSE, refresh_response)
        time.sleep(10)
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



@step(u"update with date {date} for column {column_name} in table {table_name} on db {db_name} with where datatable {type_table}")
def step_impl(context, date, column_name, table_name, db_name, type_table): 
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)

        assert context.table is not None, "Datatable non inserita!!!"

        # 1. Gestione tipi di date
        if date == 'Today':
            date = datetime.datetime.today().astimezone(pytz.timezone('Europe/Rome')).strftime("%Y-%m-%d %H:%M:%S")
        elif date == 'Yesterday':
            date = (datetime.datetime.today().astimezone(pytz.timezone('Europe/Rome')) - datetime.timedelta(days=1)).strftime("%Y-%m-%d %H:%M:%S")
        elif date == '1minuteLater':
            date = (datetime.datetime.now().astimezone(pytz.timezone('Europe/Rome')) + datetime.timedelta(minutes=1)).strftime("%Y-%m-%d %H:%M:%S")

        # 2. Datatable → dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        # 3. Costruzione WHERE
        where_conditions = " AND ".join([f"{field} = '{value[0]}'" for field, value in dict_fields_values.items()])
        upd_query = f"UPDATE table_name SET param WHERE {where_conditions}"

        # 4. Sostituzioni
        upd_query = upd_query.replace("table_name", table_name)
        upd_query = upd_query.replace("param", f"{column_name} = '{date}'")
        upd_query = utils.replace_global_variables(upd_query, context)
        upd_query = utils.replace_local_variables(upd_query, context)
        upd_query = utils.replace_context_variables(upd_query, context)

        print(f"UPDATE QUERY: {upd_query}")

        # 5. Esegui update
        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)
        exec_query = utils.update_query(context, conn, adopted_db, upd_query)
        adopted_db.closeConnection(conn)

    except AssertionError as e:
        print(f"----->>>> Assertion Error: {e}")
        raise AssertionError(str(e))
    except Exception as e:
        print(f"----->>>> Exception: {e}")
        raise e




    
    


@step("execution query to get value {result_query} on the table {table_name}, with the columns {columns} with db name {db_name} with where datatable {type_table}")
def step_impl(context, result_query, type_table, db_name, table_name, columns):
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        # Costruisce la query a partire dalla where
        selected_query = utils.generate_select(dict_fields_values)

        selected_query = selected_query.replace("columns", columns).replace("table_name", table_name)
        selected_query = utils.replace_local_variables(selected_query, context)
        selected_query = utils.replace_context_variables(selected_query, context)
        selected_query = utils.replace_global_variables(selected_query, context)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        # EXECUTE QUERY WITH POLLING SET TO 60 SEC
        exec_query = utils.query_with_polling(context, conn, adopted_db, selected_query, 1)
            
        assert exec_query is not None and len(exec_query) != 0 and len(exec_query) == 1, f"Result query empty or None or size is not 1 for table: {table_name} !"

        if exec_query is not None:
            print(f'executed query: {exec_query}')
            
        setattr(context, result_query, exec_query)
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
    
    

@step("execution query {query_name} to get value on the table {table_name}, with the columns {columns} under macro {macro} with db name {db_name}")
def step_impl(context, query_name, macro, db_name, table_name, columns):
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)

        selected_query = utils.query_json(context, query_name, macro).replace("columns", columns).replace("table_name", table_name)
        selected_query = utils.replace_local_variables(selected_query, context)
        selected_query = utils.replace_context_variables(selected_query, context)
        selected_query = utils.replace_global_variables(selected_query, context)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        exec_query = adopted_db.executeQuery(context, conn, selected_query)
        if exec_query is not None:
            print(f'executed query: {exec_query}')
            
        setattr(context, query_name, exec_query)
        
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


# step per salvare nel context una variabile key recuperata dal db tramite query query_name
@step("through the query {query_name} retrieve param {param} at position {position:d} and save it under the key {key}")
def step_impl(context, query_name, param, position, key):
    try:
        result_query = getattr(context, query_name)
        print(f'{query_name}: {result_query}')

        if position == -1:  # il -1 recupera tutti i record
            selected_element = [t[0] for t in result_query]
        else:
            selected_element = result_query[0][position]
        print(f'{param}: {selected_element}')
        setattr(context, key, selected_element)
            
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


# @step("through the query {query_name} retrieve param {param} at position {position:d} in the row {row_number:d} and save it under the key {key}")
# def step_impl(context, query_name, param, position, row_number, key):
#     result_query = getattr(context, query_name)
#     print(f'{query_name}: {result_query}')
#     selected_element = result_query[row_number][position]
#     print(f'{param}: {selected_element}')
#     setattr(context, key, selected_element)
    



@step("through the query {query_name} retrieve {type_body} {body} at position {position:d} and save it under the key {key}")
def step_impl(context, query_name, type_body, body, position, key):
    try:
        result_query_clean = None
        dbRun = getattr(context, "dbRun")
        result_query = getattr(context, query_name)
        print(f'{query_name}: {result_query}')

        selected_element = ''
        if type_body == 'xml':
            if dbRun == "Postgres":
                selected_element = result_query[0][position].tobytes().decode('utf-8')
            elif dbRun == "Oracle":
                selected_element = result_query[0][position].read().decode('utf-8')
        elif type_body == 'json':
            if isinstance(result_query[0][0], str):
                if result_query[0][0].startswith("[") and result_query[0][0].endswith("]"):
                    json_clean = result_query[0][0].strip("[]").encode("utf-8")
                    memory_view_json_clean = memoryview(json_clean)
                    result_query_clean = [(memory_view_json_clean,)]
                    result_query = result_query_clean
            selected_element = result_query

        if 'aim:' in selected_element:
            selected_element = selected_element.replace("aim:", "")
        print(f'{body}: {selected_element}')
        setattr(context, key, selected_element)
        
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


@step("by the query {query_name} retrieve xml_no_decode {xml} at position {position:d} and save it under the key {key}")
def step_impl(context, query_name, xml, position, key):
    try:    
        result_query = getattr(context, query_name)
        print(f'{query_name}: {result_query}')
        selected_element = result_query[0][position]
        print(f'{xml}: {selected_element}')
        setattr(context, key, selected_element)
        
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


# @step("with the query {query_name1} check assert beetwen elem {elem1} in position {position1:d} and elem {elem2} with position {position2:d} of the query {query_name2}")
# def stemp_impl(context, query_name1, elem1, position1, elem2, query_name2, position2):
#     result_query1 = getattr(context, query_name1)
#     result_query2 = getattr(context, query_name2)
#     print("elem1: ", result_query1[0][position1])
#     print("elem2: ", result_query2[0][position2])

#     assert result_query1[0][position1] == result_query2[0][position2]


@Step("call the {elem} of {primitive} response as {name}")
def step_impl(context, elem, primitive, name):
    try:
        payload = getattr(context, primitive + RESPONSE)
        my_document = parseString(payload.content)
        if len(my_document.getElementsByTagName(elem)) > 0:
            elem_value = my_document.getElementsByTagName(elem)[0].firstChild.data
            setattr(context, name, elem_value)
        else:
            assert False, f"the field {elem} doesn't exist into the response"
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

@then("verify the {elem} of the {primitive} response is equals to {name}")
def step_impl(context, elem, primitive, name):
    try:
        payload = getattr(context, primitive + RESPONSE)
        my_document = parseString(payload.content)
        if len(my_document.getElementsByTagName(elem)) > 0:
            elem_value = my_document.getElementsByTagName(elem)[0].firstChild.data
            target = getattr(context, name)
            print(f'check tag "{elem}" - expected: {target}, obtained: {elem_value}')
            assert elem_value == target
        else:
            assert False, f"the field {elem} doesn't exist into the response"
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


@then("verify the {elem} of the {primitive} response is not equals to {name}")
def step_impl(context, elem, primitive, name):
    try:
        payload = getattr(context, primitive + RESPONSE)
        my_document = parseString(payload.content)
        if len(my_document.getElementsByTagName(elem)) > 0:
            elem_value = my_document.getElementsByTagName(elem)[0].firstChild.data
            target = getattr(context, name)
            print(f'check tag "{elem}" - expected: {target}, obtained: {elem_value}')
            assert elem_value != target
        else:
            assert False, f"the field {elem} doesn't exist into the response"
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



@step("{mock} waits {number} minutes for expiration")
def step_impl(context, mock, number):
    seconds = float(number) * 60
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)


@step("wait {number} seconds for expiration")
def step_impl(context, number):
    seconds = float(number)
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)


@step("{mock} waits {number} seconds for expiration")
def step_impl(context, mock, number):
    seconds = float(number)
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)



@step(u"generate list columns {columns} and dict fields values expected {fields_values_expected} for query checks all values with datatable {type_table}")
def step_impl(context, columns, fields_values_expected, type_table):
    try:
        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per i valori dei fields e values per la query allo step successivo
        dict_fields_values = utils.table_to_dict(context.table, type_table)

        # Costruisce la list columns e la dict da passare al checks allo step successivo
        list_columns = list()  
        dict_fields_values_expected = {}

        for field, value in zip(dict_fields_values['column'], dict_fields_values['value']):
            dict_fields_values_expected[field] = utils.replace_placeholders(value)


        for field, value in dict_fields_values_expected.items():
            list_columns.append(field)

        setattr(context, columns, list_columns)
        setattr(context, fields_values_expected, dict_fields_values_expected)
    
    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print(f"----->>>> Assertion Error: {e}")
        # Interrompiamo il test
        raise AssertionError(str(e))
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print(f"----->>>> Exception: {e}")
        # Interrompiamo il test
        raise e

@step(u"checks all values by {d_fields_values_expected} of the record for each columns {l_columns} of the table {table_name} retrived by the query on db {db_name} with where datatable {type_table}")
def step_impl(context, d_fields_values_expected, l_columns, table_name, db_name, type_table): 
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)

        string_list_columns = utils.replace_context_variables(l_columns, context).replace("[", '').replace("]", '').replace("'",'')
        list_col_split = [col.strip() for col in string_list_columns.split(',')]
        columns = utils.generate_string_column_table(list_col_split)

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        # Costruisce la query a partire dalla where
        selected_query = utils.generate_select(dict_fields_values)

        selected_query = selected_query.replace("columns", columns).replace("table_name", table_name)
        selected_query = utils.replace_global_variables(selected_query, context)
        selected_query = utils.replace_local_variables(selected_query, context)
        selected_query = utils.replace_context_variables(selected_query, context)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        ###CONVERSIONE STRINGA IN DICT
        dict_fields_values_expected = json.loads(utils.replace_context_variables(d_fields_values_expected, context).replace("'",'"'))

        ###CREAZIONE LIST VALUES EXPECTED E SIZE VALUE CON COMMA
        list_values_expected, size_dict_fields_values_expected = utils.generate_list_values_exp_and_size_value_comma(dict_fields_values_expected)

        ###CREAZIONE LIST DI DICT VALUES EXPECTED BY SIZE
        list_dict_fields_values_expected = utils.generate_list_dict_values_exp(list_col_split, size_dict_fields_values_expected, list_values_expected)

        # EXECUTE QUERY WITH POLLING SET TO 60 SEC
        exec_query = utils.query_with_polling(context, conn, adopted_db, selected_query, size_dict_fields_values_expected+1)
            
        assert exec_query is not None and len(exec_query) != 0, f"Result query empty or None for table: {table_name} !"
       
        ###CREAZIONE LIST DI DICT VALUES OBTAINED
        list_dict_fields_values_obtained = utils.generate_list_dict_values_obt(list_col_split, exec_query)

        ###CHECK SE NELLA LIST DI VALUE OBTAINED MANCANO RECORD RISPETTO ALLA LIST VALUE EXPECTED
        assert len(list_dict_fields_values_obtained) == size_dict_fields_values_expected+1, f"For checks all values the number of records obtained {len(list_dict_fields_values_obtained)} is different than records expected {size_dict_fields_values_expected+1}, for table {table_name}!"

        print(f"query result: {list_dict_fields_values_obtained}")

        ###CHECKS PHASE
        for single_dict_fields_values_obtained, single_dict_fields_values_expected in zip(list_dict_fields_values_obtained, list_dict_fields_values_expected):
            for field, value in single_dict_fields_values_obtained.items():
                if single_dict_fields_values_expected[field] == 'None':
                    assert value == None, f"For table {table_name} -> assert result query with None for Failed for field: {field}"
                    print(f"For table {table_name} -> check value None for field {field} ---> OK!")
                elif single_dict_fields_values_expected[field] == 'NotNone':
                    assert value != None, f"For table {table_name} -> assert result query with Not None Failed for field: {field}"
                    print(f"For table {table_name} -> check value NotNone for field {field} ---> OK!")
                else:
                    single_dict_fields_values_expected[field] = utils.replace_global_variables(single_dict_fields_values_expected[field], context)
                    single_dict_fields_values_expected[field] = utils.replace_local_variables(single_dict_fields_values_expected[field], context)
                    single_dict_fields_values_expected[field] = utils.replace_context_variables(single_dict_fields_values_expected[field], context)

                    if utils.isFloat(single_dict_fields_values_expected[field]):
                        assert float(value) == float(single_dict_fields_values_expected[field]), f"For table {table_name} -> check for field: {field} ---> expected element: {float(single_dict_fields_values_expected[field])}, obtained: {float(value)}"
                    elif utils.isNumeric(single_dict_fields_values_expected[field]) and utils.isDecimal(single_dict_fields_values_expected[field]):
                        flag_int_cast_KO = False
                        try:
                            int(value)
                        except Exception as e:
                            flag_int_cast_KO = True

                        if flag_int_cast_KO:
                            value = float(value)
                            value = int(value)
                            assert value == int(single_dict_fields_values_expected[field]), f"For table {table_name} -> check for field: {field} ---> expected element: {int(single_dict_fields_values_expected[field])}, obtained: {value}"
                        else:    
                            assert int(value) == int(single_dict_fields_values_expected[field]), f"For table {table_name} -> check for field: {field} ---> expected element: {int(single_dict_fields_values_expected[field])}, obtained: {int(value)}"
                    else:
                        assert str(value) == str(single_dict_fields_values_expected[field]), f"For table {table_name} -> check for field: {field} ---> expected element: {str(single_dict_fields_values_expected[field])}, obtained: {str(value)}"
                    print(f"For table {table_name} -> check for field: {field} ---> expected element: {single_dict_fields_values_expected[field]}, obtained: {value} ---> OK!")

        adopted_db.closeConnection(conn)

    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print(f"----->>>> Assertion Error: {e}")
        # Interrompiamo il test
        raise AssertionError(str(e))
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print(f"----->>>> Exception: {e} for table: {table_name}")
        # Interrompiamo il test
        raise e



@step(u"checks the value {value} of the record at column {column} of the table {table_name} retrived by the query on db {db_name} with where datatable {type_table}")
def step_impl(context, value, column, table_name, db_name, type_table): 
    try:

        dbRun = getattr(context, "dbRun")
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        # Costruisce la query a partire dalla where
        selected_query = utils.generate_select(dict_fields_values)

        selected_query = selected_query.replace("columns", column).replace("table_name", table_name)
        selected_query = utils.replace_global_variables(selected_query, context)
        selected_query = utils.replace_local_variables(selected_query, context)
        selected_query = utils.replace_context_variables(selected_query, context)

        exec_query = adopted_db.executeQuery(context, conn, selected_query)

        query_result = [t[0] for t in exec_query]
        print('query_result: ', query_result)
       
        if value == 'None':
            print('Check value None')
            assert query_result[0] == None, f"assert result query with None for Failed!"
        elif value == 'NotNone':
            print('Check value NotNone')
            assert query_result[0] != None, f"assert result query with Not None Failed!"
        else:
            value = utils.replace_global_variables(value, context)
            value = utils.replace_local_variables(value, context)
            value = utils.replace_context_variables(value, context)
            split_value = [status.strip() for status in value.split(',')]
            for i, elem in enumerate(query_result):
                if isinstance(elem, str) and elem.isdigit():
                    query_result[i] = float(elem)
                elif isinstance(elem, datetime.date):
                    query_result[i] = elem.strftime('%Y-%m-%d')

            for i, elem in enumerate(split_value):
                if utils.isFloat(elem) or elem.isdigit():
                    split_value[i] = float(elem)

            print("value: ", split_value)
            for elem in split_value:
                assert elem in query_result, f"check expected element: {value}, obtained: {query_result}"

        adopted_db.closeConnection(conn)
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





@step(u"update for table {table_name} with parameter {param} on db {db_name} with where datatable {type_table}")
def step_impl(context, table_name, param, db_name, type_table): 
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        # Costruisce la query a partire dalla where
        upd_query = utils.generate_update(dict_fields_values)

        upd_query = upd_query.replace("table_name", table_name).replace("param", param)
        upd_query = utils.replace_global_variables(upd_query, context)
        upd_query = utils.replace_local_variables(upd_query, context)
        upd_query = utils.replace_context_variables(upd_query, context)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        # EXECUTE UPDATE WITH POLLING SET TO 60 SEC
        exec_query = utils.update_query(context, conn, adopted_db, upd_query)
            
        adopted_db.closeConnection(conn)

    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print(f"----->>>> Assertion Error: {e}")
        # Interrompiamo il test
        raise AssertionError(str(e))
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print(f"----->>>> Exception: {e}")
        # Interrompiamo il test
        raise e
    

@step(u"delete from table {table_name} the record on db {db_name} with datatable type {type_table}")
def step_impl(context, table_name, db_name, type_table): 
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        # Costruisce la query a partire dalla where
        del_query = utils.generate_delete(dict_fields_values)

        del_query = del_query.replace("table_name", table_name)
        del_query = utils.replace_global_variables(del_query, context)
        del_query = utils.replace_local_variables(del_query, context)
        del_query = utils.replace_context_variables(del_query, context)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        # EXECUTE DELETE WITH POLLING SET TO 60 SEC
        exec_query = utils.delete_query(context, conn, adopted_db, del_query)
            
        adopted_db.closeConnection(conn)

    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print(f"----->>>> Assertion Error: {e}")
        # Interrompiamo il test
        raise AssertionError(str(e))
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print(f"----->>>> Exception: {e}")
        # Interrompiamo il test
        raise e


@step(u"verify datetime plus number of date {number} of the record at column {column} of the table {table_name} retrived by the query on db {db_name} with where datatable {type_table}")
def step_impl(context, column, table_name, db_name, type_table, number):
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)
        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        # Costruisce la query a partire dalla where
        selected_query = utils.generate_select(dict_fields_values)

        selected_query = selected_query.replace("columns", column).replace("table_name", table_name)
        selected_query = utils.replace_global_variables(selected_query, context)
        selected_query = utils.replace_local_variables(selected_query, context)
        selected_query = utils.replace_context_variables(selected_query, context)

        if number == 'default_token_duration_validity_millis':
            default = int(getattr(context, 'default_token_duration_validity_millis')) / 60000
            value = (datetime.datetime.now().astimezone(pytz.timezone('Europe/Rome')) + datetime.timedelta(minutes=default)).strftime('%Y-%m-%d %H:%M')
        elif number == 'default_idempotency_key_validity_minutes':
            default = int(getattr(context, 'default_idempotency_key_validity_minutes'))
            value = (datetime.datetime.now().astimezone(pytz.timezone('Europe/Rome')) + datetime.timedelta(minutes=default)).strftime('%Y-%m-%d %H:%M')
        elif number == 'default_durata_estensione_token_IO':
            default = int(getattr(context, 'default_durata_estensione_token_IO')) / 60000
            value = (datetime.datetime.now().astimezone(pytz.timezone('Europe/Rome')) + datetime.timedelta(minutes=default)).strftime('%Y-%m-%d %H:%M')
        elif number == 'Today':
            value = (datetime.datetime.today()).strftime('%Y-%m-%d')
        elif 'minutes:' in number:
            min = int(number.split(':')[1]) / 60000
            value = (datetime.datetime.now().astimezone(pytz.timezone('Europe/Rome')) + datetime.timedelta(minutes=min)).strftime('%Y-%m-%d %H:%M')
        else:
            number = int(number)
            value = (datetime.datetime.now().astimezone(pytz.timezone('Europe/Rome')) + datetime.timedelta(days=number)).strftime('%Y-%m-%d')

        exec_query = adopted_db.executeQuery(context, conn, selected_query)

        query_result = [t[0] for t in exec_query]
        print('query_result: ', query_result)
        
        try:
            number = int(number)
            elem = query_result[0].strftime('%Y-%m-%d')
        except ValueError:
            elem = query_result[0].strftime('%Y-%m-%d %H:%M' if 'minutes:' in number or 'default_' in number else '%Y-%m-%d')

        adopted_db.closeConnection(conn)

        print(f"check expected element: {value}, obtained: {elem}")
        assert elem == value

    except AssertionError as e:
        print("----->>>> Assertion Error: ", e)
        raise AssertionError(str(e))
    except Exception as e:
        print("----->>>> Exception:", e)
        raise e








@step(u"verify {number:d} record for the table {table_name} retrived by the query on db {db_name} with where datatable {type_table}")
def step_impl(context, table_name, db_name, type_table, number):
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)
        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        # Costruisce la query a partire dalla where
        selected_query = utils.generate_select(dict_fields_values)

        selected_query = selected_query.replace("columns", '*').replace("table_name", table_name)
        selected_query = utils.replace_global_variables(selected_query, context)
        selected_query = utils.replace_local_variables(selected_query, context)
        selected_query = utils.replace_context_variables(selected_query, context)

        # EXECUTE QUERY WITH POLLING SET TO 60 SEC
        exec_query = utils.query_with_polling(context, conn, adopted_db, selected_query, number)

        print("record query result: ", exec_query)
        assert len(exec_query) == number, f"The number of query record is: {len(exec_query)}"
    
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




@step('from {value_obtained_with_path} {type_body} check value {value_expected} in position {n}')
def step_impl(context, value_obtained_with_path, type_body, value_expected, n):
    try:
        index_dot = value_obtained_with_path.find('.')
        tipo_evento = value_obtained_with_path[1:index_dot]

        list_tag = value_obtained_with_path.split('.')
        field_to_check = list_tag[len(list_tag)-1]

        value_obtained_with_path = utils.replace_local_variables_with_position(value_obtained_with_path, n, context, type_body)

        value_expected = utils.replace_local_variables(value_expected, context)
        value_expected = utils.replace_context_variables(value_expected, context)
        value_expected = utils.replace_global_variables(value_expected, context)

        if value_expected == 'None': 
            assert value_obtained_with_path == None, f"For tipo evento: {tipo_evento} assert result query with None for field: {field_to_check} Failed!"
            print(f"For tipo evento: {tipo_evento} -> check field: {field_to_check} -> value expected: {value_expected} is None")
        elif value_expected == 'NotNone':    
            assert value_obtained_with_path != None, f"For tipo evento: {tipo_evento} assert result query with Not None field: {field_to_check} Failed!"
            print(f"For tipo evento: {tipo_evento} -> check field: {field_to_check} -> value expected: {value_expected} is NotNone")
        elif value_expected == 'NotExists':
            assert value_obtained_with_path is None, f"Tag presente nel {list_tag}"
            print(f"For tipo evento: {tipo_evento} -> check field: {field_to_check} -> value expected: {value_expected} Not Exists")
        else:
            if utils.isFloat(value_expected):
                assert float(value_obtained_with_path) == float(value_expected), f"For tipo evento: {tipo_evento} for field: {field_to_check} -> value obtained: {float(value_obtained_with_path)} != value expected: {float(value_expected)}"
            elif utils.isNumeric(value_expected) and utils.isDecimal(value_expected):
                flag_int_cast_KO = False
                try:
                    int(value_obtained_with_path)
                except Exception as e:
                    flag_int_cast_KO = True

                if flag_int_cast_KO:
                    value_obtained_with_path = float(value_obtained_with_path)
                    value_obtained_with_path = int(value_obtained_with_path)
                    assert value_obtained_with_path == int(value_expected), f"For tipo evento: {tipo_evento} for field: {field_to_check} -> value obtained: {value_obtained_with_path} != value expected: {int(value_expected)}"
                else:                    
                    assert int(value_obtained_with_path) == int(value_expected), f"For tipo evento: {tipo_evento} for field: {field_to_check} -> value obtained: {int(value_obtained_with_path)} != value expected: {int(value_expected)}"
            else:
                assert str(value_obtained_with_path) == str(value_expected), f"For tipo evento: {tipo_evento} for field: {field_to_check} -> value obtained: {str(value_obtained_with_path)} != value expected: {str(value_expected)}"
            print(f"For tipo evento: {tipo_evento} -> check field: {field_to_check} -> value expected: {value_expected} is equal to value obtained: {value_obtained_with_path}")

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





@step('check value {value1} is {condition} value {value2}')
def step_impl(context, value1, condition, value2):
    try:
        value1 = utils.replace_local_variables(value1, context)
        value1 = utils.replace_context_variables(value1, context)
        value1 = utils.replace_global_variables(value1, context)
        value2 = utils.replace_local_variables(value2, context)
        value2 = utils.replace_context_variables(value2, context)
        value2 = utils.replace_global_variables(value2, context)

        if condition == 'equal to':
            assert value1 == value2, f"{value1} != {value2}"
        elif condition == 'greater than':
            assert value1 > value2, f"{value1} <= {value2}"
        elif condition == 'smaller than':
            assert value1 < value2, f"{value1} >= {value2}"
        elif condition == 'not equal to':
            assert value1 != value2, f"{value1} = {value2}"
        elif condition == 'containing':
            assert value2 in value1, f"{value1} contains {value2}"
        else:
            assert False
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



@step("calling primitive evolution {primitive1} and {primitive2} with {restType1} and {restType2} in parallel with {delay1:d} ms delay")
def step_impl(context, primitive1, primitive2, restType1, restType2, delay1):
    try:
        list_of_primitive = [primitive1, primitive2]
        list_of_type = [restType1, restType2]
        utils.threading_evolution(context, list_of_primitive, list_of_type, delay1)
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
    
@step("calling in parallel with update token {primitive1} and {primitive2} with {restType1} and {restType2} with {delay1:d} ms delay")
def step_impl(context, primitive1, primitive2, restType1, restType2, delay1):
    try:
        list_of_primitive = [primitive1, primitive2]
        list_of_type = [restType1, restType2]
        utils.threading_update(context, list_of_primitive, list_of_type, delay1)
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




@then("check primitive response {primitive1} and primitive response {primitive2}")
def step_impl(context, primitive1, primitive2):
    primitive1 = getattr(context, primitive1)
    primitive2 = getattr(context, primitive2)
    primitive1_content = primitive1.content
    primitive2_content = primitive2.content
    response_primitive1 = parseString(primitive1_content)
    print(response_primitive1)
    response_primitive2 = parseString(primitive2_content)
    print(response_primitive2)

    outcome1 = response_primitive1.getElementsByTagName('outcome')[0].firstChild.data if response_primitive1.getElementsByTagName('outcome') else response_primitive1.getElementsByTagName('esito')[0].firstChild.data
    print(outcome1)
    outcome2 = response_primitive2.getElementsByTagName('outcome')[0].firstChild.data if response_primitive2.getElementsByTagName('outcome') else response_primitive2.getElementsByTagName('esito')[0].firstChild.data
    print(outcome2)

    if outcome1 == 'KO':
        faultCode1 = response_primitive1.getElementsByTagName('faultCode')[
            0].firstChild.data
        faultString1 = response_primitive1.getElementsByTagName('faultString')[
            0].firstChild.data
        description1 = response_primitive1.getElementsByTagName('description')[
            0].firstChild.data
    if outcome2 == 'KO':
        faultCode2 = response_primitive2.getElementsByTagName('faultCode')[
            0].firstChild.data
        faultString2 = response_primitive2.getElementsByTagName('faultString')[
            0].firstChild.data
        description2 = response_primitive2.getElementsByTagName('description')[
            0].firstChild.data

    if outcome1 == 'OK' and outcome2 == 'OK':
        assert False, "outcome1: OK, outcome2: OK"

    if outcome1 == 'OK' and faultCode2 == 'PPT_PAGAMENTO_IN_CORSO' and faultString2 == 'Pagamento in attesa risulta in corso al sistema pagoPA' \
            and description2 == 'Pagamento in attesa risulta in corso al sistema pagoPA':
        assert True

    elif outcome2 == 'OK' and faultCode1 == 'PPT_PAGAMENTO_IN_CORSO' and faultString1 == 'Pagamento in attesa risulta in corso al sistema pagoPA' \
            and description1 == 'Pagamento in attesa risulta in corso al sistema pagoPA':
        assert True

    elif outcome1 == 'OK' and outcome2 == 'KO' and faultCode2 == 'PPT_ATTIVAZIONE_IN_CORSO':
        assert True
        
    elif outcome2 == 'OK' and outcome1 == 'KO' and faultCode1 == 'PPT_RPT_DUPLICATA':
        assert True
        
    elif outcome1 == 'OK' and outcome2 == 'KO' and faultCode2 == 'PPT_RPT_DUPLICATA':
        assert True

    # AccessiConcorrenziali 3a_ACT_SPO
    elif outcome1 == 'OK' and faultCode2 == 'PPT_SEMANTICA' and description2 == 'Activation pending on position':
        assert True
    # DoppiaACT_PA_NEW
    elif outcome2 == 'OK' and faultCode1 == 'PPT_SEMANTICA' and description1 == 'Activation pending on position':
        assert True
    # AccessiConcorrenziali 3a_ACT_SPO
    elif outcome1 == 'KO' and faultCode1 == 'PPT_TOKEN_SCADUTO' and outcome2 == 'KO' and faultCode2 == 'PPT_PAGAMENTO_DUPLICATO':
        assert True
    # AccessiConcorrenziali 3b_ACT_SPO
    elif outcome2 == 'KO' and faultCode2 == 'PPT_TOKEN_SCADUTO_KO' and outcome1 == 'OK':
        assert True
    # AccessiConcorrenziali 3c_ACT_SPO
    elif outcome1 == 'KO' and faultCode1 == 'PPT_PAGAMENTO_DUPLICATO' and outcome2 == 'KO' and faultCode2 == 'PPT_TOKEN_SCADUTO':
        assert True
    # AccessiConcorrenziali 3d_ACT_SPO
    elif outcome1 == 'OK' and outcome2 == 'KO' and faultCode2 == 'PPT_TOKEN_SCADUTO':
        assert True
    # AccessiConcorrenziali 3e_ACT_SPO
    elif outcome1 == 'KO' and outcome2 == 'KO' and faultCode2 == 'PPT_SEMANTICA' and description2 == 'Activation pending on position':
        assert True
    # AccessiConcorrenziali 3e_ACT_SPO
    elif outcome2 == 'KO' and outcome1 == 'KO' and faultCode1 == 'PPT_TOKEN_SCADUTO':
        assert True
    else:
        assert False


@step("through the query {query_name} convert json {json_elem} at position {position:d} to xml and save it under the key {key}")
def step_impl(context, query_name, json_elem, position, key):
    try:
        result_query = getattr(context, query_name)
        print(f'{query_name}: {result_query}')

        dbRun = getattr(context, "dbRun")
        selected_element = ''
        if dbRun == "Postgres":
            selected_element = result_query[0][position].tobytes().decode('utf-8')
        elif dbRun == "Oracle":
            selected_element = result_query[0][position]
            selected_element = selected_element.read()
            selected_element = selected_element.decode("utf-8")

        jsonDict = json.loads(selected_element)
        selected_element = utils.json2xml(jsonDict)
        selected_element = '<root>' + selected_element + '</root>'

        print(f'{json_elem}: {selected_element}')
        setattr(context, key, selected_element)

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


@step('checking value {value1} is {condition} value {value2}')
def step_impl(context, value1, condition, value2):
    try:
        value1 = utils.replace_local_variables(value1, context)
        value1 = utils.replace_context_variables(value1, context)
        value1 = utils.replace_global_variables(value1, context)
        value2 = utils.replace_local_variables(value2, context)
        value2 = utils.replace_context_variables(value2, context)
        value2 = utils.replace_global_variables(value2, context)

        value1 = str(value1)
        value1 = "".join(value1.split())
        value2 = str(value2)

        if condition == 'equal to':
            assert value1 == value2, f"{value1} != {value2}"
        elif condition == 'greater than':
            assert value1 > value2, f"{value1} <= {value2}"
        elif condition == 'smaller than':
            assert value1 < value2, f"{value1} >= {value2}"
        elif condition == 'containing':
            assert value2 in value1, f"{value1} contains {value2}"
        else:
            assert False

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




@step('retrieve session token from {url}')
def step_impl(context, url):
    try:
        print(f"url from response {url}: ")
        url = utils.replace_local_variables(url, context)
        print(url)
        print(f"#################### {url.split('idSession=')[1]}")
        setattr(context, f'sessionToken', url.split('idSession=')[1])
        
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


@step('retrieve session token {number:d} from {url}')
def step_impl(context, number, url):
    try:
        print(f"url from response {url}: ")
        url = utils.replace_local_variables(url, context)
        print(url)

        print(f"#################### {url.split('idSession=')[1]}")
        setattr(context, f'{number}sessionToken', url.split('idSession=')[1])

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




@step('replace {new_attribute} content with {old_attribute} content')
def step_impl(context, new_attribute, old_attribute):
    old_attribute = utils.replace_local_variables(old_attribute, context)
    old_attribute = utils.replace_context_variables(old_attribute, context)
    old_attribute = utils.replace_global_variables(old_attribute, context)
    setattr(context, new_attribute, old_attribute)





@step("retrieve record from {table_name} where columns {columns} on db {db_name} with where datatable {type_table} and save it under the key {key}")
def step_impl(context, table_name, columns, db_name, type_table, key):
    try:
        db_config = context.config.userdata.get("db_configuration")
        db_selected = db_config.get(db_name)
        
        assert context.table is not None, f"Datatable non inserita!!!"
        # Legge la datatable per le where conditions e la mette in una dict
        dict_fields_values = utils.table_to_dict(context.table, type_table)
        # Costruisce la query a partire dalla where
        selected_query = utils.generate_select(dict_fields_values)

        selected_query = selected_query.replace("columns", columns).replace("table_name", table_name)
        selected_query = utils.replace_global_variables(selected_query, context)
        selected_query = utils.replace_local_variables(selected_query, context)
        selected_query = utils.replace_context_variables(selected_query, context)

        adopted_db, conn = utils.get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

        # EXECUTE QUERY WITH POLLING SET TO 60 SEC
        exec_query = utils.query_with_polling(context, conn, adopted_db, selected_query, 1)
            
        assert exec_query is not None and len(exec_query) != 0, f"Result query empty or None for table: {table_name} !"
        # salvo il dato dentro la chiave
        setattr(context, key, exec_query[0][0])
        print(f'il valore estratto è --------> {key}: {exec_query[0][0]}')

        adopted_db.closeConnection(conn)

    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print(f"----->>>> Assertion Error: {e}")
        # Interrompiamo il test
        raise AssertionError(str(e))
    except Exception as e:
        # Gestione di tutte le altre eccezioni
        print(f"----->>>> Exception: {e}")
        # Interrompiamo il test
        raise e





@then(u'validating xml response {primitive_resp} by xsd {xsd}')
def step_impl(context, primitive_resp, xsd):
    try:
        xml_resp = getattr(context, primitive_resp)
        xml_document = parseString(xml_resp.content)
        xmlCatalogoServizi = xml_document.getElementsByTagName('xmlCatalogoServizi')[0].firstChild.data

        # Decode xml response
        decode_xml = b64.b64decode(xmlCatalogoServizi)

        xml_resp_decoded = decode_xml.decode('utf-8')

        # Read xsd file
        file_path = ''
        user_profile = None
        try:
            user_profile = getattr(context, "user_profile")
        except AttributeError as e:
            print(f"User Profile None: {e} ->>> remote run!")

        dbRun = getattr(context, "dbRun")

        if dbRun == "Postgres":
            ###RUN SI DA LOCALE CHE DAREMOTO
            file_path = f"src/integ-test/bdd-test/resources/xsd/{xsd}.xsd"
        elif dbRun == "Oracle":       
            ####RUN DA LOCALE
            if user_profile != None:
                # Specifica il percorso del tuo file XSD da locale
                file_path = f"src/integ-test/bdd-test/resources/xsd/{xsd}.xsd"
            ###RUN DA REMOTO
            else:      
                current_directory = os.getcwd()
                
                substring_current_directory = ""
                
                substring_current_directory = current_directory[:-2]

                print("La directory corrente è:", current_directory)

                file_path = f"{substring_current_directory}/nodo/extracted/src/integ-test/bdd-test/resources/xsd/{xsd}.xsd"             
                
                print("Il file path corrente è:", file_path)

        # Carica lo schema XSD
        with open(file_path, 'r') as schema_file:
            schema_root = etree.parse(schema_file)
            schema = etree.XMLSchema(schema_root)

        # Carica l'XML da validare
        xml_doc = etree.fromstring(xml_resp_decoded.split('?>', 1)[-1])

        validate = schema.validate(xml_doc)
        assert validate == True, f"{', '.join([f'Errore di validazione: {error.message}, Riga: {error.line}, Colonna: {error.column}' for error in schema.error_log])}"

        print(f"Validazione xml {xml_doc} OK!")

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