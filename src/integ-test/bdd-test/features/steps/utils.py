import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
from xml.dom.minidom import parseString


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


def get_soap_url_nodo(context):
    if context.config.userdata.get("services").get("nodo-dei-pagamenti").get("soap_service") is not None:
        return context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") \
               + context.config.userdata.get("services").get("nodo-dei-pagamenti").get("soap_service")
    else:
        return ""


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


def set_nodo_response(context, nodo_response):
    test_configuration = context.config.userdata.get("test_configuration")
    if test_configuration is None:
        test_configuration = {}
    test_configuration["soap_response"] = nodo_response
    context.config.update_userdata({"test_configuration": test_configuration})


def save_soap_action(mock, primitive, soap_action, override=False):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    response = requests.post(f"{mock}/api/v1/response/{primitive}?override={override}", soap_action, headers=headers)
    return response.status_code


def manipulate_soap_action(soap_action, elem, value):
    TYPE_ELEMENT = 1 # dom element
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
            if (child.nodeType == TYPE_ELEMENT):
                child.parentNode.removeChild(child)
    else:
        element = my_document.getElementsByTagName(elem)[0].childNodes[0]
        element.nodeValue = value
    return my_document.toxml()


def get_primitive(action):
    action_to_primitive = {
        "verifyPaymentNoticeReq": "verifyPaymentNotice",
        "verifyPaymentNoticeRes": "verifyPaymentNotice",
        "paVerifyPaymentNoticeReq": "paVerifyPaymentNotice",
        "paVerifyPaymentNoticeRes": "paVerifyPaymentNotice"
    }
    return action_to_primitive.get(action)
