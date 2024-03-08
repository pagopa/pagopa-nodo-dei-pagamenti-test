import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('activatePaymentNoticeV2');
export const All_Trend = new Trend('ALL');

export function activateV2EcommReqBody(cfpa, noticeNmbr, idempotencyKey, paymentNote) {

  return `
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
  <soapenv:Header/>
  <soapenv:Body>
  <nod:activatePaymentNoticeV2Request>
  <idPSP>15376371009</idPSP>
  <idBrokerPSP>15376371009</idBrokerPSP>
  <idChannel>15376371009_01</idChannel>
  <password>pwdpwdpwd</password>
  <idempotencyKey>${idempotencyKey}</idempotencyKey>
  <qrCode>
    <fiscalCode>${cfpa}</fiscalCode>
    <noticeNumber>${noticeNmbr}</noticeNumber>
  </qrCode>
  <expirationTime>120000</expirationTime>
  <amount>1.00</amount>
  <dueDate>2021-12-31</dueDate>
  <paymentNote>${paymentNote}</paymentNote>
  <paymentMethod>PO</paymentMethod>
  <touchPoint>ATM</touchPoint>
  </nod:activatePaymentNoticeV2Request>
  </soapenv:Body>
  </soapenv:Envelope>`};


export function activatePaymentNoticeV2Ecomm(baseUrl, rndAnagPa, noticeNmbr, idempotencyKey, paymentNote) {

  console.debug(activateV2EcommReqBody(rndAnagPa.CF, noticeNmbr, idempotencyKey, paymentNote));
  let res = http.post(getBasePath(baseUrl, "activatePaymentNoticeV2"),
    activateV2EcommReqBody(rndAnagPa.CF, noticeNmbr, idempotencyKey, paymentNote),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'activatePaymentNoticeV2' }),
      tags: { activatePaymentNoticeV2: 'http_req_duration', ALL: 'http_req_duration', primitiva: "activatePaymentNoticeV2" }
    }
  );

  console.debug("activatePaymentNoticeV2 RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'activatePaymentNoticeV2:over_sla300': (r) => r.timings.duration > 300,
  },
    { activatePaymentNoticeV2: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'activatePaymentNoticeV2:over_sla400': (r) => r.timings.duration > 400,
  },
    { activatePaymentNoticeV2: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'activatePaymentNoticeV2:over_sla500': (r) => r.timings.duration > 500,
  },
    { activatePaymentNoticeV2: 'over_sla500', ALL: 'over_sla600' }
  );

  check(res, {
    'activatePaymentNoticeV2:over_sla600': (r) => r.timings.duration > 600,
  },
    { activatePaymentNoticeV2: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'activatePaymentNoticeV2:over_sla800': (r) => r.timings.duration > 800,
  },
    { activatePaymentNoticeV2: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'activatePaymentNoticeV2:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { activatePaymentNoticeV2: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let outcome = '';
  let paymentToken = '';
  let creditorReferenceId = '';
  let result = {};
  result.paymentToken = paymentToken;
  result.creditorReferenceId = creditorReferenceId;
  try {
    let doc = parseHTML(res.body);
    let script = doc.find('outcome');
    outcome = script.text();
    script = doc.find('paymentToken');
    paymentToken = script.text();
    result.paymentToken = paymentToken;
    script = doc.find('creditorReferenceId');
    creditorReferenceId = script.text();
    result.creditorReferenceId = creditorReferenceId;
    script = doc.find('totalAmount');
    result.amount = script.text();
    console.debug("activatePaymentNoticeV2 totalAmount: " + result.amount);
  } catch (error) { }

  /*
    if(outcome=='KO'){
    console.debug("activate REQuest----------------"+activateV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey)); 
    console.debug("activate RESPONSE----------------"+res.body);
    } */


  check(
    res,
    {
      //'activatePaymentNoticeV2:ok_rate': (r) => r.status == 200,
      'activatePaymentNoticeV2:ok_rate': (r) => outcome == 'OK' && result.creditorReferenceId != undefined && result.creditorReferenceId !== '',
    },
    { activatePaymentNoticeV2: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {
      //'activatePaymentNoticeV2:ko_rate': (r) => r.status !== 200,
      'activatePaymentNoticeV2:ko_rate': (r) => result.creditorReferenceId == undefined || result.creditorReferenceId === '' || outcome !== 'OK',
    },
    { activatePaymentNoticeV2: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail('result.creditorReferenceId undefined or empty: ' + result.creditorReferenceId + "or outcome != OK: " + outcome);
  }

  return result;
}
