import json
import random
from sre_constants import ASSERT
import time
from xml.dom.minidom import parseString
from parso import split_lines

import requests
from behave import *
from requests.exceptions import RetryError

import utils as utils
import db_operation as db


# Constants
RESPONSE = "Response"
REQUEST = "Request"


# Steps definitions
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
        print(f"calling: {row.get('name')} -> {row.get('url')}")
        url = row.get("url") + row.get("healthcheck")
        print(f"calling -> {url}")
        resp = requests.get(url)
        print(f"response: {resp.status_code}")
        responses &= (resp.status_code == 200)
    assert responses


@given(u'EC {version:OldNew} version')
def step_impl(context, version):
    # TODO implement with api-config
    pass


@given('initial XML {primitive}')
def step_impl(context, primitive):
    payload = context.text or ""
    payload = utils.replace_local_variables(payload, context)
    if len(payload) > 0:
        my_document = parseString(payload)
        idBrokerPSP = "70000000001"
        if len(my_document.getElementsByTagName('idBrokerPSP')) > 0:
            idBrokerPSP = my_document.getElementsByTagName('idBrokerPSP')[0].firstChild.data
        payload = payload.replace('#idempotency_key#', f"{idBrokerPSP}_{str(random.randint(1000000000, 9999999999))}")

    if '#notice_number#' in payload:
        notice_number = f"30211{str(random.randint(1000000000000, 9999999999999))}"
        payload = payload.replace('#notice_number#', notice_number)
        setattr(context, "iuv", notice_number[1:])
    
    if '#notice_number_old#' in payload:
        notice_number = f"31211{str(random.randint(1000000000000, 9999999999999))}"
        payload = payload.replace('#notice_number_old#', notice_number)
        setattr(context, "iuv", notice_number[1:])

    if '$iuv' in payload:
        payload = payload.replace('$iuv', getattr(context, 'iuv'))

    payload = utils.replace_global_variables(payload, context)

    setattr(context, primitive, payload)
    
@given('{RPT} generation')
def step_impl(context, RPT):
    setattr(context,'RPT',RPT)
    rpt = getattr(context, 'RPT')
    print(rpt)


@given('{elem} with {value} in {action}')
def step_impl(context, elem, value, action):
    # use - to skip
    if elem != "-":
        value = utils.replace_local_variables(value, context)
        value = utils.replace_global_variables(value, context)
        xml = utils.manipulate_soap_action(getattr(context, action), elem, value)
        setattr(context, action, xml)


@given('{attribute} set {value} for {elem} in {primitive}')
def step_impl(context, attribute, value, elem, primitive):
    my_document = parseString(getattr(context, primitive))
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    setattr(context, primitive, my_document.toxml())


@step('{sender} sends soap {soap_primitive} to {receiver}')
def step_impl(context, sender, soap_primitive, receiver):
    primitive = soap_primitive.split("_")[0]
    headers = {'Content-Type': 'application/xml', "SOAPAction": primitive}  # set what your server accepts
    url_nodo = utils.get_soap_url_nodo(context, primitive)
    print("nodo soap_request sent >>>", getattr(context, soap_primitive))

    soap_response = requests.post(url_nodo, getattr(context, soap_primitive), headers=headers)
    print(soap_response.content)
    setattr(context, soap_primitive + RESPONSE, soap_response)

    assert (soap_response.status_code == 200), f"status_code {soap_response.status_code}"


@when('job {job_name} triggered after {seconds} seconds')
def step_impl(context, job_name, seconds):
    time.sleep(int(seconds))
    url_nodo = utils.get_rest_url_nodo(context)
    nodo_response = requests.get(f"{url_nodo}/jobs/trigger/{job_name}")
    setattr(context, job_name + RESPONSE, nodo_response)


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
        value = utils.replace_local_variables(value, context)
        value = utils.replace_global_variables(value, context)
        print(f'check tag "{tag}" - expected: {value}, obtained: {data}')
        assert value == data
    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        print(f'check tag "{tag}" - expected: {value}, obtained: {json_response.get(tag)}')
        assert json_response.get(tag) == value


