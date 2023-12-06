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

from urllib.parse import urlparse

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
        "nodoInviaFlussoRendicontazione": "/nodo-per-psp/v1",
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
    if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("soap_service") == "":
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


def save_soap_action(context, mock, primitive, soap_action, override=False):
    # set what your server accepts
    headers = {'Content-Type': 'application/xml'}
    print(f'{mock}/response/{primitive}?override={override}')
    response = requests.post(
        f"{mock}/response/{primitive}?override={override}", soap_action, headers=headers, verify=False, proxies = getattr(context,'proxies'))
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
        body = body.replace(field, f'$${value}$$')
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


def get_history(context, rest_mock, notice_number, primitive):
    s = requests.Session()
    response = requests_retry_session(session=s).get(
        f"{rest_mock}/history/{notice_number}/{primitive}", proxies = getattr(context,'proxies'))
    return response.json(), response.status_code


def query_json(context, name_query, name_macro):
    query = json.load(open(os.path.join(
        context.config.base_dir + "/../resources/query_AutomationTest.json")))
    selected_query = query.get(name_macro).get(name_query)
    if '$' in selected_query:
        selected_query = replace_local_variables_for_query(selected_query, context)
        selected_query = replace_context_variables_for_query(selected_query, context)
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


def single_thread(context, soap_primitive, type):
    print("single_thread")
    primitive = soap_primitive.split("_")[0]
    primitive = replace_local_variables(primitive, context)
    primitive = replace_context_variables(primitive, context)
    primitive = replace_global_variables(primitive, context)
    
    if type == 'GET':
        url_nodo = f"{get_rest_url_nodo(context, primitive)}/{primitive}"
        header_host = estrapola_header_host(url_nodo)
        headers = {'X-Forwarded-For': '10.82.39.148', 'Host': header_host}
        if 'SUBSCRIPTION_KEY' in os.environ:
            headers = {'Ocp-Apim-Subscription-Key', os.getenv('SUBSCRIPTION_KEY') }
        
        print(url_nodo)
        soap_response = requests.get(url_nodo, headers=headers, verify=False, proxies = getattr(context,'proxies'))
    elif type == 'POST':
        body = getattr(context, primitive)
        print(body)
        if 'xml' in getattr(context, primitive):
            # headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'X-Forwarded-For': '10.82.39.148', 'Host': 'api.dev.platform.pagopa.it:443'}
            url_nodo = get_soap_url_nodo(context, primitive)
            header_host = estrapola_header_host(url_nodo)
            headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive, 'Host': header_host}
            if 'SUBSCRIPTION_KEY' in os.environ:
                headers['Ocp-Apim-Subscription-Key'] = os.getenv('SUBSCRIPTION_KEY')
        else:
            # headers = {'Content-Type': 'application/json', 'X-Forwarded-For': '10.82.39.148', 'Host': 'api.dev.platform.pagopa.it:443'}
            url_nodo = f"{get_rest_url_nodo(context, primitive)}/{primitive}"
            header_host = estrapola_header_host(url_nodo)
            headers = {'Content-Type': 'application/json', 'Host': header_host}
            if 'SUBSCRIPTION_KEY' in os.environ:
                headers['Ocp-Apim-Subscription-Key'] = os.getenv('SUBSCRIPTION_KEY')

        soap_response = requests.post(url_nodo, body, headers=headers, verify=False, proxies = getattr(context,'proxies'))

    print("nodo soap_response: ", soap_response.content)
    print(soap_primitive.split("_")[1] + "Response")
    setattr(context, soap_primitive.split("_")[1] + "Response", soap_response)


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
      if list_value_tag: break
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