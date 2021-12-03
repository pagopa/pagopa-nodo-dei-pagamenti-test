import requests

from behave import *
from xml.dom.minidom import parseString

valid_verify_payment_notice_req = None
nodo_response = None
url_nodo = None


# Background
@given('systems up')
def step_impl(context):
    """
        health check nodo-dei-pagamenti and mock-ec
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
    pass


@given('{attribute} set {value} in verifyPaymentNoticeReq')
def step_impl(context, attribute, value):
    pass


# Scenario : Check valid URL in WSDL namespace
@when('psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti')
def step_impl(context):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    global nodo_response
    nodo_response = requests.post(url_nodo, valid_verify_payment_notice_req, headers=headers)
    assert (nodo_response.status_code == 200)


@then('{tag} is {value}')
def step_impl(context, tag, value):
    my_document = parseString(nodo_response.content)
    assert value == my_document.getElementsByTagName(tag)[0].firstChild.data
