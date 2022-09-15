import datetime

from datetime import timedelta
import json
import os
import random
from sre_constants import ASSERT
import time
from xml.dom.minicompat import NodeList
from xml.dom.minidom import parseString
import base64 as b64
import json_operations as jo

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
        headers = {'Host': 'api.dev.platform.pagopa.it:443'}
        resp = requests.get(url, headers=headers, verify=False)
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
    date = datetime.date.today().strftime("%Y-%m-%d")
    timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
    yesterday_date = datetime.date.today() - datetime.timedelta(days=1)

    setattr(context, 'date', date)
    setattr(context, 'timedate', timedate)
    setattr(context, 'yesterday_date', yesterday_date)

    if len(payload) > 0:
        my_document = parseString(payload)
        idBrokerPSP = "70000000001"
        if len(my_document.getElementsByTagName('idBrokerPSP')) > 0:
            idBrokerPSP = my_document.getElementsByTagName('idBrokerPSP')[
                0].firstChild.data
        payload = payload.replace(
            '#idempotency_key#', f"{idBrokerPSP}_{str(random.randint(1000000000, 9999999999))}")


    if "#timedate#" in payload:
        payload = payload.replace('#timedate#', timedate)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)

    if '#yesterday_date#' in payload:
        payload = payload.replace('#yesterday_date#', yesterday_date)

    if "#ccp#" in payload:
        ccp = str(random.randint(100000000000000, 999999999999999))
        payload = payload.replace('#ccp#', ccp)
        setattr(context, "ccp", ccp)

    if "#iuv#" in payload:
        iuv = str(random.randint(100000000000000, 999999999999999))
        payload = payload.replace('#iuv#', iuv)
        setattr(context, "iuv", iuv)

    if '#notice_number#' in payload:
        notice_number = f"30211{str(random.randint(1000000000000, 9999999999999))}"
        payload = payload.replace('#notice_number#', notice_number)
        setattr(context, "iuv", notice_number[1:])

    if '#notice_number_old#' in payload:
        notice_number = f"31211{str(random.randint(1000000000000, 9999999999999))}"
        payload = payload.replace('#notice_number_old#', notice_number)
        setattr(context, "iuv", notice_number[1:])

    """
    if '$timedate+1' in payload:
        timedate = getattr(context, 'timedate')
        timedate = datetime.datetime.strptime(timedate, '%Y-%m-%dT%H:%M:%S.%f')
        timedate = timedate + datetime.timedelta(hours=1)
        timedate = timedate.strftime("%Y-%m-%dT%H:%M:%S.%f")
        payload = payload.replace('$timedate+1', timedate)
    """

    if '#carrello#' in payload:
        carrello = "77777777777" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#carrello#', carrello)
        setattr(context, 'carrello', carrello)

    if '#carrello1#' in payload:
        carrello1 = "77777777777" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + utils.random_s()
        payload = payload.replace('#carrello1#', carrello1)
        setattr(context, 'carrello1', carrello1)

    if '#secCarrello#' in payload:
        secCarrello = "77777777777" + "301" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#secCarrello#', secCarrello)
        setattr(context, 'secCarrello', secCarrello)

    if '#carrNOTENABLED#' in payload:
        carrNOTENABLED = "11111122223" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#carrNOTENABLED#', carrNOTENABLED)
        setattr(context, 'carrNOTENABLED', carrNOTENABLED)

    if '#thrCarrello#' in payload:
        thrCarrello = "77777777777" + "088" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#thrCarrello#', thrCarrello)
        setattr(context, 'thrCarrello', thrCarrello)

    if '#CARRELLO#' in payload:
        CARRELLO = "CARRELLO" + "-" + \
            str(getattr(context, 'date') + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])
        payload = payload.replace('#CARRELLO#', CARRELLO)
        setattr(context, 'CARRELLO', CARRELLO)

    if '#CARRELLO1#' in payload:
        CARRELLO1 = "CARRELLO" + str(random.randint(0, 100000))
        payload = payload.replace('#CARRELLO1#', CARRELLO1)
        setattr(context, 'CARRELLO1', CARRELLO1)

    if '#carrelloMills#' in payload:
        carrello = str(utils.current_milli_time())
        payload = payload.replace('#carrelloMills#', carrello)
        setattr(context, 'carrelloMills', carrello)

    if '$iuv' in payload:
        payload = payload.replace('$iuv', getattr(context, 'iuv'))

    if '$intermediarioPA' in payload:
        payload = payload.replace(
            '$intermediarioPA', getattr(context, 'intermediarioPA'))

    if '$identificativoFlusso' in payload:
        payload = payload.replace('$identificativoFlusso', getattr(
            context, 'identificativoFlusso'))

    if '$2ccp' in payload:
        payload = payload.replace('$2ccp', getattr(context, 'ccp2'))

    if '$rendAttachment' in payload:
        rendAttachment = getattr(context, 'rendAttachment')
        rendAttachment_b = bytes(rendAttachment, 'ascii')
        rendAttachment_uni = b64.b64encode(rendAttachment_b)
        rendAttachment_uni = f"{rendAttachment_uni}".split("'")[1]
        payload = payload.replace('$rendAttachment', rendAttachment_uni)

    if '#carrello#' in payload:
        carrello = "77777777777" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#carrello#', carrello)
        setattr(context, 'carrello', carrello)

    payload = utils.replace_context_variables(payload, context)
    payload = utils.replace_global_variables(payload, context)
    setattr(context, primitive, payload)


@given('RPT generation')
def step_impl(context):
    payload = context.text or ""
    date = datetime.date.today().strftime("%Y-%m-%d")
    timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]

    setattr(context, 'date', date)
    setattr(context, 'timedate', timedate)
    payload = utils.replace_local_variables(payload, context)
    payload = utils.replace_context_variables(payload, context)

    pa = context.config.userdata.get('global_configuration').get('codicePA')

    if "#iuv#" in payload:
        iuv = f"14{str(random.randint(1000000000000, 9999999999999))}"
        setattr(context, 'iuv', iuv)
        payload = payload.replace('#iuv#', iuv)

    if "#ccp#" in payload:
        ccp = str(int(time.time() * 1000))
        payload = payload.replace('#ccp#', ccp)
        setattr(context, "ccp", ccp)

    if "#ccp1#" in payload:
        ccp1 = str(utils.current_milli_time())
        payload = payload.replace('#ccp1#', ccp1)
        setattr(context, "1ccp", ccp1)

    if "#CCP#" in payload:
        CCP = 'CCP' + '-' + \
            str(date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])
        payload = payload.replace('#CCP#', CCP)
        setattr(context, "CCP", CCP)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)

    if "#timedate#" in payload:
        payload = payload.replace('#timedate#', timedate)

    if '#IuV#' in payload:
        iuv = '0' + str(random.randint(1000, 2000)) + str(random.randint(1000,
                                                                         2000)) + str(random.randint(1000, 2000)) + '00'
        payload = payload.replace('#IuV#', iuv)
        setattr(context, 'IuV', iuv)

    if '#iuv2#' in payload:
        iuv = 'IUV' + '-' + \
            str(date + '-' +
                datetime.datetime.now().strftime("%H:%M:%S.%f")[:-3])
        payload = payload.replace('#iuv2#', iuv)
        setattr(context, '2iuv', iuv)

    if '#IUV#' in payload:
        IUV = 'IUV' + str(random.randint(0, 10000)) + '-' + date + \
            datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
        payload = payload.replace('#IUV#', IUV)
        setattr(context, 'IUV', IUV)

    if '#idCarrello#' in payload:
        idCarrello = "09812374659" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#idCarrello#', idCarrello)
        setattr(context, 'idCarrello', idCarrello)

    if '#CARRELLO#' in payload:
        CARRELLO = "CARRELLO" + "-" + \
            str(date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3])
        payload = payload.replace('#CARRELLO#', CARRELLO)
        setattr(context, 'CARRELLO', CARRELLO)

    if '#carrello#' in payload:
        prova = utils.random_s()
        print('############', prova)
        carrello = pa + "302" + "0" + str(random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + prova
        print(carrello)
        payload = payload.replace('#carrello#', carrello)
        setattr(context, 'carrello', carrello)

    if '#carrello1#' in payload:
        carrello1 = pa + "311" + "0" + str(random.randint(1000, 2000)) + str(random.randint(
            1000, 2000)) + str(random.randint(1000, 2000)) + "00" + utils.random_s()
        payload = payload.replace('#carrello1#', carrello1)
        setattr(context, 'carrello1', carrello1)

    if '#secCarrello#' in payload:
        secCarrello = pa + "301" + "0" + str(random.randint(1000, 2000)) + str(random.randint(
            1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#secCarrello#', secCarrello)
        setattr(context, 'secCarrello', secCarrello)

    if '#thrCarrello#' in payload:
        thrCarrello = pa + "088" + "0" + str(random.randint(1000, 2000)) + str(random.randint(
            1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#thrCarrello#', thrCarrello)
        setattr(context, 'thrCarrello', thrCarrello)

    if '#carrNOTENABLED#' in payload:
        carrNOTENABLED = "11111122223" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#carrNOTENABLED#', carrNOTENABLED)
        setattr(context, 'carrNOTENABLED', carrNOTENABLED)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)

    payload = utils.replace_global_variables(payload, context)

    print('payload RPT: ', payload)

    setattr(context, 'rpt', payload)
    payload_b = bytes(payload, 'ascii')
    payload_uni = b64.b64encode(payload_b)
    payload = f"{payload_uni}".split("'")[1]

    setattr(context, 'rptAttachment', payload)


@given ('MB generation')
def step_impl(context):
    payload = context.text or ""

    payload = utils.replace_local_variables(payload, context)
    payload = utils.replace_context_variables(payload, context)

    if '#iubd#' in payload:
        iubd = ''+ str(random.randint(10000000, 20000000)) + str(random.randint(10000000, 20000000))
        payload = payload.replace('#iubd#', iubd)
        setattr(context, 'iubd', iubd)

    payload = utils.replace_global_variables(payload, context)

    payload_b = bytes(payload, 'ascii')
    payload_uni = b64.b64encode(payload_b)
    payload = f"{payload_uni}".split("'")[1]

    setattr(context, 'bollo', payload)


@given('RT{number:d} generation')
def step_impl(context, number):
    payload = context.text or ""
    payload = utils.replace_context_variables(payload, context)
    date = datetime.date.today().strftime("%Y-%m-%d")
    timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
    setattr(context, 'date', date)
    setattr(context, 'timedate', timedate)

    if "#timedate#" in payload:
        payload = payload.replace('#timedate#', timedate)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)

    if f"#IUV{number}#" in payload:
        IUV = str(utils.current_milli_time()) + '-' + str(random.randint(0, 100000))
        payload = payload.replace(f'#IUV{number}#', IUV)
        setattr(context, f'{number}IUV', IUV)

    if f"#ccp{number}#" in payload:
        ccp = str(utils.current_milli_time() + '1')
        payload = payload.replace(f'#ccp{number}#', ccp)
        setattr(context, f"{number}ccp", ccp)

    """
    if "#ccp#" in payload:
        ccp = str(random.randint(100000000000000, 999999999999999))
        payload = payload.replace('#ccp#', ccp)
        setattr(context, "ccp", ccp)
    """

    payload_b = bytes(payload, 'ascii')
    payload_uni = b64.b64encode(payload_b)
    payload = f"{payload_uni}".split("'")[1]
    print(payload)

    payload = utils.replace_local_variables(payload, context)
    payload = utils.replace_global_variables(payload, context)
    setattr(context, f'rt{number}Attachment', payload)


@given('RT generation')
def step_impl(context):
    payload = context.text or ""
    payload = utils.replace_global_variables(payload, context)
    payload = utils.replace_local_variables(payload, context)
    payload = utils.replace_context_variables(payload, context)
    date = datetime.date.today().strftime("%Y-%m-%d")
    timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
    setattr(context, 'date', date)
    setattr(context, 'timedate', timedate)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)

    if "#timedate#" in payload:
        payload = payload.replace('#timedate#', timedate)

    if "#ccp#" in payload:
        ccp = str(utils.current_milli_time())
        payload = payload.replace('#ccp#', ccp)
        setattr(context, "ccp", ccp)
    
    setattr(context, 'rt', payload)
    payload_b = bytes(payload, 'ascii')
    payload_uni = b64.b64encode(payload_b)
    payload = f"{payload_uni}".split("'")[1]
    print(payload)
    
    print("RT generato: ", payload)
    setattr(context, 'rtAttachment', payload)

@given('RR generation')
def step_impl(context):
    payload = context.text or ""
    payload = utils.replace_global_variables(payload, context)
    payload = utils.replace_local_variables(payload, context)
    payload = utils.replace_context_variables(payload, context)
    date = datetime.date.today().strftime("%Y-%m-%d")
    timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
    setattr(context, 'date', date)
    setattr(context, 'timedate', timedate)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)
    if "#timedate#" in payload:
        payload = payload.replace('#timedate#', timedate)
    
    payload_b = bytes(payload, 'ascii')
    payload_uni = b64.b64encode(payload_b)
    payload = f"{payload_uni}".split("'")[1]
    print(payload)
    
    print("RT generato: ", payload)
    setattr(context, 'rrAttachment', payload)

@given('ER generation')
def step_impl(context):
    payload = context.text or ""
    payload = utils.replace_global_variables(payload, context)
    payload = utils.replace_local_variables(payload, context)
    payload = utils.replace_context_variables(payload, context)
    date = datetime.date.today().strftime("%Y-%m-%d")
    timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
    setattr(context, 'date', date)
    setattr(context, 'timedate', timedate)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)
    if "#timedate#" in payload:
        payload = payload.replace('#timedate#', timedate)
    
    payload_b = bytes(payload, 'ascii')
    payload_uni = b64.b64encode(payload_b)
    payload = f"{payload_uni}".split("'")[1]
    print(payload)
    
    print("RT generato: ", payload)
    setattr(context, 'erAttachment', payload)


