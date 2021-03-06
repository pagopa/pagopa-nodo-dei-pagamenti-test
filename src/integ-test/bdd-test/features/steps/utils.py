import re
from xml.dom.minidom import parseString

import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry


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
    base_path = "/nodo"
    primitive_mapping = {
        "verificaBollettino": "/node-for-psp/v1",
        "verifyPaymentNotice": "/node-for-psp/v1",
        "activatePaymentNotice": "/node-for-psp/v1",
        "sendPaymentOutcome": "/node-for-psp/v1",
        "activateIOPayment": "/node-for-io/v1",
        "nodoVerificaRPT": "/nodo-per-psp/v1",
        "nodoAttivaRPT": "/nodo-per-psp/v1",
        "nodoInviaFlussoRendicontazione": "/nodo-per-psp/v1",
        "pspNotifyPayment": "/psp-for-node/v1",
        "nodoChiediElencoFlussiRendicontazione": "/nodo-per-pa/v1",
        "nodoChiediFlussoRendicontazione": "/nodo-per-pa/v1",
    }
    if "soap_service" in context.config.userdata.get("services").get("nodo-dei-pagamenti"):
        return context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") \
               + context.config.userdata.get("services").get("nodo-dei-pagamenti").get("soap_service")
    else:
        return context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") \
               + base_path + primitive_mapping.get(primitive)


def get_rest_url_nodo(context):
    if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service") is not None:
        return context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") \
               + context.config.userdata.get("services").get("nodo-dei-pagamenti").get("rest_service")
    else:
        return ""


def get_rest_mock_ec(context):
    if context.config.userdata.get("services").get("mock-ec").get("rest_service") is not None:
        return context.config.userdata.get("services").get("mock-ec").get("url") \
               + context.config.userdata.get("services").get("mock-ec").get("rest_service")
    else:
        return ""


def get_rest_mock_psp(context):
    # TODO fix service
    if context.config.userdata.get("services").get("mock-ec").get("rest_service") is not None:
        return context.config.userdata.get("services").get("mock-ec").get("url") \
               + context.config.userdata.get("services").get("mock-ec").get("rest_service")
    else:
        return ""


def save_soap_action(mock, primitive, soap_action, override=False):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    response = requests.post(f"{mock}/response/{primitive}?override={override}", soap_action, headers=headers)
    return response.status_code


def manipulate_soap_action(soap_action, elem, value):
    TYPE_ELEMENT = 1 # dom element
    # TYPE_VALUE = 3 # dom value
    print(soap_action)
    print(elem)
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


def replace_local_variables(body, context):
    pattern = re.compile('\\$\\w+\\.\\w+')
    match = pattern.findall(body)
    for field in match:
        saved_elem = getattr(context, field.replace('$', '').split('.')[0])
        value = saved_elem
        if len(field.replace('$', '').split('.')) > 1:
            tag = field.replace('$', '').split('.')[1]
            if isinstance(saved_elem, str):
                print(saved_elem)
                document = parseString(saved_elem)
            else:
                print(saved_elem.content)
                document = parseString(saved_elem.content)
            print(tag)
            value = document.getElementsByTagName(tag)[0].firstChild.data
        body = body.replace(field, value)
    return body


def replace_global_variables(payload, context):
    pattern = re.compile('#\\w+#')
    match = pattern.findall(payload)
    for elem in match:
        replaced_sharp = elem.replace("#", "")
        if replaced_sharp in context.config.userdata.get("global_configuration"):
            payload = payload.replace(elem, context.config.userdata.get("global_configuration").get(replaced_sharp))
    return payload


def get_history(rest_mock, notice_number, primitive):
    s = requests.Session()
    response = requests_retry_session(session=s).get(f"{rest_mock}/history/{notice_number}/{primitive}")
    return response.json(), response.status_code
