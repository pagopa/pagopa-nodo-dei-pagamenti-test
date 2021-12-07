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


@given('valid verifyPaymentNoticeReq soap-request')
def step_impl(context):
    """
        get valid PSP verifyPaymentNoticeReq
    """
    payload = context.text.replace('#creditor_institution_code#',
                                   context.config.userdata.get("global_configuration").get("creditor_institution_code"))
    setattr(context, "valid_verify_payment_notice_req", payload)


@given('{elem} with {value} in verifyPaymentNoticeReq')
def step_impl(context, elem, value):
    my_document = parseString(context.valid_verify_payment_notice_req)
    if value == "None":
        element = my_document.getElementsByTagName(elem)[0]
        element.parentNode.removeChild(element)
    elif value == "Empty":
        element = my_document.getElementsByTagName(elem)[0].childNodes[0]
        element.nodeValue = ''
    else:
        element = my_document.getElementsByTagName(elem)[0].childNodes[0]
        element.nodeValue = value
    setattr(context, "valid_verify_payment_notice_req", my_document.toxml())


@given('{attribute} set {value} for {elem} in verifyPaymentNoticeReq')
def step_impl(context, attribute, value, elem):
    my_document = parseString(context.valid_verify_payment_notice_req)
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    setattr(context, "valid_verify_payment_notice_req", my_document.toxml())


# Scenario : Check valid URL in WSDL namespace
@when('psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti')
def step_impl(context):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = get_url_nodo(context)
    nodo_response = requests.post(url_nodo, context.valid_verify_payment_notice_req, headers=headers)
    assert (nodo_response.status_code == 200)


@then('{tag} is {value}')
def step_impl(context, tag, value):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = get_url_nodo(context)
    nodo_response = requests.post(url_nodo, context.valid_verify_payment_notice_req, headers=headers)
    my_document = parseString(nodo_response.content)
    if len(my_document.getElementsByTagName('faultCode')) > 0:
        print(my_document.getElementsByTagName('faultCode')[0].firstChild.data)
    assert value == my_document.getElementsByTagName(tag)[0].firstChild.data
