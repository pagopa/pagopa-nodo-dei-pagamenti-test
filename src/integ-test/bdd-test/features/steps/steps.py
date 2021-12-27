import random
import time
import requests
import utils as utils
from xml.dom.minidom import parseString
from behave import *


# Background
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


@given('EC {version} version')
def step_impl(context, version):
    pass


@given('initial {type_soap_request} soap-request')
def step_impl(context, type_soap_request):
    assert True


@given('valid {type_soap_request} soap-request')
def step_impl(context, type_soap_request):
    """
        get valid 
    """
    old_soap_request = getattr(context, "soap_request")
    new_soap_request = context.scenario.steps[0].text

    my_document = parseString(old_soap_request)
    # idempotency_key = my_document.getElementsByTagName('idempotencyKey')[0].firstChild.data
    fiscal_code = my_document.getElementsByTagName('fiscalCode')[0].firstChild.data
    notice_number = my_document.getElementsByTagName('noticeNumber')[0].firstChild.data

    if type_soap_request == "activatePaymentNoticeReq":
        new_soap_request = new_soap_request.replace("#creditor_institution_code#", fiscal_code)
        new_soap_request = new_soap_request.replace("#notice_number#", notice_number)
        new_soap_request = new_soap_request.replace('#idempotency_key#',
                                                    f"70000000001_{str(random.randint(1000000000, 9999999999))}")

    if type_soap_request == "sendPaymentOutcomeReq":
        new_soap_request = new_soap_request.replace("#payment_token#",
                                                    context.config.userdata.get("test_configuration").get(
                                                        "paymentToken"))

    setattr(context, "soap_request", new_soap_request)
    assert True


@given('{elem} with {value} in {action}')
def step_impl(context, elem, value, action):
    if action == "verifyPaymentNoticeReq" or action == "activatePaymentNoticeReq" :
        xml = utils.manipulate_soap_action(context.soap_request, elem, value)
        setattr(context, "soap_request", xml)
    elif action == "paVerifyPaymentNoticeRes":
        pa_verify_payment_notice_res = getattr(context, action)
        pa_verify_payment_notice_res = utils.manipulate_soap_action(pa_verify_payment_notice_res, elem, value)
        setattr(context, action, pa_verify_payment_notice_res)
        primitive = utils.get_primitive(action)
        response_status_code = utils.prepare_mock_requests(utils.get_rest_mock_ec(context), primitive,
                                                      pa_verify_payment_notice_res, override=True)
        assert response_status_code == 200
    else:
        assert False, "action not configured"


@given('{attribute} set {value} for {elem} in {action}')
def step_impl(context, attribute, value, elem, action):
    my_document = parseString(context.soap_request)
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    setattr(context, "soap_request", my_document.toxml())


# Scenario : Check valid URL in WSDL namespace
@when('psp sends {soap_action} to nodo-dei-pagamenti')
def step_impl(context, soap_action):
    headers = {'Content-Type': 'application/xml', "SOAPAction": soap_action}  # set what your server accepts
    url_nodo = utils.get_soap_url_nodo(context)
    print("nodo soap_request sent >>>", context.soap_request)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    utils.set_nodo_response(context, nodo_response)

    assert (nodo_response.status_code == 200), f"status_code {nodo_response.status_code}"


# When job <JOB_NAME> triggered    
@when('job {job_name} triggered after {seconds} seconds')
def step_impl(context, job_name, seconds):
    time.sleep(int(seconds))
    url_nodo = utils.get_rest_url_nodo(context)
    nodo_response = requests.get(f"{url_nodo}/jobs/trigger/{job_name}")
    assert nodo_response.status_code == 200


# Scenario: Execute activateIOPayment request
@then('check {tag} is {value}')
def step_impl(context, tag, value):
    nodo_response = context.config.userdata.get("test_configuration").get("soap_response")
    my_document = parseString(nodo_response.content)
    if len(my_document.getElementsByTagName('faultCode')) > 0:
        print(my_document.getElementsByTagName('faultCode')[0].firstChild.data)
        print(my_document.getElementsByTagName('faultString')[0].firstChild.data)
        print(my_document.getElementsByTagName('description')[0].firstChild.data)
    assert value == my_document.getElementsByTagName(tag)[0].firstChild.data

@given('if {tag} is {data} set {elem} to {value} in {action}')
def step_impl(context, tag, data, elem, value, action):
    soap_action = getattr(context, action)
    my_document = parseString(soap_action)
    if len(my_document.getElementsByTagName(tag)) > 0:
        if my_document.getElementsByTagName(tag)[0].firstChild is not None and my_document.getElementsByTagName(tag)[0].firstChild.data == data:
            soap_action = utils.manipulate_soap_action(soap_action, elem, value)
    setattr(context, action, soap_action)
    primitive = utils.get_primitive(action)
    response_status_code = utils.prepare_mock_requests(utils.get_rest_mock_ec(context), primitive, soap_action, override=True)
    assert response_status_code == 200