@given('RPT{number:d} generation')
def step_impl(context, number):
    payload = context.text or ""
    payload = utils.replace_context_variables(payload, context)
    date = datetime.date.today().strftime("%Y-%m-%d")
    timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
    setattr(context, 'date', date)
    setattr(context, 'timedate', timedate)

    if f"#intermediarioPA {number}#" in payload:
        intermediarioPA = "44444444444_05"
        payload = payload.replace(
            f'#intermediarioPA{number}#', intermediarioPA)
        setattr(context, f"intermediarioPA{number}", intermediarioPA)

    if f"#IUV{number}#" in payload:
        IUV = str(utils.current_milli_time()) + \
            '-' + str(random.randint(0, 10000))
        payload = payload.replace(f'#IUV{number}#', IUV)
        setattr(context, f'{number}IUV', IUV)

    if f"#ccp{number}#" in payload:
        ccp = str(int(time() * 1000))
        payload = payload.replace(f'#ccp{number}#', ccp)
        setattr(context, f"{number}ccp", ccp)

    if f"#CCP{number}#" in payload:
        ccp2 = str(utils.current_milli_time()) + '1'
        payload = payload.replace(f'#CCP{number}#', ccp2)
        setattr(context, f"{number}CCP", ccp2)

    if "#timedate#" in payload:
        payload = payload.replace('#timedate#', timedate)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)

    if f'#IuV{number}#' in payload:
        IuV = '0' + str(random.randint(1000, 2000)) + str(random.randint(1000,
                                                                         2000)) + str(random.randint(1000, 2000)) + '00'
        payload = payload.replace(f'#IuV{number}#', IuV)
        setattr(context, f'IuV{number}', IuV)

    if '$carrello' in payload:
        payload = payload.replace('$carrello', getattr(context, 'carrello'))

    if f'#iuv{number}#' in payload:
        iuv = "IUV" + str(random.randint(0, 10000)) + "-" + \
            datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S.%f")[:-3]
        payload = payload.replace(f'#iuv{number}#', iuv)
        setattr(context, f'{number}iuv', iuv)

    if '#idCarrello#' in payload:
        idCarrello = "09812374659" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#idCarrello#', idCarrello)
        setattr(context, 'idCarrello', idCarrello)

    if '#carrello#' in payload:
        carrello = "77777777777" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#carrello#', carrello)
        setattr(context, 'carrello', carrello)

    if '#carrello1#' in payload:
        carrello1 = "77777777777" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + utils.random_s()
        payload = payload.replace('#carrello1#', carrello1)
        setattr(context, 'carrello1', carrello1)

    if '#secCarrello#' in payload:
        secCarrello = "77777777777" + "301" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#secCarrello#', secCarrello)
        setattr(context, 'secCarrello', secCarrello)

    if '#thrCarrello#' in payload:
        thrCarrello = "77777777777" + "088" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#thrCarrello#', thrCarrello)
        setattr(context, 'thrCarrello', thrCarrello)

    if '#carrNOTENABLED#' in payload:
        carrNOTENABLED = "11111122223" + "311" + "0" + str(random.randint(1000, 2000)) + str(
            random.randint(1000, 2000)) + str(random.randint(1000, 2000)) + "00" + "-" + utils.random_s()
        payload = payload.replace('#carrNOTENABLED#', carrNOTENABLED)
        setattr(context, 'carrNOTENABLED', carrNOTENABLED)

    if "nodoVerificaRPT_IUV" in payload:
        nodoVerificaRPT = getattr(context, 'nodoVerificaRPT')
        my_document = parseString(nodoVerificaRPT.content)
        aux_digit = my_document.getElementsByTagName('AuxDigit')
        if aux_digit == '0' or aux_digit == '1' or aux_digit == '2':
            iuv = ''+random.randint(10000, 20000)+random.randint(10000,
                                                                 20000)+random.randint(10000, 20000)
        elif aux_digit == '3':
            # per pa_old
            iuv = '11' + (int)(random.randint(10000, 20000)) + \
                (int)(random.randint(10000, 20000)) + \
                (int)(random.randint(10000, 20000))
        payload = payload.replace('iuv', iuv)
        setattr(context, 'iuv', iuv)

    if "$ccp" in payload:
        ccp = ''+random.randint(10000, 20000)+random.randint(10000,
                                                             20000)+random.randint(10000, 20000)
        payload = payload.replace('ccp', ccp)
        setattr(context, "ccp", ccp)

    setattr(context, f'rpt{number}', payload)
    payload_b = bytes(payload, 'ascii')
    payload_uni = b64.b64encode(payload_b)
    payload = f"{payload_uni}".split("'")[1]
    print(payload)

    payload = utils.replace_local_variables(payload, context)
    payload = utils.replace_global_variables(payload, context)
    setattr(context, f'rpt{number}Attachment', payload)


@given('REND generation')
def step_impl(context):
    payload = context.text or ""
    payload = utils.replace_context_variables(payload, context)
    payload = utils.replace_local_variables(payload, context)
    payload = utils.replace_global_variables(payload, context)
    date = datetime.date.today().strftime("%Y-%m-%d")
    timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
    identificativoFlusso = date + context.config.userdata.get(
        "global_configuration").get("psp") + "-" + str(random.randint(0, 10000))
    iuv = "IUV" + str(random.randint(0, 10000)) + "-" + \
        datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S.%f")[:-3]
    setattr(context, 'date', date)
    setattr(context, 'timedate', timedate)
    setattr(context, 'identificativoFlusso', identificativoFlusso)
    setattr(context, 'iuv', iuv)

    if '#date#' in payload:
        payload = payload.replace('#date#', date)

    if '#timedate+1#' in payload:
        date = datetime.date.today() + datetime.timedelta(hours=1)
        date = date.strftime("%Y-%m-%d")
        timedate = date + datetime.datetime.now().strftime("T%H:%M:%S.%f")[:-3]
        payload = payload.replace('#timedate+1#', timedate)

    if "#timedate#" in payload:
        payload = payload.replace('#timedate#', timedate)

    if '#identificativoFlusso#' in payload:
        payload = payload.replace('#identificativoFlusso#', identificativoFlusso)

    if '#iuv#' in payload:
        payload = payload.replace('#iuv#', iuv)

    print("REND generata: ", payload)
    setattr(context, 'rendAttachment', payload)


@given('{elem} with {value} in {action}')
def step_impl(context, elem, value, action):
    # use - to skip
    if elem != "-":
        value = utils.replace_local_variables(value, context)
        value = utils.replace_context_variables(value, context)
        value = utils.replace_global_variables(value, context)
        xml = utils.manipulate_soap_action(
            getattr(context, action), elem, value)
        setattr(context, action, xml)

@given('replace {old_tag} tag in {action} with {new_tag}')
def step_impl(context, old_tag, new_tag, action):
    if old_tag != '-':
        my_document = parseString(getattr(context, action))
        tag = my_document.getElementsByTagName(old_tag)[0]
        tag.tagName = new_tag
        #print("provaprovaprova", my_document.toxml('UTF-8'), type(my_document))
        setattr(context, action, my_document.toxml())


@given('{attribute} set {value} for {elem} in {primitive}')
def step_impl(context, attribute, value, elem, primitive):
    my_document = parseString(getattr(context, primitive))
    element = my_document.getElementsByTagName(elem)[0]
    element.setAttribute(attribute, value)
    setattr(context, primitive, my_document.toxml())