@then('check {tag} contains {value} of {primitive} response')
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
        assert value in data
    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        assert value in json_response.get(tag)


@then('check {tag} field exists in {primitive} response')
def step_impl(context, tag, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        assert len(my_document.getElementsByTagName(tag)) > 0
    else:
        assert False


# TODO improve with greater/equals than options
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
        f"{rest_mock}/history/{notice_number}/{primitive}")
    json = responseJson.json()
    assert "request" in json and len(json.get("request").keys()) > 0


@then(u'check {mock:EcPsp} receives {primitive} {status:ProperlyNotProperly} with noticeNumber {notice_number}')
def step_impl(context, mock, primitive, status, notice_number):
    rest_mock = utils.get_rest_mock_ec(context) if mock == "EC" else utils.get_rest_mock_psp(context)
    if "$" in notice_number:
        notice_number = utils.replace_local_variables(notice_number, context)

    if status == "properly":
        json, status_code = utils.get_history(rest_mock, notice_number, primitive)
        setattr(context, primitive, json)
        assert "request" in json and len(json.get("request").keys()) > 0
    else:
        try:
            json, status_code = utils.get_history(rest_mock, notice_number, primitive)
            assert status_code != 200
        except RetryError:
            assert True


@then(u'check {mock:EcPsp} receives {primitive} properly having in the receipt {value} as {elem}')
def step_impl(context, mock, primitive, value, elem):
    json = getattr(context, primitive)
    if "$" in value:
        value = utils.replace_local_variables(value, context)
    body = json.get("request").get("soapenv:envelope").get("soapenv:body")[0]
    primitive_name = list(body.keys())[0]
    assert body.get(primitive_name)[0].get("receipt")[0].get(elem)[0] == value


@then(
    u'check {mock:EcPsp} receives {primitive} properly having in the transfer with idTransfer {idTransfer} the same {elem} of {other_primitive}')
def step_impl(context, mock, primitive, idTransfer, elem, other_primitive):
    _assert = False
    soap_action = getattr(context, other_primitive)
    my_document = parseString(soap_action)
    map = {}
    for transfer in my_document.getElementsByTagName("transfer"):
        if transfer.getElementsByTagName("idTransfer")[0].firstChild.nodeValue == idTransfer:
            map[idTransfer] = transfer.getElementsByTagName(elem)[0].firstChild.nodeValue

    json = getattr(context, primitive)
    body = json.get("request").get("soapenv:envelope").get("soapenv:body")[0]
    primitive_name = list(body.keys())[0]

    for transfer in body.get(primitive_name)[0].get("receipt")[0].get("transferlist")[0].get("transfer"):
        if transfer.get("idtransfer")[0] == str(idTransfer):
            _assert = transfer.get(str(elem).lower())[0] == map[idTransfer]
            break
    assert _assert


@step('the {name} scenario executed successfully')
def step_impl(context, name):
    phase = ([phase for phase in context.feature.scenarios if name in phase.name] or [None])[0]
    text_step = ''.join(
        [step.keyword + " " + step.name + "\n\"\"\"\n" + (step.text or '') + "\n\"\"\"\n" for step in phase.steps])
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
    if len(body) > 1:
        json_body = json.loads(body)
    else:
        json_body = None

    nodo_response = requests.request(method, f"{url_nodo}/{service}", headers=headers,
                                     json=json_body)

    setattr(context, service.split('?')[0], json_body)
    setattr(context, service.split('?')[0] + RESPONSE, nodo_response)
    print(service.split('?')[0] + RESPONSE)


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
    
    if '$iuv' in pa_verify_payment_notice_res:
        pa_verify_payment_notice_res = pa_verify_payment_notice_res.replace('$iuv', getattr(context, 'iuv'))

    setattr(context, primitive, pa_verify_payment_notice_res)
    print(pa_verify_payment_notice_res)
    response_status_code = utils.save_soap_action(utils.get_soap_mock_ec(context), primitive,
                                                  pa_verify_payment_notice_res, override=True)

    assert response_status_code == 200

@given('{mock} wait for {sec} seconds at {action}')
def step_impl(context, mock, sec, action):
    # TODO configure mock to wait x seconds at action
    pass