# @then('check {mock} receives {action} properly')
# def step_impl(context, mock, action):
#     rest_mock = utils.get_rest_mock_ec(context) if mock == "EC" else get_rest_mock_psp(context)
#
#     # retrieve info from soap request of background step
#     soap_request = getattr(context, "soap_request")
#     my_document = parseString(soap_request)
#     notice_number = my_document.getElementsByTagName('noticeNumber')[0].firstChild.data
#
#     responseJson = requests.get(f"{rest_mock}/api/v1/history/{notice_number}/{action}")
#     json = responseJson.json()
#     assert "request" in json and len(json.get("request").keys()) > 0


@when("IO sends an activateIOPaymentReq to nodo-dei-pagamenti")
def step_impl(context):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = utils.get_soap_url_nodo(context)
    print("nodo soap_request sent >>>", context.soap_request)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    utils.set_nodo_response(context, nodo_response)
    assert nodo_response.status_code == 200


@then("token exists and check")
def step_impl(context):
    nodo_response = context.config.userdata.get("test_configuration").get("soap_response")
    my_document = parseString(nodo_response.content)
    if len(my_document.getElementsByTagName('paymentToken')) > 0:
        paymentToken = my_document.getElementsByTagName('paymentToken')[0].firstChild.data
        test_configuration = context.config.userdata.get("test_configuration")
        if test_configuration is None:
            test_configuration = {}
        test_configuration["paymentToken"] = paymentToken
        test_configuration["payment_phase"] = True
        context.config.update_userdata({"test_configuration": test_configuration})
        # setattr(context, "paymentToken", paymentToken)
        assert 0 < len(paymentToken) < 36
    else:
        assert False


# Scenario: Execute nodoChiediInformazioniPagamento request
@given("the activate phase executed successfully")
def step_impl(context):
    # TODO investigate how to use the following steps
    # context.execute_steps(''' When IO sends an activateIOPaymentReq to nodo-dei-pagamenti ''')
    # context.execute_steps(''' Then token exists and check ''')
    assert "paymentToken" in context.config.userdata.get("test_configuration")


@when("WISP/PM sends an informazioniPagamento to nodo-dei-pagamenti using the token of the activate phase")
def step_impl(context):
    url_nodo = utils.get_rest_url_nodo(context)
    paymentToken = context.config.userdata.get("test_configuration").get("paymentToken")
    headers = {'Content-Type': 'application/json'}
    nodo_response = requests.get(f"{url_nodo}/informazioniPagamento?idPagamento={paymentToken}", headers=headers)
    assert nodo_response.status_code == 200


@then('verify the HTTP {status_code} response is {value}')
def step_impl(context, status_code, value):
    # at the moment, nothing to check
    assert True


# Scenario: Execute nodoInoltraEsitoPagamentoCarta request
@given("the payment phase executed successfully")
def step_impl(context):
    assert "payment_phase" in context.config.userdata.get("test_configuration")


@when("WISP/PM sends an inoltroEsito/Carta to nodo-dei-pagamenti using the token and PSP/Canale data")
def step_impl(context):
    url_nodo = utils.get_rest_url_nodo(context)
    paymentToken = context.config.userdata.get("test_configuration").get("paymentToken")
    headers = {'Content-Type': 'application/json'}
    body = {
        "idPagamento": paymentToken,
        "RRN": 0,
        "identificativoPsp": "40000000001",
        "tipoVersamento": "CP",
        "identificativoIntermediario": "40000000001",
        "identificativoCanale": "40000000001_06",
        "importoTotalePagato": 20.1,
        "timestampOperazione": "2012-04-23T18:25:43Z",
        "codiceAutorizzativo": "666666",
        "esitoTransazioneCarta": "ok"
    }
    print("nodo rest_request sent >>>", body)
    nodo_response = requests.post(f"{url_nodo}/inoltroEsito/carta", json=body, headers=headers)
    setattr(context, "rest_response", nodo_response)
    test_configuration = context.config.userdata.get("test_configuration")
    test_configuration["payment_notify_phase"] = True
    context.config.update_userdata(test_configuration)
    assert nodo_response.status_code == 200


@then("verify esito is OK")
def step_impl(context):
    node_response = getattr(context, "rest_response")
    json_response = node_response.json()
    assert json_response.get("esito") == "OK"


