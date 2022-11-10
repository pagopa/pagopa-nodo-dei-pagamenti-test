import json
import xmltodict

def json2xml(json_obj, line_padding=""):
    result_list = list()
    json_obj_type = type(json_obj)
    if json_obj_type is list:
        for sub_elem in json_obj:
            result_list.append(json2xml(sub_elem, line_padding))
        return "\n".join(result_list)
    if json_obj_type is dict:
        for tag_name in json_obj:
            sub_obj = json_obj[tag_name]
            if type(sub_obj) is dict:
                result_list.append("%s<%s>" % (line_padding, tag_name))
                for key in sub_obj:
                    sub_sub_obj = sub_obj[key]
                    result_list.append("%s<%s>" % (line_padding, key))
                    result_list.append(json2xml(sub_sub_obj, "\t" + line_padding))
                    result_list.append("%s</%s>" % (line_padding, key))
                result_list.append("%s</%s>" % (line_padding, tag_name))
            elif type(sub_obj) is list:
                result_list.append("%s<%s>" % (line_padding, tag_name))
                if tag_name == 'paymentTokens':
                    for sub_elem in sub_obj:
                        result_list.append("%s<%s>" % (line_padding, "paymentToken"))
                        result_list.append(json2xml(sub_elem, line_padding))
                        result_list.append("%s</%s>" % (line_padding, "paymentToken"))
                if tag_name == 'positionslist':
                    for sub_elem in sub_obj:
                        result_list.append("%s<%s>" % (line_padding, "position"))
                        result_list.append(json2xml(sub_elem, line_padding))
                        result_list.append("%s</%s>" % (line_padding, "position"))
                result_list.append("%s</%s>" % (line_padding, tag_name))
            else:
                result_list.append("%s<%s>" % (line_padding, tag_name))
                result_list.append(json2xml(sub_obj, "\t" + line_padding))
                result_list.append("%s</%s>" % (line_padding, tag_name))
        return "\n".join(result_list)
    return "%s%s" % (line_padding, json_obj)


payload = """
    {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "#canale_versione_primitive_2#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                },
                "additionalPMInfo": {
                    "origin": "",
                    "user": {
                        "fullName": "John Doe",
                        "type": "F",
                        "fiscalCode": "JHNDOE00A01F205N",
                        "notificationEmail": "john.doe@mail.it",
                        "userId": 1234,
                        "userStatus": 11,
                        "userStatusDescription": "REGISTERED_SPID"
                    },
                    "walletItem": {
                        "idWallet": 1234,
                        "walletType": "CARD",
                        "enableableFunctions": [],
                        "pagoPa": false,
                        "onboardingChannel": "",
                        "favourite": false,
                        "createDate": "",
                        "info": {
                            "type": "",
                            "blurredNumber": "",
                            "holder": "Mario Rossi",
                            "expireMonth": "",
                            "expireYear": "",
                            "brand": "",
                            "issuerAbi": "",
                            "issuerName": "Intesa",
                            "label": "********234"
                        },
                        "authRequest": {
                            "authOutcome": "KO",
                            "guid": "77e1c83b-7bb0-437b-bc50-a7a58e5660ac",
                            "correlationId": "f864d987-3ae2-44a3-bdcb-075554495841",
                            "error": "Not Authorized",
                            "auth_code": "99"
                        }
                    }
                }
            }
    """

payload2 = """
    {}
    """
# print(type(payload2))
# print(payload2)
jsonDict = json.loads(payload2)
# print(type(jsonDict))
# print(jsonDict)
payload = json2xml(jsonDict)
# print(type(payload))
# print(payload)
payload = '<root>' + payload + '</root>'
# print(payload)

print("inizio step sender")

body = xmltodict.parse(payload)
# print(type(body))
# print(body)
body = body["root"]

if body != None:
    if ('paymentTokens' in body.keys()) and (body["paymentTokens"] != None and (type(body["paymentTokens"]) != str)):
        body["paymentTokens"] = body["paymentTokens"]["paymentToken"]
        if type(body["paymentTokens"]) != list:
            l = list()
            l.append(body["paymentTokens"])
            body["paymentTokens"] = l
    if ('totalAmount' in body.keys()) and (body["totalAmount"] != None):
        body["totalAmount"] = float(body["totalAmount"])
    if ('fee' in body.keys()) and (body["fee"] != None):
        body["fee"] = float(body["fee"])
    if ('positionslist' in body.keys()) and (body["positionslist"] != None):
        body["positionslist"] = body["positionslist"]["position"]
        if type(body["positionslist"]) != list:
            l = list()
            l.append(body["positionslist"])
            body["positionslist"] = l
    body = json.dumps(body, indent=4)
    print(type(body))
    #print(body)
    print("here")
else:
    body = """{}"""
    print(type(body))
    print(body)
    print("here1")