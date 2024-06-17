import re
import json
import os
import datetime
from webbrowser import get
from xml.dom.minidom import parseString
import random
import string

from behave.__main__ import main as behave_main
import time
from threading import Thread
import requests
from requests.adapters import HTTPAdapter
import xmltodict

from urllib.parse import urlparse
from behave.model import Table, Row

import string


try:
    import cx_Oracle
except ModuleNotFoundError:
    print(">>>>>>>>>>>>>>>>>No import CX_ORACLE for Postgres pipeline")

# Decommentare per test in pipeline
#from requests.packages.urllib3.util.retry import Retry 

# Commentare per test in pipeline
from urllib3.util.retry import Retry

import xml.etree.ElementTree as ET


SUBKEY = "2da21a24a3474673ad8464edb4a71011"

def random_s():
    import random
    cont = 5
    strNumRand = ''
    while cont != 0:
        strNumRand += str(random.randint(0, 9))
        cont -= 1
    return strNumRand

def genera_stringa():
    lunghezza = random.randint(2, 18)
    caratteri = string.ascii_letters + string.digits
    return ''.join(random.choice(caratteri) for _ in range(lunghezza))


def compare_lists(lista_api, lista_query):

    set_api = set(lista_api)
    print(set_api)
    set_query = set(lista_query)
    print(set_query)

    return set_api == set_query


def current_milli_time():
    return round(time.time() * 1000)


def requests_retry_session(
        retries=3,
        backoff_factor=0.3,
        status_forcelist=(500, 502, 504),
    session=None,
):
    session = session or requests.Session()
    retry = Retry(
        total=retries,
        read=retries,
        connect=retries,
        backoff_factor=backoff_factor,
        status_forcelist=status_forcelist,
    )
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('http://', adapter)
    session.mount('https://', adapter)
    return session


def get_soap_url_nodo(context, primitive=-1):
    primitive_mapping = {
        "verificaBollettino": "/node-for-psp/v1",
        "verifyPaymentNotice": "/node-for-psp/v1",
        "activatePaymentNotice": "/node-for-psp/v1",
        "activatePaymentNoticeV2": "/node-for-psp/v1",
        "sendPaymentOutcome": "/node-for-psp/v1",
        "sendPaymentOutcomeV2": "/node-for-psp/v1",
        "activateIOPayment": "/node-for-io/v1",
        "nodoVerificaRPT": "/nodo-per-psp/v1",
        "nodoAttivaRPT": "/nodo-per-psp/v1",
        "nodoInviaFlussoRendicontazione": "/nodo-per-psp/v1",
        # "pspNotifyPayment": "/psp-for-node/v1",
        "nodoChiediElencoFlussiRendicontazione": "/nodo-per-pa/v1",
        "nodoChiediFlussoRendicontazione": "/nodo-per-pa/v1",
        "demandPaymentNotice": "/node-for-psp/v1",
        "nodoChiediCatalogoServizi": "/nodo-per-psp-richiesta-avvisi/v1",
        "nodoChiediCatalogoServiziV2": "/node-for-psp/v1",
        "nodoChiediCopiaRT": "/nodo-per-pa/v1",
        "nodoChiediInformativaPA": "/nodo-per-psp/v1",
        "nodoChiediListaPendentiRPT": "/nodo-per-pa/v1",
        "nodoChiediNumeroAvviso": "/nodo-per-psp-richiesta-avvisi/v1",
        "nodoChiediStatoRPT": "/nodo-per-pa/v1",
        "nodoChiediTemplateInformativaPSP": "/nodo-per-psp/v1",
        "nodoInviaCarrelloRPT": "/nodo-per-pa/v1",
        "nodoInviaRPT": "/nodo-per-pa/v1",
        "nodoInviaRT": "/nodo-per-psp/v1",
        "nodoPAChiediInformativaPA": "/nodo-per-pa/v1",
        "nodoChiediElencoQuadraturePSP": "/nodo-per-psp/v1",
        "nodoChiediInformativaPSP": "/nodo-per-pa/v1",
        "nodoChiediElencoQuadraturePA": "/nodo-per-pa/v1",
        "nodoChiediQuadraturaPA": "/nodo-per-pa/v1"
        #"nodoChiediSceltaWISP":"//v1"
    }
    if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("soap_service").strip() == "":
        return context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") + primitive_mapping.get(primitive)
    else:
        return  context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") \
            + context.config.userdata.get("services").get(
                "nodo-dei-pagamenti").get("soap_service")

        
def get_rest_url_nodo(context, primitive):
    primitive_mapping = { 
        "avanzamentoPagamento": "/nodo-per-pm/v1",
        "checkPosition": "/nodo-per-pm/v1",
        "informazioniPagamento": "/nodo-per-pm/v1",
        "inoltroEsito/carta": "/nodo-per-pm/v1",
        "inoltroEsito/mod1": "/nodo-per-pm/v1",
        "inoltroEsito/mod2": "/nodo-per-pm/v1",
        "inoltroEsito/paypal": "/nodo-per-pm/v1",
        "listaPSP": "/nodo-per-pm/v1",
        "notificaAnnullamento": "/nodo-per-pm/v1",
        "v1/closepayment": "/nodo-per-pm",
        "v2/closepayment": "/nodo-per-pm",
        "v1/parkedList": "/nodo-per-pm"
    }     
    if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service") == "":
        if "avanzamentoPagamento" in primitive:
            primitive = "avanzamentoPagamento"
        elif "informazioniPagamento" in primitive:
            primitive = "informazioniPagamento"
        elif "listaPSP" in primitive:
            primitive = "listaPSP"
        elif "notificaAnnullamento" in primitive:
            primitive = "notificaAnnullamento"
        elif "v1/parkedList" in primitive:
            primitive = "v1/parkedList"
        elif "_json" in primitive:
            primitive = primitive.split('_')[0]
        if "v2/closepayment" in primitive:
            primitive = "v2/closepayment"
        return context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") + primitive_mapping.get(primitive)
    else:
        return context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") + "/" + primitive