@step('{sender} sends soap {soap_primitive} to {receiver}')
def step_impl(context, sender, soap_primitive, receiver):
    primitive = soap_primitive.split("_")[0]
    headers = {'Content-Type': 'application/xml', 'SOAPAction': primitive,
               'X-Forwarded-For': '10.82.39.148', 'Host': 'api.dev.platform.pagopa.it:443'}  # set what your server accepts
    url_nodo = utils.get_soap_url_nodo(context, primitive)
    print("url_nodo: ", url_nodo)
    print("nodo soap_request sent >>>", getattr(context, soap_primitive))
    print("headers: ", headers)
    soap_response = requests.post(url_nodo, getattr(
        context, soap_primitive), headers=headers, verify=False)
    print(soap_response.content)
    print(soap_response.status_code)
    setattr(context, soap_primitive + RESPONSE, soap_response)

    assert (soap_response.status_code ==
            200), f"status_code {soap_response.status_code}"


@when('job {job_name} triggered after {seconds} seconds')
def step_impl(context, job_name, seconds):
    seconds = utils.replace_local_variables(seconds, context)
    time.sleep(int(seconds))
    url_nodo = utils.get_rest_url_nodo(context)
    headers = {'Host': 'api.dev.platform.pagopa.it:443'}
    nodo_response = requests.get(
        f"{url_nodo}/jobs/trigger/{job_name}", headers=headers, verify=False)
    setattr(context, job_name + RESPONSE, nodo_response)