@step('if {field} is {field_value} set {elem} to {value} in {primitive}')
def step_impl(context, field, field_value, elem, value, primitive):
    xml = getattr(context, primitive)
    my_document = parseString(xml)
    field_data = my_document.getElementsByTagName(field)
    if len(field_data) > 0 and len(field_data[0].childNodes) > 0 and field_data[0].firstChild.data == field_value:
        xml = utils.manipulate_soap_action(xml, elem, value)
        setattr(context, primitive, xml)


@then('activateIOPayment response and pspNotifyPayment request are consistent')
def step_impl(context):
    # retrieve info from soap request of background step
    soap_request = getattr(context, "activateIOPayment")
    my_document = parseString(soap_request)
    notice_number = my_document.getElementsByTagName('noticeNumber')[0].firstChild.data

    inoltroEsito = getattr(context, "inoltroEsito/carta")

    activateIOPaymentResponse = getattr(context, "activateIOPayment" + RESPONSE)
    activateIOPaymentResponseXml = parseString(activateIOPaymentResponse.content)

    paGetPaymentJson = requests.get(f"{utils.get_rest_mock_ec(context)}/history/{notice_number}/paGetPayment")
    pspNotifyPaymentJson = requests.get(
        f"{utils.get_rest_mock_ec(context)}/history/{notice_number}/pspNotifyPayment")

    paGetPayment = paGetPaymentJson.json()
    pspNotifyPayment = pspNotifyPaymentJson.json()

    # verify transfer list are equal
    paGetPaymentRes_transferList = \
        paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[0].get(
            "data")[0].get("transferList")
    pspNotifyPaymentReq_transferList = \
        pspNotifyPayment.get("request").get("soapenv:envelope").get("soapenv:body")[0].get("pspfn:pspnotifypaymentreq")[
            0].get("transferlist")

    paGetPaymentRes_transferList_sorted = sorted(paGetPaymentRes_transferList, key=lambda transfer: int(
        transfer.get("transfer")[0].get("idTransfer")[0]))
    pspNotifyPaymentReq_transferList_sorted = sorted(pspNotifyPaymentReq_transferList, key=lambda transfer: int(
        transfer.get("transfer")[0].get("idtransfer")[0]))

    mixed_list = zip(paGetPaymentRes_transferList_sorted, pspNotifyPaymentReq_transferList_sorted)
    for x in mixed_list:
        assert x[0].get("transfer")[0].get("idTransfer")[0] == x[1].get("transfer")[0].get("idtransfer")[0]
        assert x[0].get("transfer")[0].get("transferAmount")[0] == x[1].get("transfer")[0].get("transferamount")[0]
        assert x[0].get("transfer")[0].get("fiscalCodePA")[0] == x[1].get("transfer")[0].get("fiscalcodepa")[0]
        assert x[0].get("transfer")[0].get("IBAN")[0] == x[1].get("transfer")[0].get("iban")[0]

    pspNotifyPaymentBody = \
        pspNotifyPayment.get("request").get("soapenv:envelope").get("soapenv:body")[0].get("pspfn:pspnotifypaymentreq")[
            0]

    data = \
        paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[0].get(
            "data")[0]
    assert pspNotifyPaymentBody.get("idpsp")[0] == inoltroEsito["identificativoPsp"]
    assert pspNotifyPaymentBody.get("idbrokerpsp")[0] == inoltroEsito["identificativoIntermediario"]
    assert pspNotifyPaymentBody.get("idchannel")[0] == inoltroEsito["identificativoCanale"]
    assert float(pspNotifyPaymentBody.get("creditcardpayment")[0].get("fee")[0]) == float(
        inoltroEsito["importoTotalePagato"]) - float(data["paymentAmount"][0])
    assert pspNotifyPaymentBody.get("creditcardpayment")[0].get("rrn")[0] == str(inoltroEsito["RRN"])
    assert pspNotifyPaymentBody.get("creditcardpayment")[0].get("outcomepaymentgateway")[0] == str(
        inoltroEsito["esitoTransazioneCarta"])
    assert pspNotifyPaymentBody.get("creditcardpayment")[0].get("totalamount")[0] == str(
        inoltroEsito["importoTotalePagato"])
    assert pspNotifyPaymentBody.get("creditcardpayment")[0].get("timestampoperation")[0] in str(
        inoltroEsito["timestampOperazione"])
    assert pspNotifyPaymentBody.get("creditcardpayment")[0].get("authorizationcode")[0] == str(
        inoltroEsito["codiceAutorizzativo"])

    assert pspNotifyPaymentBody.get("paymentdescription")[0] == \
           paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[
               0].get(
               "data")[0].get("description")[0]
    assert pspNotifyPaymentBody.get("companyname")[0] == \
           paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[
               0].get(
               "data")[0].get("companyName")[0]

    assert pspNotifyPaymentBody.get("paymenttoken")[0] == \
           activateIOPaymentResponseXml.getElementsByTagName("paymentToken")[0].firstChild.data
    assert pspNotifyPaymentBody.get("fiscalcodepa")[0] == my_document.getElementsByTagName('fiscalCode')[
        0].firstChild.data
    assert pspNotifyPaymentBody.get("debtamount")[0] == \
           paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[
               0].get(
               "data")[0].get("paymentAmount")[0]
    assert pspNotifyPaymentBody.get("creditorreferenceid")[0] == \
           paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[
               0].get(
               "data")[0].get("creditorReferenceId")[0]