def get_soap_mock_ec(context):
    if context.config.userdata.get('services').get('mock-ec').get('soap_service') is not None:
        return context.config.userdata.get('services').get('mock-ec').get('url') \
            + context.config.userdata.get('services').get('mock-ec').get('soap_service')
    else:
        return ""


def get_soap_mock_ec2(context):
    if context.config.userdata.get('services').get('secondary-mock-ec').get('soap_service') is not None:
        return context.config.userdata.get('services').get('secondary-mock-ec').get('url') \
            + context.config.userdata.get('services').get(
                'secondary-mock-ec').get('soap_service')
    else:
        return ""


def get_soap_mock_psp(context):
    if context.config.userdata.get('services').get('mock-psp').get('soap_service') is not None:
        return context.config.userdata.get('services').get('mock-psp').get('url') \
            + context.config.userdata.get('services').get('mock-psp').get('soap_service')
    else:
        return ""


def get_soap_mock_psp2(context):
    if context.config.userdata.get('services').get('secondary-mock-psp').get('soap_service') is not None:
        return context.config.userdata.get('services').get('secondary-mock-psp').get('url') \
            + context.config.userdata.get('services').get(
                'secondary-mock-psp').get('soap_service')
    else:
        return ""


def get_refresh_config_url(context):
    if context.config.userdata.get('services').get('nodo-dei-pagamenti').get('refresh_config_service') is not None:
        return context.config.userdata.get('services').get('nodo-dei-pagamenti').get('refresh_config_service')
    else:
        return ""
    
def get_forcing_refresh_config_url(context):
    if context.config.userdata.get('services').get('nodo-dei-pagamenti').get('forcing_refresh_config_service') is not None:
        return context.config.userdata.get('services').get('nodo-dei-pagamenti').get('forcing_refresh_config_service')
    else:
        return ""


def get_rest_mock_ec(context):
    if context.config.userdata.get("services").get("mock-ec").get("rest_service") is not None:
        return context.config.userdata.get("services").get("mock-ec").get("url") \
            + context.config.userdata.get("services").get("mock-ec").get("rest_service")
    else:
        return ""


def get_rest_mock_psp(context):
    if context.config.userdata.get("services").get("mock-psp").get("rest_service") is not None:
        return context.config.userdata.get("services").get("mock-psp").get("url") \
            + context.config.userdata.get("services").get("mock-psp").get("rest_service")
    else:
        return ""


def save_soap_action(context, mock, primitive, soap_action, override=False):
    # set what your server accepts
    dbRun = getattr(context, "dbRun")
    headers = {'Content-Type': 'application/xml'}
    print(f'{mock}/response/{primitive}?override={override}')

    response = None
    if dbRun == "Postgres":
        response = requests.post(f"{mock}/response/{primitive}?override={override}", soap_action, headers=headers, verify=False, proxies = getattr(context,'proxies'))
    elif dbRun == "Oracle":
        response = requests.post(f"{mock}/response/{primitive}?override={override}", soap_action, headers=headers, verify=False)
    print(response.content, response.status_code)
    return response.status_code


def manipulate_soap_action(soap_action, elem, value):
    TYPE_ELEMENT = 1  # dom element
    # TYPE_VALUE = 3 # dom value
    my_document = parseString(soap_action)
    if value == "None":
        element = my_document.getElementsByTagName(elem)[0]
        element.parentNode.removeChild(element)
    elif value == "Empty":
        element = my_document.getElementsByTagName(elem)[0].childNodes[0]
        element.nodeValue = ''
        childs = my_document.getElementsByTagName(elem)[0].childNodes
        for child in childs:
            if child.nodeType == TYPE_ELEMENT:
                child.parentNode.removeChild(child)
    elif value == 'RemoveParent':
        element = my_document.getElementsByTagName(elem)[0]
        parent = element.parentNode
        children = element.childNodes
        parent.removeChild(element)
        for child in list(children):
            if child.nodeType == TYPE_ELEMENT:
                parent.appendChild(child)
    elif str(value).startswith("Occurrences"):
        occurrences = int(value.split(",")[1])
        original_node = my_document.getElementsByTagName(elem)[0]
        cloned_node = original_node.cloneNode(2)
        for i in range(0, occurrences - 1):
            original_node.parentNode.insertBefore(cloned_node, original_node)
            original_node = cloned_node
            cloned_node = original_node.cloneNode(2)
    else:
        node = my_document.getElementsByTagName(elem)[0] if my_document.getElementsByTagName(elem) else None

        if node is None:
            # create
            element = my_document.createTextNode(value)
            my_document.getElementsByTagName(elem)[0].appendChild(element)
        elif len(node.childNodes) > 1:
            # replace object
            object = parseString(value)
            node.parentNode.replaceChild(object.childNodes[0], node)
        else:
            # leaf -> single value
            while node.hasChildNodes():
                node.removeChild(node.firstChild)
            element = my_document.createTextNode(value)
            node.appendChild(element)

    return my_document.toxml()


def replace_context_variables_for_query(body, context):
    pattern = re.compile('\\s\\$\\w+(?![.\\w])')
    match = pattern.findall(body)

    if len(match) > 0:
        ###CALCULATE THE INITIAL INDEX VALUE FROM MY QUERY
        initial_indexes = [i for i, x in enumerate(body) if x == "$"]
        j = 0
        dict_values = {}
        new_indexes = initial_indexes

        for field in match:
            if j > 0:
                new_indexes = []
                ###RICALCULATE INDEX VALUE AFTER REPLAE $$
                indexes = [i for i, x in enumerate(body) if x == "$"]
                new_indexes = indexes[(4*j):]

            dict_values.update({field.replace('$', '').strip() : new_indexes[0]})
            saved_elem = getattr(context, field.replace('$', '').strip())
            value = str(saved_elem)
            
            index_my_interest = dict_values[field.replace('$', '').strip()]-1
            
            if body[index_my_interest] == " ":
                body = replace_specific_string(body, field, f'$${value}$$')
            else:
                body = replace_specific_string(body, field, value)
            j+=1
            print(f'Query in costruzione: step {j} per la query{body}')
    return body


