import json
import random
import time
from xml.dom.minidom import parseString

import requests
from behave import *

import utils as utils

RESPONSE = "Response"

REQUEST = "Request"


@given('systems up')
def step_impl(context):
    """
        health check for 
            - nodo-dei-pagamenti ( application under test )
            - mock-ec ( used by nodo-dei-pagamenti to forwarding EC's requests )
            - pagopa-api-config ( used in tests to set DB's nodo-dei-pagamenti correctly according to input test ))
    """
    responses = True
    for row in context.table:
        print(f"calling: {row.get('name')}")
        url = row.get("url") + row.get("healthcheck")
        resp = requests.get(url)
        responses &= (resp.status_code == 200)
    assert responses


@given(u'EC {version:OldNew} version')
def step_impl(context, version):
    pass


@given('initial XML {primitive}')
def step_impl(context, primitive):
    payload = context.text or ""
    payload = utils.replace_local_variables(payload, context)
    if len(payload) > 0:
        my_document = parseString(payload)
        idPSP = "70000000001"
        if len(my_document.getElementsByTagName('idPSP')) > 0:
            idPSP = my_document.getElementsByTagName('idPSP')[0].firstChild.data
        payload = payload.replace('#idempotency_key#', f"{idPSP}_{str(random.randint(1000000000, 9999999999))}")

    payload = payload.replace('#notice_number#', f"30211{str(random.randint(1000000000000, 9999999999999))}")

    payload = utils.replace_global_variables(payload, context)

    setattr(context, primitive, payload)


@given('{elem} with {value} in {action}')
def step_impl(context, elem, value, action):
    xml = utils.manipulate_soap_action(getattr(context, action), elem, value)
    setattr(context, action, xml)


@given('{attribute} set {value} for {elem} in {primitive}')
def step_impl(context, attribute, value, elem, primitive):
    my_document = parseString(getattr(context, primitive))
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    setattr(context, primitive, my_document.toxml())


# Scenario : Check valid URL in WSDL namespace
@when('{sender} sends soap {soap_primitive} to {receiver}')
def step_impl(context, sender, soap_primitive, receiver):
    headers = {'Content-Type': 'application/xml', "SOAPAction": soap_primitive}  # set what your server accepts
    # TODO get url according to receiver
    url_nodo = utils.get_soap_url_nodo(context)
    print("nodo soap_request sent >>>", getattr(context, soap_primitive))

    soap_response = requests.post(url_nodo, getattr(context, soap_primitive), headers=headers)
    setattr(context, soap_primitive + RESPONSE, soap_response)

    assert (soap_response.status_code == 200), f"status_code {soap_response.status_code}"


# When job <JOB_NAME> triggered
@when('job {job_name} triggered after {seconds} seconds')
def step_impl(context, job_name, seconds):
    time.sleep(int(seconds))
    url_nodo = utils.get_rest_url_nodo(context)
    nodo_response = requests.get(f"{url_nodo}/jobs/trigger/{job_name}")
    setattr(context, job_name + RESPONSE, nodo_response)


# Scenario: Execute activateIOPayment request
@then('check {tag} is {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        if len(my_document.getElementsByTagName('faultCode')) > 0:
            print("fault code: ", my_document.getElementsByTagName('faultCode')[0].firstChild.data)
            print("fault string: ", my_document.getElementsByTagName('faultString')[0].firstChild.data)
            if my_document.getElementsByTagName('description'):
                print("description: ", my_document.getElementsByTagName('description')[0].firstChild.data)
        data = my_document.getElementsByTagName(tag)[0].firstChild.data
        print(f'check tag "{tag}" - expected: {value}, obtained: {data}')
        assert value == data
    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        assert json_response.get(tag) == value


# TODO greater/equals than ...
@then('{tag} length is less than {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    my_document = parseString(soap_response.content)
    payment_token = my_document.getElementsByTagName(tag)[0].firstChild.data
    assert len(payment_token) < int(value)


@then('{tag} exists of {primitive} response')
def step_impl(context, tag, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    my_document = parseString(soap_response.content)
    payment_token = my_document.getElementsByTagName(tag)[0].firstChild.data
    assert payment_token is not None


@then(u'check {mock:EcPsp} receives {primitive} properly')
def step_impl(context, mock, primitive):
    rest_mock = utils.get_rest_mock_ec(context) if mock == "EC" else utils.get_rest_mock_psp(context)

    notice_number = utils.replace_local_variables(context.text, context).strip()

    s = requests.Session()
    responseJson = utils.requests_retry_session(session=s).get(
        f"{rest_mock}/api/v1/history/{notice_number}/{primitive}")
    json = responseJson.json()
    assert "request" in json and len(json.get("request").keys()) > 0


@given('the {name} scenario executed successfully')
def step_impl(context, name):
    phase = ([phase for phase in context.feature.scenarios if name in phase.name] or [None])[0]
    text_step = ''.join(
        [step.keyword + " " + step.name + "\n\"\"\"\n" + (step.text or '') + "\n\"\"\"\n" for step in phase.steps])
    print(text_step)
    context.execute_steps(text_step)


@when(u'{sender} sends rest {method:Method} {service} to {receiver}')
def step_impl(context, sender, method, service, receiver):
    # TODO get url according to receiver
    url_nodo = utils.get_rest_url_nodo(context)

    headers = {'Content-Type': 'application/json'}
    body = context.text or ""

    body = utils.replace_local_variables(body, context)
    service = utils.replace_local_variables(service, context)
    print(f"{url_nodo}/{service}")
    print(body)
    if len(body) > 1:
        json_body = json.loads(body)
    else:
        json_body = None

    nodo_response = requests.request(method, f"{url_nodo}/{service}", headers=headers,
                                     json=json_body)

    print(nodo_response.text)
    setattr(context, service.split('?')[0] + RESPONSE, nodo_response)


@then('verify the HTTP status code of {action} response is {value}')
def step_impl(context, action, value):
    print(f'HTTP status expected: {value} - obtained:{getattr(context, action + RESPONSE).status_code}')
    assert int(value) == getattr(context, action + RESPONSE).status_code


@given('{mock} replies to {destination} with the {primitive}')
def step_impl(context, mock, destination, primitive):
    if context.text:
        pa_verify_payment_notice_res = context.text
    else:
        pa_verify_payment_notice_res = getattr(context, primitive)
    pa_verify_payment_notice_res = str(pa_verify_payment_notice_res).replace("#fiscalCodePA#",
                                                                             context.config.userdata.get(
                                                                                 "global_configuration").get(
                                                                                 "creditor_institution_code"))
    setattr(context, primitive, pa_verify_payment_notice_res)

    response_status_code = utils.save_soap_action(utils.get_rest_mock_ec(context), primitive,
                                                  pa_verify_payment_notice_res, override=True)
    assert response_status_code == 200


@given('{mock} wait for {sec} seconds at {action}')
def step_impl(context, mock, sec, action):
    """
            configure mock response
        """
    # TODO configure mock to wait x seconds at action
    pass


@step('if outcome is KO set fault to None in paVerifyPaymentNotice')
def step_impl(context):
    pass


@then('activateIOPaymentResp and pspNotifyPaymentReq are consistent')
def step_impl(context):
    pass


@step('idChannel with USE_NEW_FAULT_CODE=Y')
def step_impl(context):
    # TODO verify with api-config
    pass


@step("random idempotencyKey having {value} as idPSP in {primitive}")
def step_impl(context, value, primitive):
    xml = utils.manipulate_soap_action(getattr(context, primitive), "idempotencyKey", f"{value}_{str(random.randint(1000000000, 9999999999))}")
    setattr(context, primitive, xml)