# verifica che il valore cercato corrisponda all'intera sottostringa del tag
@then('check {tag} is {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    value = utils.replace_local_variables(value, context)
    value = utils.replace_global_variables(value, context)
    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        if len(my_document.getElementsByTagName('faultCode')) > 0:
            print("fault code: ", my_document.getElementsByTagName(
                'faultCode')[0].firstChild.data)
            print("fault string: ", my_document.getElementsByTagName(
                'faultString')[0].firstChild.data)
            if my_document.getElementsByTagName('description'):
                print("description: ", my_document.getElementsByTagName(
                    'description')[0].firstChild.data)
        data = my_document.getElementsByTagName(tag)[0].firstChild.data
        print(f'check tag "{tag}" - expected: {value}, obtained: {data}')
        assert value == data
    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        founded_value = jo.get_value_from_key(json_response, tag)
        print(
            f'check tag "{tag}" - expected: {value}, obtained: {json_response.get(tag)}')
        assert str(founded_value) == value


# controlla che il valore value sia una sottostringa del contentuo del tag
@then('check substring {value} in {tag} content of {primitive} response')
def step_impl(context, tag, value, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    value = utils.replace_local_variables(value, context)
    value = utils.replace_global_variables(value, context)
    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        if len(my_document.getElementsByTagName('faultCode')) > 0:
            print("fault code: ", my_document.getElementsByTagName(
                'faultCode')[0].firstChild.data)
            print("fault string: ", my_document.getElementsByTagName(
                'faultString')[0].firstChild.data)
            if my_document.getElementsByTagName('description'):
                print("description: ", my_document.getElementsByTagName(
                    'description')[0].firstChild.data)
        data = my_document.getElementsByTagName(tag)[0].firstChild.data
        print(f'check tag "{tag}" - expected: {value}, obtained: {data}')
        assert value in data 
    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        founded_value = jo.get_value_from_key(json_response, tag)
        print(
            f'check tag "{tag}" - expected: {value}, obtained: {json_response.get(tag)}')
        assert value in str(founded_value)


@step('checks {tag} contains {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        nodeList= my_document.getElementsByTagName(tag)
        print(nodeList)
        values = [node.childNodes[0].nodeValue for node in nodeList]
        print(values)
        assert value in values



@then('check {tag} contains {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    value = utils.replace_local_variables(value, context)
    value = utils.replace_context_variables(value, context)
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
        json_response = jo.convert_json_values_toString(json_response)
        print('>>>>>>>>>>>>>>', json_response)
        find = jo.search_value(json_response, tag, value)
        print(tag)
        print(value)
        print(find)
        assert find


# TODO tag.sort in xml response
@then('check {tag} containsList {value} of {primitive} response')
def step_impl(context, tag, value, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        if len(my_document.getElementsByTagName('faultCode')) > 0:
            print("fault code: ", my_document.getElementsByTagName(
                'faultCode')[0].firstChild.data)
            print("fault string: ", my_document.getElementsByTagName(
                'faultString')[0].firstChild.data)
            if my_document.getElementsByTagName('description'):
                print("description: ", my_document.getElementsByTagName(
                    'description')[0].firstChild.data)
        data = my_document.getElementsByTagName(tag)[0].firstChild.data
        print(f'check tag "{tag}" - expected: {value}, obtained: {data}')
        assert value in data
    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        print("value", value)
        json_response.get(tag).sort()
        print("tag", json_response.get(tag))
        assert str(json_response.get(tag)) == value


@then('check {tag} field exists in {primitive} response')
def step_impl(context, tag, primitive):
    soap_response = getattr(context, primitive + RESPONSE)

    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        assert len(my_document.getElementsByTagName(tag)) > 0

    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        find = jo.search_tag(json_response, tag)
        assert find


@then('check {tag} field not exists in {primitive} response')
def step_impl(context, tag, primitive):
    soap_response = getattr(context, primitive + RESPONSE)
    if 'xml' in soap_response.headers['content-type']:
        my_document = parseString(soap_response.content)
        assert len(my_document.getElementsByTagName(tag)) == 0
    else:
        node_response = getattr(context, primitive + RESPONSE)
        json_response = node_response.json()
        find = jo.search_tag(json_response, tag)
        assert not find


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
    rest_mock = utils.get_rest_mock_ec(
        context) if mock == "EC" else utils.get_rest_mock_psp(context)

    notice_number = utils.replace_local_variables(
        context.text, context).strip()

    s = requests.Session()
    responseJson = utils.requests_retry_session(session=s).get(
        f"{rest_mock}/history/{notice_number}/{primitive}")
    json = responseJson.json()
    assert "request" in json and len(json.get("request").keys()) > 0


@then(u'check {mock:EcPsp} receives {primitive} {status:ProperlyNotProperly} with noticeNumber {notice_number}')
def step_impl(context, mock, primitive, status, notice_number):
    rest_mock = utils.get_rest_mock_ec(
        context) if mock == "EC" else utils.get_rest_mock_psp(context)
    if "$" in notice_number:
        notice_number = utils.replace_local_variables(notice_number, context)

    if status == "properly":
        json, status_code = utils.get_history(
            rest_mock, notice_number, primitive)
        setattr(context, primitive, json)
        assert "request" in json and len(json.get("request").keys()) > 0
    else:
        try:
            json, status_code = utils.get_history(
                rest_mock, notice_number, primitive)
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


@then(u'check {mock:EcPsp} receives {primitive} properly having in the transfer with idTransfer {idTransfer} the same {elem} of {other_primitive}')
def step_impl(context, mock, primitive, idTransfer, elem, other_primitive):
    _assert = False
    soap_action = getattr(context, other_primitive)
    my_document = parseString(soap_action)
    map = {}
    for transfer in my_document.getElementsByTagName("transfer"):
        if transfer.getElementsByTagName("idTransfer")[0].firstChild.nodeValue == idTransfer:
            map[idTransfer] = transfer.getElementsByTagName(
                elem)[0].firstChild.nodeValue

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
    phase = (
        [phase for phase in context.feature.scenarios if name in phase.name] or [None])[0]
    text_step = ''.join(
        [step.keyword + " " + step.name + "\n\"\"\"\n" + (step.text or '') + "\n\"\"\"\n" for step in phase.steps])
    context.execute_steps(text_step)


@when(u'{sender} sends rest {method:Method} {service} to {receiver}')
def step_impl(context, sender, method, service, receiver):
    # TODO get url according to receiver
    url_nodo = utils.get_rest_url_nodo(context)

    headers = {'Content-Type': 'application/json',
               'Host': 'api.dev.platform.pagopa.it:443'}
    body = context.text or ""
    print(body)

    body = utils.replace_local_variables(body, context)
    body = utils.replace_context_variables(body, context)
    body = utils.replace_global_variables(body, context)
    print(body)
    service = utils.replace_local_variables(service, context)
    service = utils.replace_context_variables(service, context)
    print(f"{url_nodo}/{service}")
    if len(body) > 1:
        json_body = json.loads(body)
    else:
        json_body = None

    nodo_response = requests.request(method, f"{url_nodo}/{service}", headers=headers,
                                     json=json_body, verify=False)

    setattr(context, service.split('?')[0], json_body)
    setattr(context, service.split('?')[0] + RESPONSE, nodo_response)
    print(service.split('?')[0] + RESPONSE)
    print(nodo_response.content)


@then('verify the HTTP status code of {action} response is {value}')
def step_impl(context, action, value):
    print(
        f'HTTP status expected: {value} - obtained:{getattr(context, action + RESPONSE).status_code}')
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
        pa_verify_payment_notice_res = pa_verify_payment_notice_res.replace(
            '$iuv', getattr(context, 'iuv'))

    setattr(context, primitive, pa_verify_payment_notice_res)
    print(pa_verify_payment_notice_res)
    if mock == 'EC':
        print(utils.get_soap_mock_ec(context))
        response_status_code = utils.save_soap_action(utils.get_soap_mock_ec(context), primitive,
                                                      pa_verify_payment_notice_res, override=True)
    else:
        print(utils.get_soap_mock_psp(context))
        response_status_code = utils.save_soap_action(utils.get_soap_mock_psp(context), primitive,
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
    notice_number = my_document.getElementsByTagName('noticeNumber')[
        0].firstChild.data

    inoltroEsito = getattr(context, "inoltroEsito/carta")

    activateIOPaymentResponse = getattr(
        context, "activateIOPayment" + RESPONSE)
    activateIOPaymentResponseXml = parseString(
        activateIOPaymentResponse.content)

    headers = {'Host': 'api.dev.platform.pagopa.it:443'}

    paGetPaymentJson = requests.get(
        f"{utils.get_rest_mock_ec(context)}/history/{notice_number}/paGetPayment", headers=headers)
    pspNotifyPaymentJson = requests.get(
        f"{utils.get_rest_mock_ec(context)}/history/{notice_number}/pspNotifyPayment", headers=headers)

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

    mixed_list = zip(paGetPaymentRes_transferList_sorted,
                     pspNotifyPaymentReq_transferList_sorted)
    for x in mixed_list:
        assert x[0].get("transfer")[0].get("idTransfer")[
            0] == x[1].get("transfer")[0].get("idtransfer")[0]
        assert x[0].get("transfer")[0].get("transferAmount")[
            0] == x[1].get("transfer")[0].get("transferamount")[0]
        assert x[0].get("transfer")[0].get("fiscalCodePA")[
            0] == x[1].get("transfer")[0].get("fiscalcodepa")[0]
        assert x[0].get("transfer")[0].get("IBAN")[
            0] == x[1].get("transfer")[0].get("iban")[0]

    pspNotifyPaymentBody = \
        pspNotifyPayment.get("request").get("soapenv:envelope").get("soapenv:body")[0].get("pspfn:pspnotifypaymentreq")[
            0]

    data = \
        paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[0].get(
            "data")[0]
    assert pspNotifyPaymentBody.get(
        "idpsp")[0] == inoltroEsito["identificativoPsp"]
    assert pspNotifyPaymentBody.get("idbrokerpsp")[
        0] == inoltroEsito["identificativoIntermediario"]
    assert pspNotifyPaymentBody.get(
        "idchannel")[0] == inoltroEsito["identificativoCanale"]
    assert float(pspNotifyPaymentBody.get("creditcardpayment")[0].get("fee")[0]) == float(
        inoltroEsito["importoTotalePagato"]) - float(data["paymentAmount"][0])
    assert pspNotifyPaymentBody.get("creditcardpayment")[0].get("rrn")[
        0] == str(inoltroEsito["RRN"])
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
        activateIOPaymentResponseXml.getElementsByTagName("paymentToken")[
        0].firstChild.data
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
    print(new_primitive + RESPONSE)
    setattr(context, new_primitive + RESPONSE, soap_response)


@step('saving {primitive} request in {new_primitive}')
def step_impl(context, primitive, new_primitive):
    soap_request = getattr(context, primitive)
    setattr(context, new_primitive, soap_request)


@then('{response} response is equal to {response_1} response')
def step_impl(context, response, response_1):
    soap_response = getattr(
        context, response + RESPONSE).content.decode('utf-8')
    soap_response_1 = getattr(context, response_1 +
                              RESPONSE).content.decode('utf-8')

    assert soap_response == soap_response_1


@then('activateIOPayment response and pspNotifyPayment request are consistent with paypal')
def step_impl(context):
    # retrieve info from soap request of background step
    soap_request = getattr(context, "activateIOPayment")
    my_document = parseString(soap_request)
    notice_number = my_document.getElementsByTagName('noticeNumber')[
        0].firstChild.data

    inoltroEsito = getattr(context, "inoltroEsito/paypal")

    activateIOPaymentResponse = getattr(
        context, "activateIOPayment" + RESPONSE)
    activateIOPaymentResponseXml = parseString(
        activateIOPaymentResponse.content)

    headers = {'Host': 'api.dev.platform.pagopa.it:443'}

    paGetPaymentJson = requests.get(
        f"{utils.get_rest_mock_ec(context)}/history/{notice_number}/paGetPayment", headers=headers)
    pspNotifyPaymentJson = requests.get(
        f"{utils.get_rest_mock_ec(context)}/history/{notice_number}/pspNotifyPayment", headers=headers)

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

    mixed_list = zip(paGetPaymentRes_transferList_sorted,
                     pspNotifyPaymentReq_transferList_sorted)
    for x in mixed_list:
        assert x[0].get("transfer")[0].get("idTransfer")[
            0] == x[1].get("transfer")[0].get("idtransfer")[0]
        assert x[0].get("transfer")[0].get("transferAmount")[
            0] == x[1].get("transfer")[0].get("transferamount")[0]
        assert x[0].get("transfer")[0].get("fiscalCodePA")[
            0] == x[1].get("transfer")[0].get("fiscalcodepa")[0]
        assert x[0].get("transfer")[0].get("IBAN")[
            0] == x[1].get("transfer")[0].get("iban")[0]

    pspNotifyPaymentBody = \
        pspNotifyPayment.get("request").get("soapenv:envelope").get("soapenv:body")[0].get("pspfn:pspnotifypaymentreq")[
            0]

    data = \
        paGetPayment.get("response").get("soapenv:Envelope").get("soapenv:Body")[0].get("paf:paGetPaymentRes")[0].get(
            "data")[0]
    assert pspNotifyPaymentBody.get(
        "idpsp")[0] == inoltroEsito["identificativoPsp"]
    assert pspNotifyPaymentBody.get("idbrokerpsp")[
        0] == inoltroEsito["identificativoIntermediario"]
    assert pspNotifyPaymentBody.get(
        "idchannel")[0] == inoltroEsito["identificativoCanale"]
    assert pspNotifyPaymentBody.get("paymenttoken")[0] == \
        activateIOPaymentResponseXml.getElementsByTagName("paymentToken")[
        0].firstChild.data
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
    assert pspNotifyPaymentBody.get("paypalpayment")[0].get(
        "transactionid")[0] == inoltroEsito["idTransazione"]
    assert pspNotifyPaymentBody.get("paypalpayment")[0].get(
        "psptransactionid")[0] == inoltroEsito["idTransazionePsp"]
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
    value = utils.replace_local_variables(value, context)
    value = utils.replace_context_variables(value, context)
    value = utils.replace_global_variables(value, context)

    xml = utils.manipulate_soap_action(getattr(context, primitive), "idempotencyKey",
                                       f"{value}_{str(random.randint(1000000000, 9999999999))}")
    setattr(context, primitive, xml)


@step("random noticeNumber in {primitive}")
def step_impl(context, primitive):
    xml = utils.manipulate_soap_action(getattr(context, primitive), "noticeNumber",
                                       f"30211{str(random.randint(1000000000000, 9999999999999))}")
    setattr(context, primitive, xml)


@step("nodo-dei-pagamenti has config parameter {param} set to {value}")
def step_impl(context, param, value):
    db_selected = context.config.userdata.get(
        "db_configuration").get('nodo_cfg')
    selected_query = utils.query_json(context, 'update_config', 'configurations').replace(
        'value', value).replace('key', param)
    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    setattr(context, param, value)

    exec_query = db.executeQuery(conn, selected_query)
    if exec_query is not None:
        print(f'executed query: {exec_query}')

    db.closeConnection(conn)
    headers = {'Host': 'api.dev.platform.pagopa.it:443'}
    refresh_response = requests.get(utils.get_refresh_config_url(
        context), headers=headers, verify=False)
    time.sleep(5)
    print('refresh_response: ',refresh_response)
    assert refresh_response.status_code == 200


@step("refresh job {job_name} triggered after 10 seconds")
def step_impl(context, job_name):
    url_nodo = utils.get_rest_url_nodo(context)
    headers = {'Host': 'api.dev.platform.pagopa.it:443'}
    nodo_response = requests.get(
        f"{url_nodo}/config/refresh/{job_name}", headers=headers, verify=False)
    setattr(context, job_name + RESPONSE, nodo_response)
    refresh_response = requests.get(utils.get_refresh_config_url(
        context), headers=headers, verify=False)
    time.sleep(10)
    assert refresh_response.status_code == 200


@step("update through the query {query_name} with date {date} under macro {macro} on db {db_name}")
def step_impl(context, query_name, date, macro, db_name):
    db_selected = context.config.userdata.get("db_configuration").get(db_name)

    if date == 'Today':
        date = str(datetime.datetime.today())

    selected_query = utils.query_json(
        context, query_name, macro).replace('date', date)
    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    exec_query = db.executeQuery(conn, selected_query)
    db.closeConnection(conn)


@then("restore initial configurations")
def step_impl(context):
    db_selected = context.config.userdata.get(
        "db_configuration").get('nodo_cfg')
    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    config_dict = getattr(context, 'configurations')
    for key, value in config_dict.items():
        selected_query = utils.query_json(context, 'update_config', 'configurations').replace(
            'value', value).replace('key', key)
        db.executeQuery(conn, selected_query)

    db.closeConnection(conn)
    headers = {'Host': 'api.dev.platform.pagopa.it:443'}
    refresh_response = requests.get(utils.get_refresh_config_url(
        context), headers=headers, verify=False)
    assert refresh_response.status_code == 200


@step("execution query {query_name} to get value on the table {table_name}, with the columns {columns} under macro {macro} with db name {db_name}")
def step_impl(context, query_name, macro, db_name, table_name, columns):
    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get(db_name)

    selected_query = utils.query_json(context, query_name, macro).replace(
        "columns", columns).replace("table_name", table_name)
    selected_query = utils.replace_local_variables(selected_query, context)

    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    exec_query = db.executeQuery(conn, selected_query)
    if exec_query is not None:
        print(f'executed query: {exec_query}')
    setattr(context, query_name, exec_query)


# step per salvare nel context una variabile key recuperata dal db tramite query query_name
@step("through the query {query_name} retrieve param {param} at position {position:d} and save it under the key {key}")
def step_impl(context, query_name, param, position, key):
    result_query = getattr(context, query_name)
    print(f'{query_name}: {result_query}')
    selected_element = result_query[0][position]
    print(f'{param}: {selected_element}')
    setattr(context, key, selected_element)


@step("through the query {query_name} retrieve param {param} at position {position:d} in the row {row_number:d} and save it under the key {key}")
def step_impl(context, query_name, param, position, row_number, key):
    result_query = getattr(context, query_name)
    print(f'{query_name}: {result_query}')
    selected_element = result_query[row_number][position]
    print(f'{param}: {selected_element}')
    setattr(context, key, selected_element)


@step("through the query {query_name} retrieve xml {xml} at position {position:d} and save it under the key {key}")
def step_impl(context, query_name, xml, position, key):
    result_query = getattr(context, query_name)
    print(f'{query_name}: {result_query}')
    selected_element = result_query[0][position]
    selected_element = selected_element.read()
    selected_element = selected_element.decode("utf-8")
    print(f'{xml}: {selected_element}')
    setattr(context, key, selected_element)
    

@step("with the query {query_name1} check assert beetwen elem {elem1} in position {position1:d} and elem {elem2} with position {position2:d} of the query {query_name2}")
def stemp_impl(context, query_name1, elem1, position1, elem2, query_name2, position2):
    result_query1 = getattr(context, query_name1)
    result_query2 = getattr(context, query_name2)
    print("elem1: ", result_query1[0][position1])
    print("elem2: ", result_query2[0][position2])

    assert result_query1[0][position1] == result_query2[0][position2]


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
        print(
            f'check tag "{elem}" - expected: {target}, obtained: {elem_value}')
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
        print(
            f'check tag "{elem}" - expected: {target}, obtained: {elem_value}')
        assert elem_value != target
    else:
        assert False


@given("PSP waits {elem} of {primitive} expires")
def step_impl(context, elem, primitive):
    payload = getattr(context, primitive)
    my_document = parseString(payload)
    if len(my_document.getElementsByTagName(elem)) > 0:
        elem_value = my_document.getElementsByTagName(elem)[0].firstChild.data
        wait_time = (int(elem_value)+200) / 1000
        print(f"wait for: {wait_time} seconds")
        time.sleep(wait_time)
    else:
        assert False


@step("{mock:EcPsp} waits {number} minutes for expiration")
def step_impl(context, mock, number):
    seconds = float(number) * 60
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)


@step("wait {number} seconds for expiration")
def step_impl(context, number):
    seconds = float(number)
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)


@step("{mock:EcPsp} waits {number} seconds for expiration")
def step_impl(context, mock, number):
    seconds = float(number)
    print(f"wait for: {seconds} seconds")
    time.sleep(seconds)


@step("idempotencyKey valid for {seconds} seconds")
def step_impl(context, seconds):
    # TODO with apiconfig:
    #  And field VALID_TO set to current time + <seconds> seconds in NODO_ONLINE.IDEMPOTENCY_CACHE table for
    #  sendPaymentOutcome record
    pass


@step(u"checks the value {value} of the record at column {column} of the table {table_name} retrived by the query {query_name} on db {db_name} under macro {name_macro}")
def step_impl(context, value, column, query_name, table_name, db_name, name_macro):
    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get(db_name)

    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    selected_query = utils.query_json(context, query_name, name_macro).replace(
        "columns", column).replace("table_name", table_name)
    print(selected_query)
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
        if 'iuv' in value:
            value = getattr(context, 'iuv')
        value = utils.replace_global_variables(value, context)
        value = utils.replace_local_variables(value, context)
        value = utils.replace_context_variables(value, context)
        split_value = [status.strip() for status in value.split(',')]
        for i, elem in enumerate(query_result):
            if isinstance(elem, str) and elem.isdigit():
                query_result[i] = float(elem)
            elif isinstance(elem, datetime.date):
                query_result[i] = elem.strftime('%Y-%m-%d')

        for i, elem in enumerate(split_value):
            if utils.isFloat(elem) or elem.isdigit():
                split_value[i] = float(elem)

        print("value: ", split_value)
        for elem in split_value:
            assert elem in query_result, f"check expected element: {value}, obtained: {query_result}"

    db.closeConnection(conn)


@step("update through the query {query_name} of the table {table_name} the parameter {param} with {value}, with where condition {where_condition} and where value {valore} under macro {macro} on db {db_name}")
def step_impl(context, query_name, table_name, param, value, where_condition, valore, macro, db_name):
    db_selected = context.config.userdata.get("db_configuration").get(db_name)
    selected_query = utils.query_json(context, query_name, macro).replace('table_name', table_name).replace(
        'param', param).replace('value', value).replace('where_condition', where_condition).replace('valore', valore)
    selected_query = utils.replace_local_variables(selected_query, context)
    selected_query = utils.replace_context_variables(selected_query, context)
    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))
    exec_query = db.executeQuery(conn, selected_query)
    db.closeConnection(conn)


@step("generic update through the query {query_name} of the table {table_name} the parameter {param}, with where condition {where_condition} under macro {macro} on db {db_name}")
def step_impl(context, query_name, table_name, param, where_condition, macro, db_name):
    db_selected = context.config.userdata.get("db_configuration").get(db_name)
    selected_query = utils.query_json(context, query_name, macro).replace(
        'table_name', table_name).replace('param', param).replace('where_condition', where_condition)
    selected_query = utils.replace_local_variables(selected_query, context)
    selected_query = utils.replace_context_variables(selected_query, context)
    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))
    exec_query = db.executeQuery(conn, selected_query)
    db.closeConnection(conn)