def manipulate_json(data, key, value):
    json_temp = ""
    if value == "None":
        if key in data:
            del data[key]
    elif value == "Empty":
        json_temp = json.loads(data)
        if key in data and isinstance(json_temp.get(key), list):
            json_temp[key] = []
        elif key in data and isinstance(json_temp.get(key), dict):
            json_temp[key] = {}
        elif key in data:
            data[key] = ""
    elif value == 'RemoveParent':
        parent_key = key.rsplit('.', 1)[0]
        if parent_key in data and isinstance(data[parent_key], dict):
            if key in data[parent_key]:
                data[parent_key][key] = data[key]
            del data[key]
    elif value.startswith("Occurrences"):
        occurrences = int(value.split(",")[1])
        if key in data and isinstance(data[key], list):
            data[key] = data[key] * occurrences
    else:
        if key in data:
            json_temp = json.loads(data)
            json_temp[key] = value
    return json.dumps(json_temp)


def replace_context_variables(body, context):
    pattern = re.compile('\\$(?<!\\$\\$)\\b(\\w+)')
    #pattern = re.compile('\\$\\w+')
    match = pattern.findall(body)

    if len(match) > 0:
        # aggiunge ai valori della lista match il simbolo $ all'inizio
        for i in range(len(match)):
            match[i] = f"${match[i]}"

        for field in match:
            saved_elem = getattr(context, field.replace('$', ''))
            value = str(saved_elem)
            body = body.replace(field, value)
    return body



def replace_local_variables_for_query(body, context):
    pattern = re.compile('\\$\\w+\\.\\w+(?:-\\w+)?')
    match = pattern.findall(body)

    for field in match:
        saved_elem = getattr(context, field.replace('$', '').split('.')[0])
        value = saved_elem
        tag_finale = ''
        if len(field.replace('$', '').split('.')) > 1:
            tag = field.replace('$', '').split('.')[1]
            if isinstance(saved_elem, str):
                document = parseString(saved_elem)
            else:
                document = parseString(saved_elem.content)
                print(tag)
            try:
                if '-' in tag:
                    tag_finale = tag.split('-')[1]
                    value = document.getElementsByTagNameNS('*', tag.split('-')[0])[0].firstChild.data
                else:
                    value = document.getElementsByTagNameNS('*', tag)[0].firstChild.data
            except Exception as e:
                raise Exception(f"Errore nel metodo replace_local_variables_for_query: il Tag '{tag}' non esiste nel contesto") from e
        if len(tag_finale) > 1:
            body = body.replace(field, f'$${value}-{tag_finale}$$')
        else:
            body = body.replace(field, f'$${value}$$')
    return body


#### position deve essere l'occorrenza (prima seconda terza...) del tag che si vuole controllare
def replace_local_variables_with_position(body, position, context, type_body):
    list_tag = body.split(".")
    size_list = len(list_tag)

    string_pattern = ''

    for i in range(0, size_list):
        if i == 0:
            string_pattern = '\\$\\w+\\'
        else:
            string_pattern += '.\\w+'

    dbRun = getattr(context, "dbRun")
    pattern = re.compile(string_pattern)
    match = pattern.findall(body)
    for field in match:
        saved_elem = getattr(context, field.replace('$', '').split('.')[0])
        value = saved_elem
        if len(field.replace('$', '').split('.')) > 1:
            tag = field.replace('$', '').split('.')[size_list-1]
            if dbRun == "Postgres":
                if isinstance(saved_elem, str):
                    modify_xmlns = False
                    try:
                        document = parseString(saved_elem)
                    except Exception as e:
                        modify_xmlns = True

                    if modify_xmlns:
                        saved_elem = saved_elem.replace('psp','pfn')
                        document = parseString(saved_elem)
                else:
                    if type_body == 'xml':
                        document = parseString(saved_elem.content)
                    elif type_body == 'json':
                        jsonDict = json.loads(saved_elem[0][0].tobytes().decode('utf-8'))
                        payload = json2xml(jsonDict)
                        payload = '<root>' + payload + '</root>'
                        payload = payload.replace('\n','').replace('\t','')
                        document = parseString(payload)
            elif dbRun == "Oracle":
                if isinstance(saved_elem, str):
                    modify_xmlns = False
                    try:
                        document = parseString(saved_elem)
                    except Exception as e:
                        modify_xmlns = True

                    if modify_xmlns:
                        saved_elem = saved_elem.replace('psp','pfn')
                        document = parseString(saved_elem)
                elif isinstance(saved_elem, cx_Oracle.LOB):
                    document = parseString(saved_elem.read())
                else:
                    if type_body == 'xml':
                        document = parseString(saved_elem.content)
                    elif type_body == 'json':
                        selected_element = saved_elem[0][0]
                        selected_element = selected_element.read()
                        selected_element = selected_element.decode("utf-8")
                        jsonDict = json.loads(selected_element)
                        payload = json2xml(jsonDict)
                        payload = '<root>' + payload + '</root>'
                        payload = payload.replace('\n','').replace('\t','')
                        document = parseString(payload)
            try:
                value = document.getElementsByTagNameNS('*', tag)[int(position)].firstChild.data
            except Exception as e:
                raise Exception(f"Errore nel metodo replace_local_variables: il Tag '{tag}' non esiste nel contesto") from e
        body = body.replace(field, value)
    return body



