import datetime

from email.policy import default
import json
from operator import contains
import os
import random
from sre_constants import ASSERT
import time
from xml.dom.minidom import parseString
import base64 as b64
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
                for sub_elem in sub_obj:
                    result_list.append("%s<%s>" % (line_padding, "paymentToken"))
                    result_list.append(json2xml(sub_elem, line_padding))
                    result_list.append("%s</%s>" % (line_padding, "paymentToken"))
                result_list.append("%s</%s>" % (line_padding, tag_name))
            else:
                result_list.append("%s<%s>" % (line_padding, tag_name))
                result_list.append(json2xml(sub_obj, "\t" + line_padding))
                result_list.append("%s</%s>" % (line_padding, tag_name))
            

        return "\n".join(result_list)

    return "%s%s" % (line_padding, json_obj)


s='{"paymentTokens": ["a3738f8bff1f4a32998fc197bd0a6b05"],"outcome": "OK","identificativoPsp": "#psp#","tipoVersamento": "BPAY","identificativoIntermediario": "#id_broker_psp#","identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#","pspTransactionId": "#psp_transaction_id#","totalAmount": 12,"fee": 2,"timestampOperation": "2033-04-23T18:25:43Z","additionalPaymentInformations": {"transactionId": "#transaction_id#","outcomePaymentGateway": "EFF","authorizationCode": "resOK"}}'
# s='{"paymentTokens": ["a3738f8bff1f4a32998fc197bd0a6b05"],"outcome": "OK","identificativoPsp": "#psp#","tipoVersamento": "BPAY","identificativoIntermediario": "#id_broker_psp#","identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#","pspTransactionId": "#psp_transaction_id#","totalAmount": 12,"fee": 2,"timestampOperation": "2033-04-23T18:25:43Z","additionalPaymentInformations": {"transactionId": "#transaction_id#","outcomePaymentGateway": "EFF","authorizationCode": "resOK"}}'
j = json.loads(s)
# print(json2xml(j))

xmlFields = json2xml(j)
xml = '<root>' + xmlFields + '</root>'

print(xml)

jsonNew = xmltodict.parse(xml)

jsonNew = jsonNew["root"]
if 'paymentTokens' in jsonNew.keys():
    jsonNew["paymentTokens"] = jsonNew["paymentTokens"]["paymentToken"]
    if type(jsonNew["paymentTokens"]) != list:
        l = list()
        l.append(jsonNew["paymentTokens"])
        jsonNew["paymentTokens"] = l
if 'totalAmount' in jsonNew.keys():
    jsonNew["totalAmount"] = float(jsonNew["totalAmount"])
if 'fee' in jsonNew.keys():
    jsonNew["fee"] = float(jsonNew["fee"])
jsonNew = json.dumps(jsonNew, indent=4)

def insert_bracket(string, index, addString):
     return string[:index] + addString + string[index:]

# l_tok_string = jsonNew.index('"paymentTokens": ') + len('"paymentTokens": ')

# if jsonNew[l_tok_string:l_tok_string + 1] != '[':
#     jsonNew = insert_bracket(jsonNew, l_tok_string,'[')
#     jsonNew = insert_bracket(jsonNew, jsonNew.index(token)+ len(token) + 1,']')

print(jsonNew)