@step(u"check datetime plus number of date {number} of the record at column {column} of the table {table_name} retrived by the query {query_name} on db {db_name} under macro {name_macro}")
def step_impl(context, column, query_name, table_name, db_name, name_macro, number):
    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get(db_name)
    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    if number == 'default_token_duration_validity_millis':
        default = int(
            getattr(context, 'default_token_duration_validity_millis')) / 60000
        value = (datetime.datetime.today() +
                 datetime.timedelta(minutes=default)).strftime('%Y-%m-%d %H:%M')
        selected_query = utils.query_json(context, query_name, name_macro).replace(
            "columns", column).replace("table_name", table_name)
        exec_query = db.executeQuery(conn, selected_query)
        query_result = [t[0] for t in exec_query]
        print('query_result: ', query_result)
        elem = query_result[0].strftime('%Y-%m-%d %H:%M')
    elif number == 'default_idempotency_key_validity_minutes':
        default = int(
            getattr(context, 'default_idempotency_key_validity_minutes'))
        value = (datetime.datetime.today() +
                 datetime.timedelta(minutes=default)).strftime('%Y-%m-%d %H:%M')
        selected_query = utils.query_json(context, query_name, name_macro).replace(
            "columns", column).replace("table_name", table_name)
        exec_query = db.executeQuery(conn, selected_query)
        query_result = [t[0] for t in exec_query]
        print('query_result: ', query_result)
        elem = query_result[0].strftime('%Y-%m-%d %H:%M')
    elif number == 'Today':
        value = (datetime.datetime.today()).strftime('%Y-%m-%d')
        selected_query = utils.query_json(context, query_name, name_macro).replace(
            "columns", column).replace("table_name", table_name)
        exec_query = db.executeQuery(conn, selected_query)
        query_result = [t[0] for t in exec_query]
        print('query_result: ', query_result)
        elem = query_result[0].strftime('%Y-%m-%d')
    elif 'minutes:' in number:
        min = int(number.split(':')[1]) / 60000
        value = (datetime.datetime.today() +
                 datetime.timedelta(minutes=min)).strftime('%Y-%m-%d %H:%M')
        selected_query = utils.query_json(context, query_name, name_macro).replace(
            "columns", column).replace("table_name", table_name)
        exec_query = db.executeQuery(conn, selected_query)
        query_result = [t[0] for t in exec_query]
        print('query_result: ', query_result)
        elem = query_result[0].strftime('%Y-%m-%d %H:%M')
    else:
        number = int(number)
        value = (datetime.datetime.today() +
                 datetime.timedelta(days=number)).strftime('%Y-%m-%d')
        selected_query = utils.query_json(context, query_name, name_macro).replace(
            "columns", column).replace("table_name", table_name)
        exec_query = db.executeQuery(conn, selected_query)
        query_result = [t[0] for t in exec_query]
        print('query_result: ', query_result)
        elem = query_result[0].strftime('%Y-%m-%d')

    db.closeConnection(conn)

    print(f"check expected element: {value}, obtained: {elem}")
    assert elem == value


@step(u"verify datetime plus number of minutes {number} of the record at column {column} of the table {table_name} retrived by the query {query_name} on db {db_name} under macro {name_macro}")
def step_impl(context, column, query_name, table_name, db_name, name_macro, number):
    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get(db_name)
    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    number = int(number) / 60000
    value = (datetime.datetime.today() +
             datetime.timedelta(minutes=number)).strftime('%Y-%m-%d %H:%M')
    selected_query = utils.query_json(context, query_name, name_macro).replace(
        "columns", column).replace("table_name", table_name)
    exec_query = db.executeQuery(conn, selected_query)
    query_result = [t[0] for t in exec_query]
    print('query_result: ', query_result)
    elem = query_result[0].strftime('%Y-%m-%d %H:%M')

    db.closeConnection(conn)

    print(f"check expected element: {value}, obtained: {elem}")
    assert elem == value


@step(u"verify {number:d} record for the table {table_name} retrived by the query {query_name} on db {db_name} under macro {name_macro}")
def step_impl(context, query_name, table_name, db_name, name_macro, number):
    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get(db_name)
    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    selected_query = utils.query_json(context, query_name, name_macro).replace(
        "columns", '*').replace("table_name", table_name)

    exec_query = db.executeQuery(conn, selected_query)
    print("record query: ", exec_query)
    assert len(exec_query) == number, f"{len(exec_query)}"


@step('check token_valid_to is {condition} token_valid_from plus {param}')
def step_impl(context, condition, param):
    nodo_online_db = context.config.userdata.get(
        "db_configuration").get('nodo_online')
    nodo_online_conn = db.getConnection(nodo_online_db.get('host'), nodo_online_db.get(
        'database'), nodo_online_db.get('user'), nodo_online_db.get('password'), nodo_online_db.get('port'))

    token_validity_query = utils.query_json(context, 'token_validity', 'AppIO').replace(
        'columns', 'TOKEN_VALID_FROM, TOKEN_VALID_TO').replace('table_name', 'POSITION_ACTIVATE')
    token_valid_from, token_valid_to = db.executeQuery(
        nodo_online_conn, token_validity_query)[0]
    db.closeConnection(nodo_online_conn)

    if not param.isdigit():
        param = getattr(context, 'configurations').get(param)

    if condition == 'equal to':
        assert token_valid_to == token_valid_from + datetime.timedelta(milliseconds=int(
            param)), f"{token_valid_to} != {token_valid_from + datetime.timedelta(milliseconds=int(param))}"
    elif condition == 'greater than':
        assert token_valid_to > token_valid_from + datetime.timedelta(milliseconds=int(
            param)), f"{token_valid_to} <= {token_valid_from + datetime.timedelta(milliseconds=int(param))}"
    elif condition == 'smaller than':
        assert token_valid_to < token_valid_from + datetime.timedelta(milliseconds=int(
            param)), f"{token_valid_to} >= {token_valid_from + datetime.timedelta(milliseconds=int(param))}"
    else:
        assert False


@step('check value {value1} is {condition} value {value2}')
def step_impl(context, value1, condition, value2):

    value1 = utils.replace_local_variables(value1, context)
    value1 = utils.replace_context_variables(value1, context)
    value1 = utils.replace_global_variables(value1, context)
    value2 = utils.replace_local_variables(value2, context)
    value2 = utils.replace_context_variables(value2, context)
    value2 = utils.replace_global_variables(value2, context)

    if condition == 'equal to':
        assert value1 == value2, f"{value1} != {value2}"
    elif condition == 'greater than':
        assert value1 > value2, f"{value1} <= {value2}"
    elif condition == 'smaller than':
        assert value1 < value2, f"{value1} >= {value2}"
    else:
        assert False


@step("calling primitive {primitive1} and {primitive2} in parallel")
def step_impl(context, primitive1, primitive2):
    list_of_primitive = [primitive1, primitive2]
    utils.threading(context, list_of_primitive)


