import requests
from requests.models import Response

from behave import *


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
        resp=requests.get(row['url']+row['healtcheck'])   
        responses &= (resp.status_code == 200)
        if row['name']=="nodo-dei-pagamenti":
            global url_nodo 
            url_nodo = row['url']+row['service']
    assert(responses)

@given('valid verifyPaymentNoticeReq soap-request')
def step_impl(context):
    """
        get valid PSP verifyPaymentNoticeReq
    """
    global valid_verify_payment_notice_req
    valid_verify_payment_notice_req = context.text
    print(valid_verify_payment_notice_req)

    
# Scenario : Check valid URL in WSDL namespace
@when('psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti')
def step_impl(context):
    headers = {'Content-Type': 'application/xml'} # set what your server accepts
    nodo_response=requests.post(url_nodo,valid_verify_payment_notice_req,headers=headers)
    assert(nodo_response.status_code == 200)

@then('nodo-dei-pagamenti sends verifyPaymentNoticeRes with outcome OK')
def step_impl(context):
    print(nodo_response)
    assert nodo_response