def replace_local_variables(body, context):
    dbRun = getattr(context, "dbRun")
    pattern = re.compile('\\$\\w+\\.\\w+')
    match = pattern.findall(body)
    for field in match:
        saved_elem = getattr(context, field.replace('$', '').split('.')[0])
        value = saved_elem
        if len(field.replace('$', '').split('.')) > 1:
            tag = field.replace('$', '').split('.')[1]
            if dbRun == "Postgres":
                if isinstance(saved_elem, str):
                    document = parseString(saved_elem)
                else:
                    document = parseString(saved_elem.content)
            elif dbRun == "Oracle":
                if isinstance(saved_elem, str):
                    document = parseString(saved_elem)  
                elif isinstance(saved_elem, cx_Oracle.LOB):
                    document = parseString(saved_elem.read())
                else:
                    document = parseString(saved_elem.content)
            try:
                value = document.getElementsByTagNameNS('*', tag)[0].firstChild.data
            except Exception as e:
                raise Exception(f"Errore nel metodo replace_local_variables: il Tag '{tag}' non esiste nel contesto") from e
        body = body.replace(field, value)
    return body
    



def replace_global_variables(payload, context):
    pattern = re.compile('#\\w+#')
    match = pattern.findall(payload)
    for elem in match:
        replaced_sharp = elem.replace("#", "")
        if replaced_sharp in context.config.userdata.get("global_configuration"):
            payload = payload.replace(elem, context.config.userdata.get(
                "global_configuration").get(replaced_sharp))
    return payload


def get_history(context, rest_mock, notice_number, primitive):
    s = requests.Session()
    response = requests_retry_session(session=s).get(
        f"{rest_mock}/history/{notice_number}/{primitive}", proxies = getattr(context,'proxies'))
    return response.json(), response.status_code


def query_json(context, name_query, name_macro):
    dbRun = getattr(context, "dbRun")
    query = ''
    if dbRun == "Postgres":
        query = json.load(open(os.path.join(context.config.base_dir + "/../resources/query_AutomationTest_postgres.json")))
    elif dbRun == "Oracle":
        query = json.load(open(os.path.join(context.config.base_dir + "/../resources/query_AutomationTest_oracle.json")))
    selected_query = query.get(name_macro).get(name_query)
    if '$' in selected_query:
        if dbRun == "Postgres":
            selected_query = replace_local_variables_for_query(selected_query, context)
            selected_query = replace_context_variables_for_query(selected_query, context)
        elif dbRun == "Oracle":
            selected_query = replace_local_variables(selected_query, context)
            selected_query = replace_context_variables(selected_query, context)
        selected_query = replace_global_variables(selected_query, context)
    return selected_query

def isFloat(string: str) -> bool:
    value = string.split('.')
    return len(value) == 2 and value[0].isdigit() and value[1].isdigit()

def isNumeric(string: str) -> bool:
    return string.isnumeric()

def isDecimal(string: str) -> bool:
    return string.isdecimal()



def isDate(string: str):
    try:
        return string == datetime.datetime.strptime(string, '%Y-%m-%d')
    except ValueError:
        return False
    