@then("check primitive response {primitive1} and primitive response {primitive2}")
def step_impl(context, primitive1, primitive2):
    response_primitive1 = parseString(getattr(context, primitive1))
    response_primitive2 = parseString(getattr(context, primitive2))

    outcome1 = response_primitive1.getElementsByTagName('outcome')[
        0].firstChild.data
    outcome2 = response_primitive2.getElementsByTagName('outcome')[
        0].firstChild.data

    if outcome1 == 'KO':
        faultCode1 = response_primitive1.getElementsByTagName('faultCode')[
            0].firstChild.data
        faultString1 = response_primitive1.getElementsByTagName('faultString')[
            0].firstChild.data
        description1 = response_primitive1.getElementsByTagName('description')[
            0].firstChild.data
    if outcome2 == 'KO':
        faultCode2 = response_primitive2.getElementsByTagName('faultCode')[
            0].firstChild.data
        faultString2 = response_primitive2.getElementsByTagName('faultString')[
            0].firstChild.data
        description2 = response_primitive2.getElementsByTagName('description')[
            0].firstChild.data

    if outcome1 == 'OK' and faultCode2 == 'PPT_PAGAMENTO_IN_CORSO' and faultString2 == 'Pagamento in attesa risulta in corso al sistema pagoPA' \
            and description2 == 'Pagamento in attesa risulta in corso al sistema pagoPA':
        assert True
    elif outcome2 == 'OK' and faultCode1 == 'PPT_PAGAMENTO_IN_CORSO' and faultString1 == 'Pagamento in attesa risulta in corso al sistema pagoPA' \
            and description1 == 'Pagamento in attesa risulta in corso al sistema pagoPA':
        assert True
    else:
        assert False


@then("check db PAG-590_01")
def step_impl(context):

    # from activatePaymentNotice2 = activatePaymentNotice1
    activatePaymentNotice2 = parseString(
        getattr(context, 'activatePaymentNotice2'))
    pa = activatePaymentNotice2.getElementsByTagName('fiscalCode')[
        0].firstChild.data
    psp = activatePaymentNotice2.getElementsByTagName('idPSP')[
        0].firstChild.data
    numavv = activatePaymentNotice2.getElementsByTagName('noticeNumber')[
        0].firstChild.data
    iuv = numavv[1:]
    print("iuv: ", iuv)

    config = json.load(
        open(os.path.join(context.config.base_dir + "/../resources/config.json")))
    intermediarioPA = config.get('global_configuration').get('id_broker')
    stazione = config.get('global_configuration').get('id_station')

    query_payment = "SELECT * FROM POSITION_PAYMENT WHERE NOTICE_ID = '$activatePaymentNotice1.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNotice1.fiscalCode'"
    query_service = "SELECT * FROM POSITION_SERVICE WHERE NOTICE_ID = '$activatePaymentNotice1.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNotice1.fiscalCode'"
    query_transfer = "SELECT * FROM POSITION_TRANSFER WHERE NOTICE_ID = '$activatePaymentNotice1.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNotice1.fiscalCode'"
    query1 = f"SELECT * FROM RPT WHERE IUV = '{iuv}' AND IDENT_DOMINIO = '$activatePaymentNotice1.fiscalCode'"
    query2 = "SELECT * FROM POSITION_PAYMENT_PLAN WHERE NOTICE_ID = '$activatePaymentNotice1.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNotice1.fiscalCode'"
    query3 = "SELECT * FROM POSITION_ACTIVATE WHERE NOTICE_ID = '$activatePaymentNotice1.noticeNumber' AND PA_FISCAL_CODE = '$activatePaymentNotice1.fiscalCode'"
    query4 = f"SELECT * FROM RPT_VERSAMENTI v JOIN RPT r ON v.FK_RPT = r.ID WHERE r.IUV = '{iuv}' AND r.IDENT_DOMINIO = '$activatePaymentNotice1.fiscalCode'"

    db_config = context.config.userdata.get("db_configuration")
    db_selected = db_config.get("nodo_online")

    conn = db.getConnection(db_selected.get('host'), db_selected.get(
        'database'), db_selected.get('user'), db_selected.get('password'), db_selected.get('port'))

    query_payment_replaced = utils.replace_local_variables(
        query_payment, context)
    query_service_replaced = utils.replace_local_variables(
        query_service, context)
    query_transfer_replaced = utils.replace_local_variables(
        query_transfer, context)
    query1_replaced = utils.replace_local_variables(query1, context)
    query2_replaced = utils.replace_local_variables(query2, context)
    query3_replaced = utils.replace_local_variables(query3, context)
    query4_replaced = utils.replace_local_variables(query4, context)

    rpt_id_row = db.executeQuery(conn, query_payment_replaced)
    service_row = db.executeQuery(conn, query_service_replaced)
    transfer_row = db.executeQuery(conn, query_transfer_replaced)
    rpt = db.executeQuery(conn, query1_replaced)
    plan = db.executeQuery(conn, query2_replaced)
    act = db.executeQuery(conn, query3_replaced)
    vers = db.executeQuery(conn, query4_replaced)

    debtor_id = service_row[0][0]
    print(debtor_id)

    query_debtor = f"SELECT ID, ENTITY_UNIQUE_IDENTIFIER_VALUE FROM POSITION_SUBJECT WHERE ID = '{debtor_id}'"
    debtor_row = db.executeQuery(conn, query_debtor)

    db.closeConnection(conn)

    # POSITION_ACTIVATE
    ID2 = act[0][0]
    PA_FISCAL_CODE2 = act[0][1]
    NOTICE_ID2 = act[0][2]
    CREDITOR_REFERENCE_ID2 = act[0][3]
    PSP_ID2 = act[0][4]
    IDEMPOTENCY_KEY2 = act[0][5]
    print("IDEMPOTENCY_KEY2: ", IDEMPOTENCY_KEY2)
    PAYMENT_TOKEN2 = act[0][6]
    TOKEN_VALID_FROM2 = act[0][7]
    TOKEN_VALID_TO2 = act[0][8]
    DUE_DATE2 = act[0][9]
    AMOUNT2 = act[0][10]

    ID21 = act[1][0]
    PA_FISCAL_CODE21 = act[1][1]
    NOTICE_ID21 = act[1][2]
    CREDITOR_REFERENCE_ID21 = act[1][3]
    PSP_ID21 = act[1][4]
    IDEMPOTENCY_KEY21 = act[1][5]
    PAYMENT_TOKEN21 = act[1][6]
    TOKEN_VALID_FROM21 = act[1][7]
    TOKEN_VALID_TO21 = act[1][8]
    DUE_DATE21 = act[1][9]
    AMOUNT21 = act[1][10]

    if TOKEN_VALID_TO2 == None:
        tokenPay = PAYMENT_TOKEN21
        assert TOKEN_VALID_FROM2 == None
        assert TOKEN_VALID_TO2 == None
        assert TOKEN_VALID_FROM21 != None
        assert TOKEN_VALID_TO21 != None
        assert CREDITOR_REFERENCE_ID21 == iuv
    elif TOKEN_VALID_TO21 == None:
        tokenPay = PAYMENT_TOKEN2
        assert TOKEN_VALID_FROM2 != None
        assert TOKEN_VALID_TO2 != None
        assert TOKEN_VALID_FROM21 == None
        assert TOKEN_VALID_TO21 == None
        assert CREDITOR_REFERENCE_ID2 == iuv

    assert ID2 != None
    assert PA_FISCAL_CODE2 == pa
    assert NOTICE_ID2 == numavv
    assert PSP_ID2 == psp
    assert IDEMPOTENCY_KEY2 == None
    assert PAYMENT_TOKEN2 != None
    assert DUE_DATE2 == None
    assert AMOUNT2 == 10

    assert ID21 != None
    assert PA_FISCAL_CODE21 == pa
    assert NOTICE_ID21 == numavv
    assert PSP_ID21 == psp
    assert IDEMPOTENCY_KEY21 == None
    assert PAYMENT_TOKEN21 != None
    assert DUE_DATE21 == None
    assert AMOUNT21 == 10

    # POSITION_PAYMENT
    ID = rpt_id_row[0][0]
    PA_FISCAL_CODE = rpt_id_row[0][1]
    NOTICE_ID = rpt_id_row[0][2]
    CREDITOR_REFERENCE_ID = rpt_id_row[0][3]
    PAYMENT_TOKEN = rpt_id_row[0][4]
    BROKER_PA_ID = rpt_id_row[0][5]
    STATION_ID = rpt_id_row[0][6]
    STATION_VERSION = rpt_id_row[0][7]
    PSP_ID = rpt_id_row[0][8]
    BROKER_PSP_ID = rpt_id_row[0][9]
    CHANNEL_ID = rpt_id_row[0][8]
    IDEMPOTENCY_KEY = rpt_id_row[0][9]
    AMOUNT = rpt_id_row[0][10]
    FEE = rpt_id_row[0][11]
    OUTCOME = rpt_id_row[0][12]
    PAYMENT_METHOD = rpt_id_row[0][13]
    PAYMENT_CHANNEL = rpt_id_row[0][14]
    TRANSFER_DATE = rpt_id_row[0][15]
    PAYER_ID = rpt_id_row[0][16]
    APPLICATION_DATE = rpt_id_row[0][16]
    INSERTED_TIMESTAMP = rpt_id_row[0][17]
    UPDATED_TIMESTAMP = rpt_id_row[0][18]
    FK_PAYMENT_PLAN = rpt_id_row[0][19]
    RPT_ID = rpt_id_row[0][20]
    PAYMENT_TYPE = rpt_id_row[0][21]
    CARRELLO_ID = rpt_id_row[0][22]
    ORIGINAL_PAYMENT_TOKEN = rpt_id_row[0][23]
    FLAGATTIVAMISSING = rpt_id_row[0][24]

    ID1 = rpt_id_row[1][0]

    assert ID != None
    assert PA_FISCAL_CODE == pa
    assert NOTICE_ID == numavv
    assert CREDITOR_REFERENCE_ID == iuv
    assert PAYMENT_TOKEN == tokenPay
    assert BROKER_PA_ID == intermediarioPA
    assert STATION_ID == stazione
    assert STATION_VERSION == 2
    assert PSP_ID == psp
    assert BROKER_PSP_ID == psp
    assert CHANNEL_ID == psp+'_01'
    assert IDEMPOTENCY_KEY == None
    assert AMOUNT == 10
    assert FEE == None
    assert OUTCOME == None
    assert PAYMENT_METHOD == None
    assert PAYMENT_CHANNEL == 'NA'
    assert TRANSFER_DATE == None
    assert PAYER_ID == None
    assert APPLICATION_DATE == None
    assert INSERTED_TIMESTAMP != None
    assert UPDATED_TIMESTAMP != None
    assert FK_PAYMENT_PLAN == plan[0][0]
    assert RPT_ID == rpt[0][0]
    assert PAYMENT_TYPE == 'MOD3'
    assert CARRELLO_ID == None
    assert ORIGINAL_PAYMENT_TOKEN == None
    assert FLAGATTIVAMISSING == None

    assert ID1 == None

    # POSITION_PAYMENT_PLAN
    ID4 = plan[0][0]
    PA_FISCAL_CODE4 = plan[0][1]
    NOTICE_ID4 = plan[0][2]
    CREDITOR_REFERENCE_ID4 = plan[0][3]
    DUE_DATE4 = plan[0][4]
    RETENTION_DATE4 = plan[0][5]
    AMOUNT4 = plan[0][6]
    FLAG_FINAL_PAYMENT4 = plan[0][7]
    INSERTED_TIMESTAMP4 = plan[0][8]
    UPDATED_TIMESTAMP4 = plan[0][9]
    METADATA4 = plan[0][10]
    FK_POSITION_SERVICE4 = plan[0][11]

    ID41 = rpt_id_row[1][0]

    assert ID4 != None
    assert PA_FISCAL_CODE4 == pa
    assert NOTICE_ID4 == numavv
    assert CREDITOR_REFERENCE_ID4 == iuv
    assert DUE_DATE4 != None
    assert RETENTION_DATE4 == None
    assert AMOUNT4 == 10
    assert FLAG_FINAL_PAYMENT4 == 'Y'
    assert INSERTED_TIMESTAMP4 != None
    assert UPDATED_TIMESTAMP4 != None
    assert METADATA4 != None
    assert FK_POSITION_SERVICE4 == service_row[0][0]

    assert ID41 == None

    # POSITION_SERVICE
    ID5 = service_row[0][0]
    PA_FISCAL_CODE5 = service_row[0][1]
    NOTICE_ID5 = service_row[0][2]
    DESCRIPTION5 = service_row[0][3]
    COMPANY_NAME5 = service_row[0][4]
    OFFICE_NAME5 = service_row[0][5]
    DEBTOR_ID5 = service_row[0][6]
    INSERTED_TIMESTAMP5 = service_row[0][7]
    UPDATED_TIMESTAMP5 = service_row[0][8]

    ID51 = service_row[1][0]

    assert ID5 != None
    assert PA_FISCAL_CODE5 == pa
    assert NOTICE_ID5 == numavv
    assert DESCRIPTION5 == 'test'
    assert COMPANY_NAME5 != None
    assert OFFICE_NAME5 == 'office'
    assert DEBTOR_ID5 != None
    assert INSERTED_TIMESTAMP5 != None
    assert UPDATED_TIMESTAMP5 != None

    assert ID51 == None