# Scenario: Verify consistency between activateIOPaymentResp and pspNotifyPaymentReq
@given("the payment notify phase executed successfully")
def step_impl(context):
    assert "payment_notify_phase" in context.config.userdata.get("test_configuration")


@then("activateIOPaymentResp and pspNotifyPaymentReq are consistent")
def step_impl(context):
    # retrieve info from soap request of background step
    soap_request = getattr(context, "soap_request")
    my_document = parseString(soap_request)
    notice_number = my_document.getElementsByTagName('noticeNumber')[0].firstChild.data

    paGetPaymentJson = requests.get(f"{utils.get_rest_mock_ec(context)}/api/v1/history/{notice_number}/paGetPayment")
    pspNotifyPaymentJson = requests.get(
        f"{utils.get_rest_mock_ec(context)}/api/v1/history/{notice_number}/pspNotifyPayment")

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


# Send receipt phase
@when("PSP sends sendPaymentOutcomeReq to nodo-dei-pagamenti using the token")
def step_impl(context):
    # step executed as PSP
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = utils.get_soap_url_nodo(context)
    payment_token = context.config.userdata.get("test_configuration").get("paymentToken")
    send_payment_outcome = """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
                <idPSP>40000000001</idPSP>
                <idBrokerPSP>40000000001</idBrokerPSP>
                <idChannel>40000000001_06</idChannel>
                <password>pwdpwdpwd</password>
                <paymentToken>#paymentToken#</paymentToken>
                <outcome>OK</outcome>
                <details>
                    <paymentMethod>creditCard</paymentMethod>
                    <paymentChannel>app</paymentChannel>
                    <fee>2.00</fee>
                    <payer>
                    <uniqueIdentifier>
                        <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
                        <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
                    </uniqueIdentifier>
                    <fullName>John Doe</fullName>
                    <streetName>street</streetName>
                    <civicNumber>12</civicNumber>
                    <postalCode>89020</postalCode>
                    <city>city</city>
                    <stateProvinceRegion>MI</stateProvinceRegion>
                    <country>IT</country>
                    <e-mail>john.doe@test.it</e-mail>
                    </payer>
                    <applicationDate>2021-10-01</applicationDate>
                    <transferDate>2021-10-02</transferDate>
              </details>
            </nod:sendPaymentOutcomeReq>
        </soapenv:Body>
      </soapenv:Envelope>
    """
    send_payment_outcome = send_payment_outcome.replace("#paymentToken#", payment_token)
    print("nodo soap_request sent >>>", send_payment_outcome)
    nodo_response = requests.post(url_nodo, send_payment_outcome, headers=headers)
    utils.set_nodo_response(context, nodo_response)

    test_configuration = context.config.userdata.get("test_configuration")
    if test_configuration is None:
        test_configuration = {}
    test_configuration["receipt_phase"] = True

    assert nodo_response.status_code == 200


@given("the sendPaymentOutcomeReq executed successfully")
def step_impl(context):
    assert "receipt_phase" in context.config.userdata.get("test_configuration")


@then("EC receives paSendRT request by nodo-dei-pagamenti")
def step_impl(context):
    s = requests.Session()
    # retrieve info from soap request of background step
    soap_request = getattr(context, "soap_request")
    my_document = parseString(soap_request)
    notice_number = my_document.getElementsByTagName('noticeNumber')[0].firstChild.data
    # paSendRTJson = requests.get(f"{utils.get_rest_mock_ec(context)}/api/v1/history/{notice_number}/paSendRT")
    paSendRTJson = utils.requests_retry_session(session=s).get(
        f"{utils.get_rest_mock_ec(context)}/api/v1/history/{notice_number}/paSendRT")
    paSendRT = paSendRTJson.json()
    print(paSendRT.get("request"))
    assert len(paSendRT.get("request").keys())


@given("{mock} replies to {destination} with the following {action}")
def step_impl(context, mock, destination, action):
    pa_verify_payment_notice_res = context.text
    pa_verify_payment_notice_res = str(pa_verify_payment_notice_res).replace("#fiscalCodePA#",
                                                                             context.config.userdata.get(
                                                                                 "global_configuration").get(
                                                                                 "creditor_institution_code"))
    setattr(context, "paVerifyPaymentNoticeRes", pa_verify_payment_notice_res)
    primitive = utils.get_primitive(action)
    response_status_code = utils.prepare_mock_requests(utils.get_rest_mock_ec(context), primitive,
                                                  pa_verify_payment_notice_res, override=True)
    assert response_status_code == 200


@given("{mock} wait for {sec} seconds at {action}")
def step_impl(context, mock, sec, action):
    """
            configure mock response
        """
    # TODO configure mock to wait x seconds at action
    pass