def single_thread_evolution(context, primitive, tipo, all_primitive_in_parallel):
    print("single_thread_evolution")

    dbRun = getattr(context, "dbRun")

    db_online = ''
    db_offline = ''
    db_re = ''
    db_wfesp = ''

    import base64 as b64
    import db_operation_postgres
    import db_operation_oracle
    import db_operation_apicfg_testing_support as db

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

    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get("nodo_online")   

    print(f"primitives to launch in parallel: {primitive} with type: {tipo}")

    i = 0
    payment_token = ''
    payload_support = ''

    if 'nodoInviaRPT' in primitive:
        if '_' in primitive:
            primitive_full = primitive
            primitive = primitive.split('_')[0]
            payload_support = primitive_full.split('_')[1]
            payload_support = replace_context_variables(payload_support, context)

            ### RECUPERO IL TOKEN DAL DB DALLA TABLE RPT_ACTIVATIONS
            notice_number = ''
            fiscal_code = ''

            for single_primitive_in_parallel in all_primitive_in_parallel:
                if 'activatePaymentNotice' in single_primitive_in_parallel:
                    notice_number = f"${single_primitive_in_parallel}.noticeNumber"
                    fiscal_code = f"${single_primitive_in_parallel}.fiscalCode"
                    break

            notice_number = replace_local_variables(notice_number, context)
            fiscal_code = replace_local_variables(fiscal_code, context)

            select_get_token = f"SELECT PAYMENT_TOKEN FROM RPT_ACTIVATIONS WHERE NOTICE_ID = '{notice_number}' AND PA_FISCAL_CODE = '{fiscal_code}'"

            db_name = 'nodo_online'

            adopted_db, conn = get_db_connection(db_name, db, db_online, db_offline, db_re, db_wfesp, db_selected)

            exec_query = adopted_db.executeQuery(conn, select_get_token)
            assert exec_query != None and len(exec_query) != 0, f"Result query empty or None for table: RPT_ACTIVATIONS !"

            payment_token = exec_query[0][0]
            ### REPLACE DEL TOKEN RECUPERATO DENTRO RPT GENERATA
            payload_support = payload_support.replace('paymentToken', payment_token)

            payload_b = bytes(payload_support, 'UTF-8')
            payload_uni = b64.b64encode(payload_b)
            payload = f"{payload_uni}".split("'")[1]

            setattr(context, 'rptAttachment', payload)
    ###LANCIO DELLE PRIMITIVE
    ###LANCIO GET
    if tipo == 'GET':
        if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service") == "":
            url_nodo = f"{get_rest_url_nodo(context, primitive)}/{primitive}"
        else:
            url_nodo = get_rest_url_nodo(context, primitive)
        print(f"url: {url_nodo}")

        header_host = estrapola_header_host(url_nodo)
        headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'Host': header_host, 'Ocp-Apim-Subscription-Key': SUBKEY}
        
        get_response = ''
        if dbRun == "Postgres":
            get_response = requests.get(url_nodo, headers=headers, verify=False, proxies = getattr(context,'proxies'))
        elif dbRun == "Oracle":
            get_response = requests.get(url_nodo, headers=headers, verify=False)

        setattr(context, primitive + "Response", get_response)
        
        print("get response: ", get_response.content)
        print(primitive + "Response")
    ###LANCIO POST
    elif tipo == 'POST':
        body = ''
        if 'nodoInviaRPT' in primitive:
            body = getattr(context, primitive)
            body = body.replace('rptAttachment',getattr(context, 'rptAttachment')).replace('paymentToken',payment_token)
        else:    
            body = getattr(context, primitive)
        
        response = ''
        url_nodo = ''

        if 'xml' in getattr(context, primitive):
            url_nodo = get_soap_url_nodo(context, primitive)
            print(f"url: {url_nodo}")

            header_host = estrapola_header_host(url_nodo)
            headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'Host': header_host, 'Ocp-Apim-Subscription-Key': SUBKEY}
            print(f"primitive: {primitive} ---> body: {body}")

            if dbRun == "Postgres":
                response = requests.post(url_nodo, body, headers=headers, verify=False, proxies = getattr(context,'proxies'))
            elif dbRun == 'Oracle':
                response = requests.post(url_nodo, body, headers=headers, verify=False)
        else:
            if '<' in body: 
                body = xmltodict.parse(body)
                body = body["root"]
                if body != None:
                    if ('paymentTokens' in body.keys()) and (body["paymentTokens"] != None and (type(body["paymentTokens"]) != str)):
                        body["paymentTokens"] = body["paymentTokens"]["paymentToken"]
                        if type(body["paymentTokens"]) != list:
                            l = list()
                            l.append(body["paymentTokens"])
                            body["paymentTokens"] = l
                    if ('totalAmount' in body.keys()) and (body["totalAmount"] != None):
                        body["totalAmount"] = float(body["totalAmount"])
                    if ('fee' in body.keys()) and (body["fee"] != None):
                        body["fee"] = float(body["fee"])
                    if ('importoTotalePagato' in body.keys()) and (body["importoTotalePagato"] != None):
                        body["importoTotalePagato"] = float(body["importoTotalePagato"])
                    if ('RRN' in body.keys()) and (body["RRN"] != None):
                        body["RRN"] = float(body["RRN"])
                    if ('primaryCiIncurredFee' in body.keys()) and (body["primaryCiIncurredFee"] != None):
                        body["primaryCiIncurredFee"] = float(body["primaryCiIncurredFee"])
                    if ('positionslist' in body.keys()) and (body["positionslist"] != None):
                        body["positionslist"] = body["positionslist"]["position"]
                        if type(body["positionslist"]) != list:
                            l = list()
                            l.append(body["positionslist"])
                            body["positionslist"] = l
                    body = json.dumps(body, indent=4)
                    print(f"body: {body}")

            if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service") == "":
                url_nodo = f"{get_rest_url_nodo(context, primitive)}/{primitive}"
            else:    
                url_nodo = get_rest_url_nodo(context, primitive)

            print(f"url: {url_nodo}")

            header_host = estrapola_header_host(url_nodo)
            headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'Host': header_host, 'Ocp-Apim-Subscription-Key': SUBKEY} 

            if dbRun == "Postgres":
                response = requests.post(url_nodo, body, headers=headers, verify=False, proxies = getattr(context,'proxies'))
            elif dbRun == 'Oracle':
                response = requests.post(url_nodo, body, headers=headers, verify=False)            
            
        setattr(context, primitive + "Response", response)
        print("response: ", response.content)
        print(primitive + "Response")
     