@then("check DB_GR_01")
def step_impl(context):
    # from activatePaymentNotice
    activatePaymentNotice = parseString(
        getattr(context, 'activatePaymentNotice'))
    pa = activatePaymentNotice.getElementsByTagName('fiscalCode')[
        0].firstChild.data
    psp = activatePaymentNotice.getElementsByTagName('idPSP')[
        0].firstChild.data
    noticeNumber = activatePaymentNotice.getElementsByTagName('noticeNumber')[
        0].firstChild.data

    config = json.load(
        open(os.path.join(context.config.base_dir + "/../resources/config.json")))
    intermediarioPA = config.get('global_configuration').get('id_broker')
    stazione = config.get('global_configuration').get('id_station')

    query = f"SELECT s.*, TO_CHAR(s.APPLICATION_DATE, 'YYYY-MM-DD') as tdate FROM POSITION_RECEIPT s where s.NOTICE_ID = '{noticeNumber}' and s.PA_FISCAL_CODE= '{pa}'"
    query1 = f"SELECT s.PAYMENT_TOKEN, s.NOTICE_ID,s.OUTCOME, s.PA_FISCAL_CODE, s.CREDITOR_REFERENCE_ID, s.AMOUNT, s.CHANNEL_ID, s.PAYMENT_CHANNEL, s.PAYER_ID, s.PAYMENT_METHOD, s.FEE, s.ID, TO_CHAR(s.APPLICATION_DATE, 'YYYY-MM-DD') FROM POSITION_PAYMENT s where s.NOTICE_ID = '{noticeNumber}' and s.PA_FISCAL_CODE= '{pa}' "
    query2 = f"SELECT s.DESCRIPTION, s.COMPANY_NAME, s.OFFICE_NAME, s.DEBTOR_ID FROM POSITION_SERVICE s where s.NOTICE_ID = '{noticeNumber}' and s.PA_FISCAL_CODE= '{pa}'"
    query3 = f"SELECT s.* FROM PSP s where s.ID_PSP = '{psp}'"
    query4 = f"SELECT s.METADATA FROM POSITION_PAYMENT_PLAN s where s.NOTICE_ID = '{noticeNumber}' and s.PA_FISCAL_CODE= '{pa}'"

    db_config = context.config.userdata.get(
        "db_configuration").get("nodo_online")

    conn = db.getConnection(db_config.get('host'), db_config.get(
        'database'), db_config.get('user'), db_config.get('password'), db_config.get('port'))

    rows = db.executeQuery(conn, query)
    rows1 = db.executeQuery(conn, query1)
    rows2 = db.executeQuery(conn, query2)
    rows4 = db.executeQuery(conn, query4)

    db.closeConnection(conn)

    db_config = context.config.userdata.get("db_configuration").get("nodo_cfg")

    conn = db.getConnection(db_config.get('host'), db_config.get(
        'database'), db_config.get('user'), db_config.get('password'), db_config.get('port'))

    rows3 = db.executeQuery(conn, query3)

    db.closeConnection(conn)

    assert rows[0][1] == rows1[0][0]
    assert rows[0][2] == rows1[0][1]
    assert rows[0][3] == rows1[0][3]
    assert rows[0][4] == rows1[0][4]
    assert rows[0][5] == rows1[0][0]
    assert rows[0][6] == rows1[0][2]
    assert rows[0][7] == rows1[0][5]
    assert rows[0][8] == rows2[0][0]
    assert rows[0][9] == rows2[0][1]
    assert rows[0][10] == rows2[0][2]
    assert rows[0][11] == rows2[0][3]
    assert rows[0][12] == psp
    assert rows[0][15] == rows3[0][6]
    assert rows[0][13] == rows3[0][16]
    assert rows[0][14] == rows3[0][17]
    assert rows[0][16] == rows1[0][6]
    assert rows[0][17] == rows1[0][7]
    assert rows[0][18] == rows1[0][8]
    assert rows[0][19] == rows1[0][9]
    assert rows[0][20] == rows1[0][10]
    assert rows[0][21] != None
    assert rows[0][31] == rows1[0][12]
    assert rows[0][23] != None
    assert rows[0][24] == rows4[0][0]
    assert rows[0][25] == None
    assert rows[0][26] == rows1[0][11]  # id
    assert len(rows) == 1


