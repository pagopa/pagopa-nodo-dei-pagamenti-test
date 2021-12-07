from xml.dom.minidom import parseString
import requests
from behave import *


def get_url_nodo(context):
    return context.config.userdata.get("services").get("nodo-dei-pagamenti").get("url") \
           + context.config.userdata.get("services").get("nodo-dei-pagamenti").get("service")


# Background
@given('systems up')
def step_impl(context):
    """
        health check for 
            - nodo-dei-pagamenti ( application under test )
            - mock-ec ( used by nodo-dei-pagamenti to forwarding EC's requests )
            - pagopa-api-config ( used in tests to set DB's nodo-dei-pagamenti correctly accoding to input test ))
    """
    responses = True
    for row in context.table:
        print(f"calling: {row.get('name')}")
        url = row.get("url") + row.get("healthcheck")
        resp = requests.get(url)
        responses &= (resp.status_code == 200)
    assert responses


@given('valid {verifyPaymentNoticeReq} soap-request')
def step_impl(context, verifyPaymentNoticeReq):
    """
        get valid PSP verifyPaymentNoticeReq
    """
    payload = context.text.replace('#creditor_institution_code#',
                                   context.config.userdata.get("global_configuration").get("creditor_institution_code"))
    setattr(context, "soap_request", payload)


@given('{elem} with {value} in verifyPaymentNoticeReq')
def step_impl(context, elem, value):
    my_document = parseString(context.soap_request)
    if value == "None":
        element = my_document.getElementsByTagName(elem)[0]
        element.parentNode.removeChild(element)
    elif value == "Empty":
        element = my_document.getElementsByTagName(elem)[0].childNodes[0]
        element.nodeValue = ''
    else:
        element = my_document.getElementsByTagName(elem)[0].childNodes[0]
        element.nodeValue = value
    setattr(context, "soap_request", my_document.toxml())


@given('{attribute} set {value} for {elem} in verifyPaymentNoticeReq')
def step_impl(context, attribute, value, elem):
    my_document = parseString(context.soap_request)
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    setattr(context, "soap_request", my_document.toxml())


# Scenario : Check valid URL in WSDL namespace
@when('psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti')
def step_impl(context):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = get_url_nodo(context)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    assert (nodo_response.status_code == 200)


# Scenario: Execute activateIOPayment request
@then('check {tag} is {value}')
def step_impl(context, tag, value):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = get_url_nodo(context)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    my_document = parseString(nodo_response.content)
    if len(my_document.getElementsByTagName('faultCode')) > 0:
        print(my_document.getElementsByTagName('faultCode')[0].firstChild.data)
        print(my_document.getElementsByTagName('faultString')[0].firstChild.data)
        print(my_document.getElementsByTagName('description')[0].firstChild.data)
    assert value == my_document.getElementsByTagName(tag)[0].firstChild.data


@when("IO sends an activateIOPaymentReq to nodo-dei-pagamenti")
def step_impl(context):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = get_url_nodo(context)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    setattr(context, "soap_response", nodo_response)
    assert nodo_response.status_code == 200


@then("token exists and check")
def step_impl(context):
    my_document = parseString(context.soap_response.content)
    if len(my_document.getElementsByTagName('paymentToken')) > 0:
        paymentToken = my_document.getElementsByTagName('paymentToken')[0].firstChild.data
        setattr(context, "paymentToken", paymentToken)
        assert 0 < len(paymentToken) < 36
    else:
        assert False



@then('verify the HTTP {staus_code} response is {value}')
def step_impl(context, tag, value):
    pass

# Scenario: Execute nodoChiediInformazioniPagamento request
@given("the activate phase executed successfully")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: Given the activate phase executed successfully')


@when("WISP/PM sends an informazioniPagamento to nodo-dei-pagamenti using the token of the activate phase")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: When WISP/PM sends an informazioniPagamento to nodo-dei-pagamenti using the token of the activate phase')


# Scenario: Execute nodoInoltraEsitoPagamentoCarta request
@given("the payment phase executed successfully")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: Given the payment phase executed successfully')


@when("WISP/PM sends an inoltroEsito/Carta to nodo-dei-pagamenti using the token and PSP/Canale data")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: When WISP/PM sends an inoltroEsito/Carta to nodo-dei-pagamenti using the token and PSP/Canale data')


@step("activeIOPaymentResp and pspNotifyPaymentReq are consistent")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And activeIOPaymentResp and pspNotifyPaymentReq are consistent')
