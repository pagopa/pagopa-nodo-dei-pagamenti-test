import requests

from behave import *
from xml.dom.minidom import parseString

valid_verify_payment_notice_req = None
url_nodo = None


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
        resp = requests.get(row['url'] + row['healtcheck'])
        responses &= (resp.status_code == 200)
        if row['name'] == "nodo-dei-pagamenti":
            global url_nodo
            url_nodo = row['url'] + row['service']
    assert (responses)


@given('valid verifyPaymentNoticeReq soap-request')
def step_impl(context):
    """
        get valid PSP verifyPaymentNoticeReq
    """
    global valid_verify_payment_notice_req
    valid_verify_payment_notice_req = context.text


@given('{elem} with {value} in verifyPaymentNoticeReq')
def step_impl(context, elem, value):
    global valid_verify_payment_notice_req
    my_document = parseString(valid_verify_payment_notice_req)
    if value == "None" :
        element = my_document.getElementsByTagName(elem)[0]
        element.parentNode.removeChild(element)
    elif value == "Null" :
        element = my_document.getElementsByTagName(elem)[0].childNodes[0]        
        element.nodeValue = ''
    else:
        element = my_document.getElementsByTagName(elem)[0].childNodes[0]
        element.nodeValue = value
    valid_verify_payment_notice_req = my_document.toxml()

@given('{attribute} set {value} for {elem} in verifyPaymentNoticeReq')
def step_impl(context, elem, attribute, value):
    global valid_verify_payment_notice_req
    my_document = parseString(valid_verify_payment_notice_req)
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    valid_verify_payment_notice_req = my_document.toxml()

# Scenario : Check valid URL in WSDL namespace
@when('psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti')
def step_impl(context):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    nodo_response = requests.post(url_nodo, valid_verify_payment_notice_req, headers=headers)
    assert (nodo_response.status_code == 200)

@then('{tag} is {value}')
def step_impl(context, tag, value):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    nodo_response = requests.post(url_nodo, valid_verify_payment_notice_req, headers=headers)    
    my_document = parseString(nodo_response.content)
    assert value == my_document.getElementsByTagName(tag)[0].firstChild.data