@then("RTP XML check")
def step_impl(context):

    XML = "SELECT XML FROM POSITION_RECEIPT_XML WHERE PAYMENT_TOKEN ='$activatePaymentNoticeResponse.paymentToken' and PA_FISCAL_CODE='$activatePaymentNotice.fiscalCode' and NOTICE_ID='$activatePaymentNotice.noticeNumber'"
    query = "SELECT BROKER_PA_ID, STATION_ID, PAYMENT_TOKEN, NOTICE_ID, PA_FISCAL_CODE, OUTCOME, CREDITOR_REFERENCE_ID, AMOUNT, PSP_ID, CHANNEL_ID, PAYMENT_CHANNEL, PAYMENT_METHOD, FEE, INSERTED_TIMESTAMP, APPLICATION_DATE, TRANSFER_DATE  FROM POSITION_PAYMENT WHERE PAYMENT_TOKEN ='$activatePaymentNoticeResponse.paymentToken' and PA_FISCAL_CODE='$activatePaymentNotice.fiscalCode' and NOTICE_ID='$activatePaymentNotice.noticeNumber'"
    query1 = "SELECT DESCRIPTION, COMPANY_NAME, OFFICE_NAME  FROM POSITION_SERVICE WHERE PA_FISCAL_CODE='$activatePaymentNotice.fiscalCode' and NOTICE_ID='$activatePaymentNotice.noticeNumber'"
    query2 = "SELECT su.ENTITY_UNIQUE_IDENTIFIER_TYPE, su.ENTITY_UNIQUE_IDENTIFIER_VALUE, su.FULL_NAME, su.STREET_NAME, su.CIVIC_NUMBER, su.POSTAL_CODE, su.CITY, su.STATE_PROVINCE_REGION, su.COUNTRY, su.EMAIL  FROM POSITION_SUBJECT su JOIN POSITION_SERVICE se ON su.ID = se.DEBTOR_ID WHERE se.PA_FISCAL_CODE='$activatePaymentNotice.fiscalCode' and se.NOTICE_ID='$activatePaymentNotice.noticeNumber' and su.SUBJECT_TYPE='DEBTOR'"
    query3 = "SELECT su.ENTITY_UNIQUE_IDENTIFIER_TYPE, su.ENTITY_UNIQUE_IDENTIFIER_VALUE, su.FULL_NAME, su.STREET_NAME, su.CIVIC_NUMBER, su.POSTAL_CODE, su.CITY, su.STATE_PROVINCE_REGION, su.COUNTRY, su.EMAIL  FROM POSITION_SUBJECT su JOIN POSITION_RECEIPT sr ON su.ID = sr.PAYER_ID WHERE sr.PA_FISCAL_CODE='$activatePaymentNotice.fiscalCode' and sr.NOTICE_ID='$activatePaymentNotice.noticeNumber' and su.SUBJECT_TYPE='PAYER'"
    query4 = "SELECT TRANSFER_IDENTIFIER, AMOUNT, PA_FISCAL_CODE_SECONDARY, IBAN, REMITTANCE_INFORMATION, TRANSFER_CATEGORY  FROM POSITION_TRANSFER WHERE PA_FISCAL_CODE='$activatePaymentNotice.fiscalCode' and NOTICE_ID='$activatePaymentNotice.noticeNumber'"

    db_config = context.config.userdata.get(
        "db_configuration").get("nodo_online")

    conn = db.getConnection(db_config.get('host'), db_config.get(
        'database'), db_config.get('user'), db_config.get('password'), db_config.get('port'))

    XML = utils.replace_local_variables(XML, context)
    xml_rows = db.executeQuery(conn, XML)
    query = utils.replace_local_variables(query, context)
    rows = db.executeQuery(conn, query)
    query1 = utils.replace_local_variables(query1, context)
    rows1 = db.executeQuery(conn, query1)
    query2 = utils.replace_local_variables(query2, context)
    rows2 = db.executeQuery(conn, query2)
    query3 = utils.replace_local_variables(query3, context)
    rows3 = db.executeQuery(conn, query3)
    query4 = utils.replace_local_variables(query4, context)
    rows4 = db.executeQuery(conn, query4)

    xml_rpt = parseString(xml_rows[0][0].read())

    brokerPaId = rows[0][0]
    stationId = rows[0][1]
    payToken = rows[0][2]
    noticeId = rows[0][3]
    paFiscalCode = rows[0][4]
    outcome = rows[0][5]
    credRefId = rows[0][6]
    amount = rows[0][7]
    description = rows1[0][0]
    companyName = rows1[0][1]
    debIdentifierType = rows2[0][0]
    debIdentifierValue = rows2[0][1]
    debName = rows2[0][2]
    debStreet = rows2[0][3]
    debCivic = rows2[0][4]
    debCode = rows2[0][5]
    debCity = rows2[0][6]
    debRegion = rows2[0][7]
    debCountry = rows2[0][8]
    debEmail = rows2[0][9]

    # TBD
    transTransferId = rows4[0][0]
    transAmount = rows4[0][1]
    transPaFiscalCodeSecondary = rows4[0][2]
    transIban = rows4[0][3]
    transRemittanceInformation = rows4[0][4]
    transTransferCategory = rows4[0][5]

    pspId = rows[0][8]

    db.closeConnection(conn)

    query5 = "SELECT CODICE_FISCALE, RAGIONE_SOCIALE  FROM PSP WHERE ID_PSP='$activatePaymentNotice.idPSP'"
    db_config = context.config.userdata.get("db_configuration").get("nodo_cfg")
    conn = db.getConnection(db_config.get('host'), db_config.get(
        'database'), db_config.get('user'), db_config.get('password'), db_config.get('port'))

    query5 = utils.replace_local_variables(query5, context)
    rows5 = db.executeQuery(conn, query5)

    db.closeConnection(conn)

    pspCodiceFiscale = rows5[0][0]
    # campo pspPartitaIVA mancante nella tabella PSP
    pspRagioneSociale = rows5[0][1]
    channelId = rows[0][9]
    payChannel = rows[0][10]

    assert xml_rpt.getElementsByTagName(
        "idPA")[0].firstChild.data == paFiscalCode
    assert xml_rpt.getElementsByTagName(
        "idBrokerPA")[0].firstChild.data == brokerPaId
    assert xml_rpt.getElementsByTagName(
        "idStation")[0].firstChild.data == stationId
    assert xml_rpt.getElementsByTagName(
        "receiptId")[0].firstChild.data == payToken
    assert xml_rpt.getElementsByTagName(
        "noticeNumber")[0].firstChild.data == noticeId
    assert xml_rpt.getElementsByTagName(
        "fiscalCode")[0].firstChild.data == paFiscalCode
    assert xml_rpt.getElementsByTagName(
        "outcome")[0].firstChild.data == outcome
    assert xml_rpt.getElementsByTagName("creditorReferenceId")[
        0].firstChild.data == credRefId

    paymentAmount = xml_rpt.getElementsByTagName("paymentAmount")[
        0].firstChild.data
    if isinstance(paymentAmount, str) and paymentAmount.isdigit():
        paymentAmount = float(paymentAmount)
        assert paymentAmount == amount

    assert xml_rpt.getElementsByTagName(
        "companyName")[0].firstChild.data == companyName
    assert xml_rpt.getElementsByTagName(
        "description")[0].firstChild.data == description
    assert xml_rpt.getElementsByTagName("entityUniqueIdentifierType")[
        0].firstChild.data == debIdentifierType
    assert xml_rpt.getElementsByTagName("entityUniqueIdentifierValue")[
        0].firstChild.data == debIdentifierValue
    assert xml_rpt.getElementsByTagName(
        "fullName")[0].firstChild.data == debName
    assert xml_rpt.getElementsByTagName(
        "streetName")[0].firstChild.data == debStreet
    assert xml_rpt.getElementsByTagName(
        "civicNumber")[0].firstChild.data == debCivic
    assert xml_rpt.getElementsByTagName(
        "postalCode")[0].firstChild.data == debCode
    assert xml_rpt.getElementsByTagName("city")[0].firstChild.data == debCity
    assert xml_rpt.getElementsByTagName("stateProvinceRegion")[
        0].firstChild.data == debRegion
    assert xml_rpt.getElementsByTagName(
        "country")[0].firstChild.data == debCountry
    assert xml_rpt.getElementsByTagName(
        "e-mail")[0].firstChild.data == debEmail
    assert xml_rpt.getElementsByTagName(
        "idTransfer")[0].firstChild.data == transTransferId

    transferAmount = xml_rpt.getElementsByTagName("transferAmount")[
        0].firstChild.data
    if isinstance(transferAmount, str) and transferAmount.isdigit():
        transferAmount = float(transferAmount)
        assert transferAmount == transAmount

    assert xml_rpt.getElementsByTagName(
        "fiscalCodePA")[0].firstChild.data == transPaFiscalCodeSecondary
    assert xml_rpt.getElementsByTagName("IBAN")[0].firstChild.data == transIban
    assert xml_rpt.getElementsByTagName("remittanceInformation")[
        0].firstChild.data == transRemittanceInformation
    assert xml_rpt.getElementsByTagName("transferCategory")[
        0].firstChild.data == transTransferCategory

    assert xml_rpt.getElementsByTagName("idPSP")[0].firstChild.data == pspId
    assert xml_rpt.getElementsByTagName("pspFiscalCode")[
        0].firstChild.data == pspCodiceFiscale
    assert xml_rpt.getElementsByTagName("PSPCompanyName")[
        0].firstChild.data == pspRagioneSociale
    assert xml_rpt.getElementsByTagName(
        "idChannel")[0].firstChild.data == channelId

    if payChannel == None:
        assert xml_rpt.getElementsByTagName("channelDescription")[
            0].firstChild.data == 'NA'
    else:
        assert xml_rpt.getElementsByTagName("channelDescription")[
            0].firstChild.data == payChannel

    if len(xml_rpt.getElementsByTagName("officeName")) > 0:
        officeName = rows1[0][2]
        assert xml_rpt.getElementsByTagName(
            "officeName")[0].firstChild.data == officeName

    if len(xml_rpt.getElementsByTagName("payer")) > 0:
        payIdentifierType = rows3[0][0]
        payIdentifierValue = rows3[0][1]
        payName = rows3[0][2]
        payStreet = rows3[0][3]
        payCivic = rows3[0][4]
        payCode = rows3[0][5]
        payCity = rows3[0][6]
        payRegion = rows3[0][7]
        payCountry = rows3[0][8]
        payEmail = rows3[0][9]

    assert xml_rpt.getElementsByTagName("entityUniqueIdentifierType")[
        0].firstChild.data == payIdentifierType
    assert xml_rpt.getElementsByTagName("entityUniqueIdentifierValue")[
        0].firstChild.data == payIdentifierValue
    assert xml_rpt.getElementsByTagName(
        "fullName")[0].firstChild.data == payName
    assert xml_rpt.getElementsByTagName(
        "streetName")[0].firstChild.data == payStreet
    assert xml_rpt.getElementsByTagName(
        "civicNumber")[0].firstChild.data == payCivic
    assert xml_rpt.getElementsByTagName(
        "postalCode")[0].firstChild.data == payCode
    assert xml_rpt.getElementsByTagName("city")[0].firstChild.data == payCity
    assert xml_rpt.getElementsByTagName("stateProvinceRegion")[
        0].firstChild.data == payRegion
    assert xml_rpt.getElementsByTagName(
        "country")[0].firstChild.data == payCountry
    assert xml_rpt.getElementsByTagName(
        "e-mail")[0].firstChild.data == payEmail

    if len(xml_rpt.getElementsByTagName("paymentMethod")) > 0:
        payMethod = rows[0][11]
        assert xml_rpt.getElementsByTagName("paymentMethod")[
            0].firstChild.data == payMethod

    """    
    if len(xml_rpt.getElementsByTagName("fee")) > 0:
        print(xml_rpt.getElementsByTagName("fee"))
    
        fee = rows[0][12]
        print(fee)
        assert xml_rpt.getElementsByTagName("fee")[0].firstChild.data == fee

    #elif isinstance(elem, datetime.date): query_result[i] = elem.strftime('%Y-%m-%d')
    
    if xml_rpt.getElementsByTagName("paymentDateTime")[0].firstChild.data:
        print(rows[0][13])
        #insTimestampString = rows[0][13].strftime("%H:%M:%S")+'T'+
        assert xml_rpt.getElementsByTagName("paymentDateTime")[0].firstChild.data == insTimestampString
    

    if xml_rpt.getElementsByTagName("applicationDate")[0].firstChild.data:
        print(rows[0][14])
        traDateString = rows[0][14].strftime("%H:%M:%S")+'T'+
        assert xml_rpt.getElementsByTagName("applicationDate")[0].firstChild.data == appDateString    

        if xml_rpt.getElementsByTagName("transferDate")[0].firstChild.data:
        print(rows[0][15])
        appDateString = rows[0][15].strftime("%H:%M:%S")+'T'+
        assert xml_rpt.getElementsByTagName("transferDate")[0].firstChild.data == appDateString 
    """

    # campo METADATA opzionale da aggiungere


@step('retrieve session token from {url}')
def step_impl(context, url):
    url = utils.replace_local_variables(url, context)
    print(url)
    print(f"#################### {url.split('idSession=')[1]}")
    setattr(context, f'sessionToken', url.split('idSession=')[1])


@step('retrieve url from {url}')
def step_impl(context, url):
    url = utils.replace_local_variables(url, context)
    print(url)
    setattr(context, 'url', url)

@step('replace {old_attribute} content with {new_attribute} content')
def step_impl(context, old_attribute, new_attribute):
    setattr(context, old_attribute, getattr(context, new_attribute))


@step('Select and Update RT for Test retry_PAold with causale versamento {causaleVers}')
def step_impl(context, causaleVers):
    db_config = context.config.userdata.get(
        "db_configuration").get("nodo_online")

    conn = db.getConnection(db_config.get('host'), db_config.get(
        'database'), db_config.get('user'), db_config.get('password'), db_config.get('port'))

    # select clob
    xml_content_query = "SELECT XML_CONTENT as clob FROM RT_XML WHERE IDENT_DOMINIO='$activatePaymentNotice.fiscalCode' AND IUV='$iuv'"

    xml_content_query = utils.replace_local_variables(
        xml_content_query, context)
    xml_content_query = utils.replace_context_variables(
        xml_content_query, context)
    xml_content_row = db.executeQuery(conn, xml_content_query)

    xml_rt = parseString(xml_content_row[0][0].read())
    node = xml_rt.getElementsByTagName('causaleVersamento')[0]
    node.firstChild.replaceWholeText(f'{causaleVers}')
    xml_rt_string = xml_rt.toxml()
    print(xml_rt_string)

    query_update = f"UPDATE RT_XML SET XML_CONTENT = TO_CLOB('{xml_rt_string}')WHERE IDENT_DOMINIO='$activatePaymentNotice.fiscalCode' AND IUV='$iuv'"
    print(query_update)
    query_update = utils.replace_local_variables(query_update, context)
    query_update = utils.replace_context_variables(query_update, context)

    db.executeQuery(conn, query_update)

    db.closeConnection(conn)