@step('save {primitive} response in {new_primitive}')
def step_impl(context, primitive, new_primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    setattr(context, new_primitive + RESPONSE, soap_response)


@then('{response} response is equal to {response_1} response')
def step_impl(context, response, response_1):
    soap_response = getattr(context, response + RESPONSE).content.decode('utf-8')
    soap_response_1 = getattr(context, response_1 + RESPONSE).content.decode('utf-8')
    
    assert soap_response == soap_response_1


@then('activateIOPayment response and pspNotifyPayment request are consistent with paypal')
def step_impl(context):
    # retrieve info from soap request of background step
    soap_request = getattr(context, "activateIOPayment")
    my_document = parseString(soap_request)
    notice_number = my_document.getElementsByTagName('noticeNumber')[0].firstChild.data

    inoltroEsito = getattr(context, "inoltroEsito/paypal")

    activateIOPaymentResponse = getattr(context, "activateIOPayment" + RESPONSE)
    activateIOPaymentResponseXml = parseString(activateIOPaymentResponse.content)

    paGetPaymentJson = requests.get(f"{utils.get_rest_mock_ec(context)}/history/{notice_number}/paGetPayment")
    pspNotifyPaymentJson = requests.get(
        f"{utils.get_rest_mock_ec(context)}/history/{notice_number}/pspNotifyPayment")

    paGetPayment = paGetPaymentJson.json()
    pspNotifyPayment = pspNotifyPaymentJson.json()

    # verify transfer list are equal
    paGetPaymentRes_transferList = \
        paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[0].get(
            "data")[0].get("transferList")
    pspNotifyPaymentReq_transferList = \
        pspNotifyPayment.get("request").get("soapenv:envelope").get("soapenv:body")[0].get("pspfn:pspnotifypaymentreq")[
            0].get("transferlist")

    paGetPaymentRes_transferList_sorted = sorted(paGetPaymentRes_transferList, key=lambda transfer: int(
        transfer.get("transfer")[0].get("idTransfer")[0]))
    pspNotifyPaymentReq_transferList_sorted = sorted(pspNotifyPaymentReq_transferList, key=lambda transfer: int(
        transfer.get("transfer")[0].get("idtransfer")[0]))

    mixed_list = zip(paGetPaymentRes_transferList_sorted, pspNotifyPaymentReq_transferList_sorted)
    for x in mixed_list:
        assert x[0].get("transfer")[0].get("idTransfer")[0] == x[1].get("transfer")[0].get("idtransfer")[0]
        assert x[0].get("transfer")[0].get("transferAmount")[0] == x[1].get("transfer")[0].get("transferamount")[0]
        assert x[0].get("transfer")[0].get("fiscalCodePA")[0] == x[1].get("transfer")[0].get("fiscalcodepa")[0]
        assert x[0].get("transfer")[0].get("IBAN")[0] == x[1].get("transfer")[0].get("iban")[0]

    pspNotifyPaymentBody = \
        pspNotifyPayment.get("request").get("soapenv:envelope").get("soapenv:body")[0].get("pspfn:pspnotifypaymentreq")[
            0]

    data = \
        paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[0].get(
            "data")[0]
    assert pspNotifyPaymentBody.get("idpsp")[0] == inoltroEsito["identificativoPsp"]
    assert pspNotifyPaymentBody.get("idbrokerpsp")[0] == inoltroEsito["identificativoIntermediario"]
    assert pspNotifyPaymentBody.get("idchannel")[0] == inoltroEsito["identificativoCanale"]
    assert pspNotifyPaymentBody.get("paymenttoken")[0] == \
           activateIOPaymentResponseXml.getElementsByTagName("paymentToken")[0].firstChild.data
    assert pspNotifyPaymentBody.get("paymentdescription")[0] == \
           paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[
               0].get(
               "data")[0].get("description")[0]
    assert pspNotifyPaymentBody.get("fiscalcodepa")[0] == my_document.getElementsByTagName('fiscalCode')[
        0].firstChild.data
    assert pspNotifyPaymentBody.get("companyname")[0] == \
           paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[
               0].get(
               "data")[0].get("companyName")[0]
    assert pspNotifyPaymentBody.get("creditorreferenceid")[0] == \
           paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[
               0].get(
               "data")[0].get("creditorReferenceId")[0]
    assert pspNotifyPaymentBody.get("debtamount")[0] == \
           paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[
               0].get(
               "data")[0].get("paymentAmount")[0]
    assert pspNotifyPaymentBody.get("paypalpayment")[0].get("transactionid")[0] == inoltroEsito["idTransazione"]
    assert pspNotifyPaymentBody.get("paypalpayment")[0].get("psptransactionid")[0] == inoltroEsito["idTransazionePsp"]
    assert float(pspNotifyPaymentBody.get("paypalpayment")[0].get("fee")[0]) == float(
        inoltroEsito["importoTotalePagato"]) - float(data["paymentAmount"][0])
    assert pspNotifyPaymentBody.get("paypalpayment")[0].get("timestampoperation")[0] in str(
        inoltroEsito["timestampOperazione"])


@step('idChannel with USE_NEW_FAULT_CODE=Y')
def step_impl(context):
    # TODO verify with api-config
    pass


@step("random idempotencyKey having {value} as idPSP in {primitive}")
def step_impl(context, value, primitive):
    xml = utils.manipulate_soap_action(getattr(context, primitive), "idempotencyKey",
                                       f"{value}_{str(random.randint(1000000000, 9999999999))}")
    setattr(context, primitive, xml)


@step("random noticeNumber in {primitive}")
def step_impl(context, primitive):
    xml = utils.manipulate_soap_action(getattr(context, primitive), "noticeNumber",
                                       f"30211{str(random.randint(1000000000000, 9999999999999))}")
    setattr(context, primitive, xml)


@given("nodo-dei-pagamenti has config parameter {param} set to {value}")
def step_impl(context, param, value):
    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get('nodo_cfg')

    name_query = 'query_config'
    name_macro = 'configurazione'
    
    selected_query = utils.query_json(context, name_query, name_macro)
    selected_query = selected_query.replace('?1', value).replace('?2', param)

    conn = db.getConnection(db_selected.get('host'), db_selected.get('database'),db_selected.get('user'),db_selected.get('password'),db_selected.get('port'))

    exec_query = db.executeQuery(conn, selected_query)
    if exec_query is not None:
        print(f'executed query: {exec_query}')



@Step("call the {elem} of {primitive} response as {name}")
def step_impl(context, elem, primitive, name):
    payload = getattr(context, primitive + RESPONSE)
    my_document = parseString(payload.content)
    if len(my_document.getElementsByTagName(elem)) > 0:
        elem_value = my_document.getElementsByTagName(elem)[0].firstChild.data
        setattr(context, name, elem_value)
    else:
        assert False


@then("verify the {elem} of the {primitive} response is equals to {name}")
def step_impl(context, elem, primitive, name):
    payload = getattr(context, primitive + RESPONSE)
    my_document = parseString(payload.content)
    if len(my_document.getElementsByTagName(elem)) > 0:
        elem_value = my_document.getElementsByTagName(elem)[0].firstChild.data
        target = getattr(context, name)
        print(f'check tag "{elem}" - expected: {target}, obtained: {elem_value}')
        assert elem_value == target
    else:
        assert False


@then("verify the {elem} of the {primitive} response is not equals to {name}")
def step_impl(context, elem, primitive, name):
    payload = getattr(context, primitive + RESPONSE)
    my_document = parseString(payload.content)
    if len(my_document.getElementsByTagName(elem)) > 0:
        elem_value = my_document.getElementsByTagName(elem)[0].firstChild.data
        target = getattr(context, name)
        print(f'check tag "{elem}" - expected: {target}, obtained: {elem_value}')
        assert elem_value != target
    else:
        assert False


@given("PSP waits {elem} of {primitive} expires")
def step_impl(context, elem, primitive):
    payload = getattr(context, primitive)
    my_document = parseString(payload)
    if len(my_document.getElementsByTagName(elem)) > 0:
        elem_value = my_document.getElementsByTagName(elem)[0].firstChild.data
        wait_time = int(elem_value) / 1000
        print(f"wait for: {wait_time} seconds")
        time.sleep(wait_time)
    else:
        assert False


@step("{mock:EcPsp} waits {number} minutes for expiration")
def step_impl(context, mock, number):
    seconds = int(number) * 60
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)