def single_thread(context, soap_primitive, tipo):
    print("single_thread")
    dbRun = getattr(context, "dbRun")
    primitive = soap_primitive.split("_")[0]
    primitive = replace_local_variables(primitive, context)
    primitive = replace_context_variables(primitive, context)
    primitive = replace_global_variables(primitive, context)
    print(f"primitive: {primitive}")
    if tipo == 'GET':
        if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service") == "":
            url_nodo = f"{get_rest_url_nodo(context, primitive)}/{primitive}"
        else:
            url_nodo = get_rest_url_nodo(context, primitive)
        print(f"url: {url_nodo}")

        header_host = estrapola_header_host(url_nodo)
        headers = {'X-Forwarded-For': '10.82.39.148', 'Host': header_host}

        if 'SUBSCRIPTION_KEY' in os.environ:
            headers = {'Ocp-Apim-Subscription-Key', os.getenv('SUBSCRIPTION_KEY') }
        
        soap_response = ''
        if dbRun == "Postgres":
            soap_response = requests.get(url_nodo, headers=headers, verify=False, proxies = getattr(context,'proxies'))
        elif dbRun == "Oracle":
            soap_response = requests.get(url_nodo, headers=headers, verify=False)
        print("response: ", soap_response.content)

        print(soap_primitive.split("_")[1] + "Response")
        setattr(context, soap_primitive.split("_")[1] + "Response", soap_response)
    elif tipo == 'POST':
        body = getattr(context, primitive)
        print(body)

        response = ''
        url_nodo = ''

        if 'xml' in getattr(context, primitive):
            url_nodo = get_soap_url_nodo(context, primitive)
            print(f"url: {url_nodo}")

            # headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'X-Forwarded-For': '10.82.39.148', 'Host': 'api.dev.platform.pagopa.it:443'}
            header_host = estrapola_header_host(url_nodo)
            headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'Host': header_host}

            if 'SUBSCRIPTION_KEY' in os.environ:
                headers['Ocp-Apim-Subscription-Key'] = os.getenv('SUBSCRIPTION_KEY')

            response = ''
            if dbRun == "Postgres":
                response = requests.post(url_nodo, body, headers=headers, verify=False, proxies = getattr(context,'proxies'))
            elif dbRun == 'Oracle':
                response = requests.post(url_nodo, body, headers=headers, verify=False)
        else:
            url_nodo = f"{get_rest_url_nodo(context, primitive)}"
            print(f"url: {url_nodo}")

            header_host = estrapola_header_host(url_nodo)
            headers = {'Content-Type': 'application/json', 'Host': header_host}
            # headers = {'Content-Type': 'application/json', 'X-Forwarded-For': '10.82.39.148', 'Host': 'api.dev.platform.pagopa.it:443'}

            if 'SUBSCRIPTION_KEY' in os.environ:
                headers['Ocp-Apim-Subscription-Key'] = os.getenv('SUBSCRIPTION_KEY')  

            if '<' in body: 
                body = xmltodict.parse(body)
                body = body["root"]
                if body != None:
                    if ('paymentTokens' in body.keys()) and (body["paymentTokens"] != None and (type(body["paymentTokens"]) != str)):
                        body["paymentTokens"] = body["paymentTokens"]["paymentToken"]
                        if type(body["paymentTokens"]) != list:
                            l = list()
                            l.append(body["paymentTokens"])
                            body["paymentTokens"] = l
                    if ('totalAmount' in body.keys()) and (body["totalAmount"] != None):
                        body["totalAmount"] = float(body["totalAmount"])
                    if ('fee' in body.keys()) and (body["fee"] != None):
                        body["fee"] = float(body["fee"])
                    if ('importoTotalePagato' in body.keys()) and (body["importoTotalePagato"] != None):
                        body["importoTotalePagato"] = float(body["importoTotalePagato"])
                    if ('RRN' in body.keys()) and (body["RRN"] != None):
                        body["RRN"] = float(body["RRN"])
                    if ('primaryCiIncurredFee' in body.keys()) and (body["primaryCiIncurredFee"] != None):
                        body["primaryCiIncurredFee"] = float(body["primaryCiIncurredFee"])
                    if ('positionslist' in body.keys()) and (body["positionslist"] != None):
                        body["positionslist"] = body["positionslist"]["position"]
                        if type(body["positionslist"]) != list:
                            l = list()
                            l.append(body["positionslist"])
                            body["positionslist"] = l
                    body = json.dumps(body, indent=4)
                    print(f"body: {body}")

            if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service") == "":
                url_nodo = f"{get_rest_url_nodo(context, primitive)}/{primitive}"
            else:    
                url_nodo = get_rest_url_nodo(context, primitive)

            response = ''
            print(f"url: {url_nodo}")
            if dbRun == "Postgres":
                response = requests.post(url_nodo, body, headers=headers, verify=False, proxies = getattr(context,'proxies'))
            elif dbRun == 'Oracle':
                response = requests.post(url_nodo, body, headers=headers, verify=False)            
            
        setattr(context, soap_primitive.split("_")[1] + "Response", response)
        print("response: ", response.content)
        print(soap_primitive.split("_")[1] + "Response")



def threading_evolution(context, primitive_list, list_of_type, delay):
    i = 0

    threads = list()
    all_primitive_in_parallel = primitive_list
    
    while i < len(primitive_list):
        t = Thread(target=single_thread_evolution, args=(context, primitive_list[i], list_of_type[i], all_primitive_in_parallel))
        threads.append(t)
        time.sleep(delay/1000)
        # Avvia il thread
        t.start()
        i += 1

    for thread in threads:
        # Attende che il thread completi l'esecuzione
        thread.join()
        
    print('Thread completed!')
    

def threading(context, primitive_list, list_of_type):
    i = 0
    threads = list()
    while i < len(primitive_list):
        t = Thread(target=single_thread, args=(context, primitive_list[i], list_of_type[i]))
        threads.append(t)
        t.start()
        i += 1

    for thread in threads:
        thread.join()


def threading_delayed(context, primitive_list, list_of_delays, list_of_type):
    i = 0
    threads = list()
    while i < len(primitive_list):
        t = Thread(target=single_thread, args=(context, primitive_list[i], list_of_type[i]))
        threads.append(t)
        time.sleep(list_of_delays[i]/1000)
        t.start()
        i += 1

    for thread in threads:
        thread.join()


def json2xml(json_obj, line_padding=""):
    result_list = list()
    json_obj_type = type(json_obj)
    if json_obj_type is list:
        for sub_elem in json_obj:
            result_list.append(json2xml(sub_elem, line_padding))
        return "\n".join(result_list)
    if json_obj_type is dict:
        for tag_name in json_obj:
            sub_obj = json_obj[tag_name]
            if type(sub_obj) is dict:
                result_list.append("%s<%s>" % (line_padding, tag_name))
                for key in sub_obj:
                    sub_sub_obj = sub_obj[key]
                    result_list.append("%s<%s>" % (line_padding, key))
                    result_list.append(json2xml(sub_sub_obj, "\t" + line_padding))
                    result_list.append("%s</%s>" % (line_padding, key))
                result_list.append("%s</%s>" % (line_padding, tag_name))
            elif type(sub_obj) is list:
                result_list.append("%s<%s>" % (line_padding, tag_name))
                if tag_name == 'paymentTokens':
                    for sub_elem in sub_obj:
                        result_list.append("%s<%s>" % (line_padding, "paymentToken"))
                        result_list.append(json2xml(sub_elem, line_padding))
                        result_list.append("%s</%s>" % (line_padding, "paymentToken"))
                if tag_name == 'positionslist':
                    for sub_elem in sub_obj:
                        result_list.append("%s<%s>" % (line_padding, "position"))
                        result_list.append(json2xml(sub_elem, line_padding))
                        result_list.append("%s</%s>" % (line_padding, "position"))
                if tag_name == 'payments':
                    for sub_elem in sub_obj:
                        result_list.append("%s<%s>" % (line_padding, "payment"))
                        result_list.append(json2xml(sub_elem, line_padding))
                        result_list.append("%s</%s>" % (line_padding, "payment"))
                result_list.append("%s</%s>" % (line_padding, tag_name))
            else:
                result_list.append("%s<%s>" % (line_padding, tag_name))
                result_list.append(json2xml(sub_obj, "\t" + line_padding))
                result_list.append("%s</%s>" % (line_padding, tag_name))
        return "\n".join(result_list)
    return "%s%s" % (line_padding, json_obj)


