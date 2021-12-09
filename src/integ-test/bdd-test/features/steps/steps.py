from xml.dom.minidom import parseString, parse
import requests, json
from behave import *


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
    url_nodo = get_soap_url_nodo(context)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    assert (nodo_response.status_code == 200)


# Scenario: Execute activateIOPayment request
@then('check {tag} is {value}')
def step_impl(context, tag, value):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = get_soap_url_nodo(context)
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
    url_nodo = get_soap_url_nodo(context)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    setattr(context, "soap_response", nodo_response)
    assert nodo_response.status_code == 200


@then("token exists and check")
def step_impl(context):
    my_document = parseString(context.soap_response.content)
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
    url_nodo = get_rest_url_nodo(context)
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
    print("")
    url_nodo = get_rest_url_nodo(context)
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
    soap_request = getattr(context, "soap_request")
    my_document = parseString(soap_request)
    notice_number = my_document.getElementsByTagName('noticeNumber')[0].firstChild.data

    paGetPaymentJson = requests.get(f"{get_rest_mock_ec(context)}/api/v1/history/{notice_number}/paGetPayment")
    pspNotifyPaymentJson = requests.get(f"{get_rest_mock_ec(context)}/api/v1/history/{notice_number}/pspNotifyPayment")

    paGetPayment = paGetPaymentJson.json()
    pspNotifyPayment = pspNotifyPaymentJson.json()

    # verify transfer list are equal
    paGetPaymentRes_transferList = paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[0].get("data")[0].get("transferList")
    pspNotifyPaymentReq_transferList = pspNotifyPayment.get("request").get("soapenv:envelope").get("soapenv:body")[0].get("pspfn:pspnotifypaymentreq")[0].get("transferlist")

    paGetPaymentRes_transferList_sorted = sorted(paGetPaymentRes_transferList, key=lambda transfer: int(transfer.get("transfer")[0].get("idTransfer")[0]))
    pspNotifyPaymentReq_transferList_sorted = sorted(pspNotifyPaymentReq_transferList, key=lambda transfer: int(transfer.get("transfer")[0].get("idtransfer")[0]))

    mixed_list = zip(paGetPaymentRes_transferList_sorted, pspNotifyPaymentReq_transferList_sorted)
    for x in mixed_list:
        assert x[0].get("transfer")[0].get("idTransfer")[0] == x[1].get("transfer")[0].get("idtransfer")[0]
        assert x[0].get("transfer")[0].get("transferAmount")[0] == x[1].get("transfer")[0].get("transferamount")[0]
        assert x[0].get("transfer")[0].get("fiscalCodePA")[0] == x[1].get("transfer")[0].get("fiscalcodepa")[0]
        assert x[0].get("transfer")[0].get("IBAN")[0] == x[1].get("transfer")[0].get("iban")[0]

