import re
import json
import os
import datetime
from webbrowser import get
from xml.dom.minidom import parseString

from behave.__main__ import main as behave_main
import time
from threading import Thread
import requests
from requests.adapters import HTTPAdapter
import xmltodict

# Decommentare per test in pipeline
#from requests.packages.urllib3.util.retry import Retry 

# Commentare per test in pipeline
from urllib3.util.retry import Retry

import xml.etree.ElementTree as ET

def random_s():
    import random
    cont = 5
    strNumRand = ''
    while cont != 0:
        strNumRand += str(random.randint(0, 9))
        cont -= 1
    return strNumRand


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
        return context.config.userdata.get('services').get('nodo-dei-pagamenti').get('url') \
            + context.config.userdata.get('services').get(
                'nodo-dei-pagamenti').get('refresh_config_service')
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


def save_soap_action(mock, primitive, soap_action, override=False):
    # set what your server accepts
    headers = {'Content-Type': 'application/xml'}
    print(f'{mock}/response/{primitive}?override={override}')
    response = requests.post(
        f"{mock}/response/{primitive}?override={override}", soap_action, headers=headers, verify=False)
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
    pattern = re.compile('\\$\\w+')
    match = pattern.findall(body)
    for field in match:
        saved_elem = getattr(context, field.replace('$', ''))
        value = str(saved_elem)
        body = body.replace(field, value)
    return body


def replace_local_variables(body, context):
    pattern = re.compile('\\$\\w+\\.\\w+')
    match = pattern.findall(body)
    for field in match:
        saved_elem = getattr(context, field.replace('$', '').split('.')[0])
        value = saved_elem
        if len(field.replace('$', '').split('.')) > 1:
            tag = field.replace('$', '').split('.')[1]
            if isinstance(saved_elem, str):
                document = parseString(saved_elem)
            else:
                document = parseString(saved_elem.content)
                print(tag)
            value = document.getElementsByTagNameNS(
                '*', tag)[0].firstChild.data
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


def get_history(rest_mock, notice_number, primitive):
    s = requests.Session()
    response = requests_retry_session(session=s).get(
        f"{rest_mock}/history/{notice_number}/{primitive}")
    return response.json(), response.status_code


def query_json(context, name_query, name_macro):
    query = json.load(open(os.path.join(
        context.config.base_dir + "/../resources/query_AutomationTest.json")))
    selected_query = query.get(name_macro).get(name_query)
    if '$' in selected_query:
        selected_query = replace_local_variables(selected_query, context)
        selected_query = replace_context_variables(selected_query, context)
        selected_query = replace_global_variables(selected_query, context)
    return selected_query


def isFloat(string: str) -> bool:
    value = string.split('.')
    return len(value) == 2 and value[0].isdigit() and value[1].isdigit()


def isDate(string: str):
    try:
        return string == datetime.datetime.strptime(string, '%Y-%m-%d')
    except ValueError:
        return False


def single_thread(context, soap_primitive, tipo):
    print("single_thread")
    primitive = soap_primitive.split("_")[0]
    primitive = replace_local_variables(primitive, context)
    primitive = replace_context_variables(primitive, context)
    primitive = replace_global_variables(primitive, context)
    
    if tipo == 'GET':       
        headers = {'X-Forwarded-For': '10.82.39.148', 'Host': 'api.dev.platform.pagopa.it:443'}
        if 'SUBSCRIPTION_KEY' in os.environ:
            headers = {'Ocp-Apim-Subscription-Key', os.getenv('SUBSCRIPTION_KEY') }
        if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service") == "":
            url_nodo = f"{get_rest_url_nodo(context, primitive)}/{primitive}"
        else:
            url_nodo = get_rest_url_nodo(context, primitive)
        print(f"url: {url_nodo}")
        soap_response = requests.get(url_nodo, headers=headers, verify=False)
        print("soap_response: ", soap_response.content)
        print(soap_primitive.split("_")[1] + "Response")
        setattr(context, soap_primitive.split("_")[1] + "Response", soap_response)
    elif tipo == 'POST':
        body = getattr(context, primitive)
        print(body)
        response = ''
        url_nodo = ''
        if 'xml' in getattr(context, primitive):
            # headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'X-Forwarded-For': '10.82.39.148', 'Host': 'api.dev.platform.pagopa.it:443'}
            headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'Host': 'api.dev.platform.pagopa.it:443'}
            if 'SUBSCRIPTION_KEY' in os.environ:
                headers['Ocp-Apim-Subscription-Key'] = os.getenv('SUBSCRIPTION_KEY')

            url_nodo = get_soap_url_nodo(context, primitive)
            print(f"url: {url_nodo}")
            response = requests.post(url_nodo, body, headers=headers, verify=False)
        else:
            # headers = {'Content-Type': 'application/json', 'X-Forwarded-For': '10.82.39.148', 'Host': 'api.dev.platform.pagopa.it:443'}
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
                    if ('primaryCiIncurredFee' in body.keys()) and (body["primaryCiIncurredFee"] != None):
                        body["primaryCiIncurredFee"] = float(body["primaryCiIncurredFee"])
                    if ('positionslist' in body.keys()) and (body["positionslist"] != None):
                        body["positionslist"] = body["positionslist"]["position"]
                        if type(body["positionslist"]) != list:
                            l = list()
                            l.append(body["positionslist"])
                            body["positionslist"] = l
                    body = json.dumps(body, indent=4)
            headers = {'Content-Type': 'application/json', 'Host': 'api.dev.platform.pagopa.it:443'}
            if 'SUBSCRIPTION_KEY' in os.environ:
                headers['Ocp-Apim-Subscription-Key'] = os.getenv('SUBSCRIPTION_KEY')  

            if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service") == "":
                url_nodo = f"{get_rest_url_nodo(context, primitive)}/{primitive}"
            else:    
                url_nodo = get_rest_url_nodo(context, primitive)
                
            print(f"url: {url_nodo}")
            response = requests.post(url_nodo, body, headers=headers, verify=False)

        print("response: ", response.content)
        print(soap_primitive.split("_")[1] + "Response")
        setattr(context, soap_primitive.split("_")[1] + "Response", response)
    

def threading(context, primitive_list, list_of_type):
    i = 0
    threads = list()
    while i < len(primitive_list):
        t = Thread(target=single_thread, args=(
            context, primitive_list[i], list_of_type[i]))
        threads.append(t)
        t.start()
        i += 1

    for thread in threads:
        thread.join()


def threading_delayed(context, primitive_list, list_of_delays, list_of_type):
    i = 0
    threads = list()
    while i < len(primitive_list):
        t = Thread(target=single_thread, args=(
            context, primitive_list[i], list_of_type[i]))
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