@step("wait {number} second for expiration")
def step_impl(context, number):
    seconds = int(number) 
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)


@step("{mock:EcPsp} waits {number} seconds for expiration")
def step_impl(context, mock, number):
    seconds = int(number)
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)


@step("idempotencyKey valid for {seconds} seconds")
def step_impl(context, seconds):
    # TODO with apiconfig:
    #  And field VALID_TO set to current time + <seconds> seconds in NODO_ONLINE.IDEMPOTENCY_CACHE table for
    #  sendPaymentOutcome record
    pass


@then(u"checks the value {value} in primitive {primitives} with the tag name {name_tag} of the record at column {column} of the table {table_name} retrived by the query {query_name} on db {db_name} under macro {name_macro}")
def step_impl(context, value, column, query_name, table_name, db_name, name_macro, primitives, name_tag):
    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get(db_name)

    conn = db.getConnection(db_selected.get('host'), db_selected.get('database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    selected_query = utils.query_json(context, query_name, name_macro).replace("columns", column).replace("table_name", table_name)
   
    exec_query = db.executeQuery(conn, selected_query)
    
    query_result = [t[0] for t in exec_query]
    print('query_result: ', query_result)

    if value == 'None':
        print('None')
        assert query_result[0] == None
    elif value == 'NotNone':
        print('NotNone')
        assert query_result[0] != None
    else:
        value = utils.replace_local_variables(value, context)
        split_value = [status.strip() for status in value.split(',')]
        if primitives != "notPrimitives":
            for i, elem in enumerate(split_value):
                new_elem = utils.find_tag(context, primitives, name_tag, elem)
                split_value[i] = new_elem

        print("value: ", split_value)
        for elem in split_value:
            assert elem in query_result

@then(u"verify one record for the table {table_name} retrivied by the query {query_name} on db {db_name} under macro {name_macro}")
def step_impl(context, query_name, table_name, db_name,name_macro):
    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get(db_name)
    column = "*"
    conn = db.getConnection(db_selected.get('host'), db_selected.get('database'),db_selected.get('user'),db_selected.get('password'),db_selected.get('port'))

    selected_query = utils.query_json(context, query_name, name_macro).replace("columns", column).replace("table_name", table_name)
   
    exec_query = db.executeQuery(conn, selected_query)

    assert len(exec_query) == 1