def parallel_executor(context, feature_name, scenario):
    # os.chdir(testenv.PARALLEACTIONS_PATH)
    behave_main(
        '-i {} -n {} --tags=@test --no-skipped --no-capture'.format(feature_name, scenario))
    

def searchValueTag(xml_string, path_tag, flag_all_value_tag):
  list_tag = path_tag.split(".")
  size_list = len(list_tag)

  tag_padre = list_tag[0]
  tag = list_tag[size_list-1]

  tree = ET.ElementTree(ET.fromstring(xml_string))
  root = tree.getroot()
  list_value_tag = []
  full_list_tag = []
  for single_tag in root.findall('.//' + tag_padre):
    list_value_tag = searchValueTagRecursive(tag_padre, tag, single_tag)
    full_list_tag.append(list_value_tag)
    if flag_all_value_tag == False:
      if list_value_tag: 
          break
  return full_list_tag


def searchValueTagRecursive(tag_padre, tag, single_tag):
  list_tag = []

  if tag_padre == tag:
    list_tag = single_tag.text
  else:
    for next_tag in single_tag:
      list_tag = searchValueTagRecursive(next_tag.tag, tag, next_tag)
      if list_tag: break
  return list_tag    




def estrapola_header_host(url):
    parsed_url = urlparse(url)
    port = 443
    dominio = parsed_url.netloc
    if "localhost" in dominio:
        host = dominio
    else:
        host = f"{dominio}:{port}"
    return host


def replace_specific_string(original_string, target_string, replacement):
# Verifica se la stringa di destinazione è presente nella stringa originale
    if target_string in original_string:
        # Verifica se la stringa di destinazione è una corrispondenza esatta
        start_index = original_string.find(target_string)
        end_index = start_index + len(target_string)
        
        # Verifica che la sottostringa prima e dopo la target_string sia uno spazio o che sia alla fine della stringa
        if (original_string[start_index] == ' ') and (original_string.endswith('') or original_string[end_index] == ' '):
            # Effettua il replace solo se la condizione è soddisfatta
            updated_string = original_string[:start_index] + replacement + original_string[end_index:]
            return updated_string
        else:
            # Se la condizione non è soddisfatta, restituisci la stringa originale senza modifiche
            return original_string
    else:
        # Se la stringa di destinazione non è presente, restituisci la stringa originale senza modifiche
        return original_string



# def get_proxy_settings():
#     try:
#         # Apre la chiave di registro corrispondente alle impostazioni del proxy
#         key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Internet Settings")
 
#         # Legge il valore dell'URL dello script PAC
#         pac_url, _ = winreg.QueryValueEx(key, "AutoConfigURL")
#         return pac_url if pac_url else None
#     except FileNotFoundError:
#         print("Impossibile trovare le impostazioni del proxy nel Registro di sistema.")
#         return None
#     except Exception as e:
#         print("Errore durante la lettura delle impostazioni del proxy:", e)
#         return None
    

# # Funzione per ottenere l'URL del proxy da un file PAC
# def get_proxy(pac_file):
#     # Carica il file PAC
#     pac = pacparser.parse_pac_file(pac_file)

#     # Imposta il percorso del file PAC
#     pac.init()

#     # Ottieni l'URL del proxy per l'URL specificato
#     proxy_url = pac.find_proxy(pac_file)

#     return proxy_url
    
#metodo override del get_db_connection per l'environment
def get_db_connection_for_env(db_name, db_cfg, db_selected):
    return get_db_connection(db_name, db_cfg, '', '', '', '', db_selected)


