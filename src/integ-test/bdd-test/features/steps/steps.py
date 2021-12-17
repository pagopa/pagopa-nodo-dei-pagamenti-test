from xml.dom.minidom import parseString, parse
import requests, random
from behave import *

from utils import requests_retry_session

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

@given('PA {new_old_versione} version')
def step_impl(context, new_old_versione):
    pass

@given('valid {type_soap_reques} soap-request')
def step_impl(context, type_soap_reques):
    """
        get valid PSP verifyPaymentNoticeReq
    """ 
    assert True

@given('random idempotencyKey and noticeNumber')
def step_impl(context):
    soap_request = getattr(context, "soap_request")
    my_document = parseString(context.soap_request)


@given('{elem} with {value} in verifyPaymentNoticeReq')
def step_impl(context, elem, value):
    TYPE_ELEMENT = 1 # dom element
    # TYPE_VALUE = 3 # dom value
    my_document = parseString(context.soap_request)
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
    setattr(context, "soap_request", my_document.toxml())


@given('{attribute} set {value} for {elem} in verifyPaymentNoticeReq')
def step_impl(context, attribute, value, elem):
    my_document = parseString(context.soap_request)
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    setattr(context, "soap_request", my_document.toxml())


# Scenario : Check valid URL in WSDL namespace
@when('psp sends {soap_action} to nodo-dei-pagamenti')
def step_impl(context, soap_action):
    headers = {'Content-Type': 'application/xml', "SOAPAction": soap_action }  # set what your server accepts
    url_nodo = get_soap_url_nodo(context)
    print("soap_request sent >>>", context.soap_request)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    set_nodo_response(context, nodo_response)
    assert (nodo_response.status_code == 200), f"status_code {nodo_response.status_code}"

@when('psp sends {soap_action} to nodo-dei-pagamenti application')
def step_impl(context, soap_action):
    headers = {'Content-Type': 'application/xml', "SOAPAction": soap_action }  # set what your server accepts
    url_nodo = get_soap_url_nodo(context)
    
    if soap_action == "verifyPaymentNotice":
        soap_request = context.soap_request_verify_payment_notice
    elif soap_action == "activatePaymentNotice":
        soap_request = context.soap_request_activate_payment_notice
    else:
        soap_request = "NO ALLOWED"
        
    print("soap_request sent >>>", soap_request)
    nodo_response = requests.post(url_nodo, soap_request, headers=headers)
    set_nodo_response(context, nodo_response)
    assert (nodo_response.status_code == 200), f"status_code {nodo_response.status_code}"


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


@when("IO sends an activateIOPaymentReq to nodo-dei-pagamenti")
def step_impl(context):
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = get_soap_url_nodo(context)
    print("soap_request sent >>>", context.soap_request)
    nodo_response = requests.post(url_nodo, context.soap_request, headers=headers)
    set_nodo_response(context, nodo_response)
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
    # retrieve info from soap request of background step
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


# Send receipt phase
@when("PSP sends sendPaymentOutcomeReq to nodo-dei-pagamenti using the token")
def step_impl(context):
    # step executed as PSP
    headers = {'Content-Type': 'application/xml'}  # set what your server accepts
    url_nodo = get_soap_url_nodo(context)
    paymentToken = context.config.userdata.get("test_configuration").get("paymentToken")

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
    send_payment_outcome = send_payment_outcome.replace("#paymentToken#", paymentToken)
    nodo_response = requests.post(url_nodo, send_payment_outcome, headers=headers)
    set_nodo_response(context, nodo_response)

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
    # paSendRTJson = requests.get(f"{get_rest_mock_ec(context)}/api/v1/history/{notice_number}/paSendRT")
    paSendRTJson  = requests_retry_session(session=s).get(f"{get_rest_mock_ec(context)}/api/v1/history/{notice_number}/paSendRT")
    paSendRT = paSendRTJson.json()

    print(paSendRT.get("request"))
    assert len(paSendRT.get("request").keys())