def get_db_connection(db_name, db_cfg, db_online, db_offline, db_re, db_wfesp, db_selected):
    db = None
    conn = None
    if db_name.lower() == "nodo_online":
        db = db_online
        conn = db_online.getConnection(db_selected.get('host'), db_selected.get(
            'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))
    elif db_name.lower() == "nodo_offline":
        db = db_offline
        conn = db_offline.getConnection(db_selected.get('host'), db_selected.get(
            'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))
    elif db_name.lower() == "re":
        db = db_re
        conn = db_re.getConnection(db_selected.get('host'), db_selected.get(
            'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))
    elif db_name.lower() == "wfesp":
        db = db_wfesp
        conn = db_wfesp.getConnection(db_selected.get('host'), db_selected.get(
            'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))
    else:
        db = db_cfg
        conn = db_cfg.getConnection(db_selected.get('host'), db_selected.get(
            'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))
    return db, conn

#Ricerca chiavi in json
#obj = oggetto json deserializzato
#ricerca = chiave da cercare
def ricerca_chiavi(obj, ricerca, chiavi_trovate=None):
    if chiavi_trovate is None:
        chiavi_trovate = set()

    if isinstance(obj, dict):
        for chiave, valore in obj.items():
            if chiave == ricerca:
                chiavi_trovate.add(chiave)
            ricerca_chiavi(valore, ricerca, chiavi_trovate)
    elif isinstance(obj, list):
        for elemento in obj:
            ricerca_chiavi(elemento, ricerca, chiavi_trovate)

    return list(chiavi_trovate)




###METODO PER VERIFICARE CHE LA STRINGA ABBIA CARATTERI SPECIALI
def contiene_caratteri_speciali(stringa):
    caratteri_speciali = string.punctuation
    for carattere in stringa:
        if carattere in caratteri_speciali:
            return True
    return False


###METODO PER VERIFICARE CHE LA STRINGA ABBIA IL CARATTERE APICE
def contiene_carattere_apice(stringa):
    caratteri_apice = "'"
    for carattere in stringa:
        if carattere in caratteri_apice:
            return True
    return False




###METODO PER FARE LA TRANSPOSE VERTICALE DELLA CONTEXT TABLE, RITORNA UNA TABLE
def transpose_table(table):
    i = 0
    transposed_table_dict = {}
    for row in table:
        if i < 1:
           transposed_table_dict[row.headings[0]] = row.headings[1] 
        else:   
            transposed_table_dict[row[0]] = row[1]
        i+=1

   # Ottiene le chiavi del dict come intestazioni delle colonne
    headers = list(transposed_table_dict.keys())
    # Costruisci una lista di righe della tabella
    rows = [list(transposed_table_dict.values())]

    return Table(headings=headers, rows=rows)


###METODO PER FARE LA TRANSPOSE VERTICALE DELLA CONTEXT TABLE, RITORNA UNA DICT DELLA TABLE TRANSPOSTA
def transpose_table_to_dict(table):
    i = 0
    transposed_table_dict = {}
    for row in table:
        if i < 1:
           transposed_table_dict[row.headings[0]] = row.headings[1] 
        else:   
            transposed_table_dict[row[0]] = row[1]
        i+=1

    return transposed_table_dict

###METODO PER CREARE UNA DICT DA UNA CONTEXT TABLE, RITORNA UNA DICT DELLA TABLE
def table_to_dict(table, type_table):
    dict_table = {}
    # Definisco i valori predefiniti
    predefined_values = {'horizontal', 'vertical'}

    if type_table == 'horizontal':
        for row in table:
            for field, value in row.items():
                # Aggiunge la chiave e il valore al dict
                if field in dict_table:
                    dict_table[field].append(value)
                else:
                    dict_table[field] = [value]
    elif type_table == 'vertical':
        if len(table.rows) == 0:
            dict_table[table.headings[0]] = [table.headings[1]]
        else:    
            for row in table:
                dict_table[row.headings[0]] = [row.headings[1]]
                break

            for row in table:
                dict_table[row[0]] = [row[1]]
            
    else:
        raise ValueError(f"Invalid value of type table: {type_table}. It should be one of {predefined_values}")
    
    return dict_table


###METODO PER CREARE UNA SELECT CON WHERE
def generate_select(dict_fields_values):
    list_where_keys = []
    list_where_values = []
    dict_where = {}

    selected_query = 'SELECT columns FROM table_name'

    for fields, values in dict_fields_values.items():
        for value in values:
            if fields == 'where_keys':
                list_where_keys.append(value)
            elif fields == 'where_values':
                list_where_values.append(value)


    for j in range(0, len(list_where_keys)):
        dict_where[list_where_keys[j]] = list_where_values[j]

    i = 0
    for where_key, where_value in dict_where.items():
        if i == 0:
            if "(" in where_value :
                selected_query += f" WHERE {where_key} IN {where_value}"
            else :
                selected_query += f" WHERE {where_key} = '{where_value}'"
        else:
            if where_key == 'INSERTED_TIMESTAMP':
                selected_query += f" AND {where_key} > {where_value}"
            elif where_key == 'ORDER BY':
                selected_query += f" {where_key} {where_value}"
            else:    
                if "(" in where_value :
                    selected_query += f" AND {where_key} IN {where_value}"
                else :
                    selected_query += f" AND {where_key} = '{where_value}'"
        i += 1
    
    return selected_query

###METODO PER CREARE UNA SELECT CON WHERE
def generate_string_column_table(list_col_split):
    i = 0
    columns = ''
    for single_columns in list_col_split:
        if i == len(list_col_split)-1:
            columns += single_columns
        else:
            columns += single_columns + ','
        i += 1
    return columns

###METODO PER CREARE LIST VALUES EXPECTED E SIZE VALUE CON COMMA
def generate_list_values_exp_and_size_value_comma(dict_fields_values_expected):   
    count_comma_value = 0
    count_comma_value_max = 0
    list_values_expected = list()
    size_values_comma_expected = 0

    for field, value in dict_fields_values_expected.items():
        count_comma_value_temp = count_comma_value
        if ',' in value:
            count_comma_value = value.count(',')
            if count_comma_value > count_comma_value_temp:
                count_comma_value_max = count_comma_value

            count_comma_value_temp = count_comma_value

    size_values_comma_expected = count_comma_value_max

    for i in range(0, size_values_comma_expected+1):
        list_values_expected_single = list()
        list_value = list()
        for field, value in dict_fields_values_expected.items():
            if ',' in value:
                list_value = value.split(',')
                list_values_expected_single.append(list_value[i])
            else:
                list_values_expected_single.append(value)

        list_values_expected.append(list_values_expected_single)

    return list_values_expected, size_values_comma_expected


###METODO PER CREARE LIST DI DICT VALUES EXPECTED BY SIZE
def generate_list_dict_values_exp(list_col_split, size_dict_fields_values_expected, list_values_expected):
    list_dict_fields_values_expected = list()
    

    for i in range(0, size_dict_fields_values_expected+1):
        dict_fields_values_expected_temp = {}
        for field, value_obt in zip(list_col_split, list_values_expected[i]):
            dict_fields_values_expected_temp[field] = value_obt
        list_dict_fields_values_expected.append(dict_fields_values_expected_temp)

    return list_dict_fields_values_expected



###METODO PER CREARE LIST DI DICT VALUES OBTAINED
def generate_list_dict_values_obt(list_col_split, exec_query):
    list_dict_fields_values_obtained = list()
        
    size_result_query = len(exec_query)

    for i in range(0, size_result_query):
        dict_fields_values_obtained = {}
        for field, value_obt in zip(list_col_split, exec_query[i]):
            dict_fields_values_obtained[field] = value_obt
        list_dict_fields_values_obtained.append(dict_fields_values_obtained)

    return list_dict_fields_values_obtained