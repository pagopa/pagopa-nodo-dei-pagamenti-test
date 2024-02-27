import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const sendPaymentOutput_Trend = new Trend('sendPaymentOutcomeV2');
export const All_Trend = new Trend('ALL');


export function sendPaymentOutcomeV2ReqBody(psp, intpsp, chpsp, paymentToken) {

  var today = new Date();
  var tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1)

  //console.debug(tomorrow);
  var dd = String(today.getDate()).padStart(2, '0');
  var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
  var yyyy = today.getFullYear();
  today = yyyy + '-' + mm + '-' + dd;

  var dd_ = String(tomorrow.getDate()).padStart(2, '0');
  var mm_ = String(tomorrow.getMonth() + 1).padStart(2, '0'); //January is 0!
  var yyyy_ = tomorrow.getFullYear();
  tomorrow = yyyy_ + '-' + mm_ + '-' + dd_;

  return `
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
    <soapenv:Header/>
    <soapenv:Body>
    <nod:sendPaymentOutcomeV2Request>
    <idPSP>${psp}</idPSP>
    <idBrokerPSP>${intpsp}</idBrokerPSP>
    <idChannel>${chpsp}</idChannel>
    <password>pwdpwdpwd</password>
    <paymentTokens>
    <paymentToken>${paymentToken}</paymentToken>
    </paymentTokens>
    <outcome>OK</outcome>
    <details>
    <paymentMethod>creditCard</paymentMethod>
    <paymentChannel>app</paymentChannel>
    <fee>0.01</fee>
    <applicationDate>${today}</applicationDate>
    <transferDate>${tomorrow}</transferDate>
    </details>
    </nod:sendPaymentOutcomeV2Request>
    </soapenv:Body>
    </soapenv:Envelope>
`
};

export function sendPaymentOutcomeV2(baseUrl, rndAnagPsp, paymentToken) {
  //console.debug("VERIFY="+noticeNmbr);
  console.log(sendPaymentOutcomeV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, paymentToken))
  const res = http.post(
    getBasePath(baseUrl, "sendPaymentOutcomeV2"),
    sendPaymentOutcomeV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, paymentToken),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'sendPaymentOutcomeV2' }),
      tags: { sendPaymentOutcomeV2: 'http_req_duration', ALL: 'http_req_duration', primitiva: "sendPaymentOutcomeV2" }
    }
  );

  console.debug("sendPaymentOutcomeV2 RES");
  console.debug(JSON.stringify(res));

  sendPaymentOutput_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'sendPaymentOutcomeV2:over_sla300': (r) => r.timings.duration > 300,
  },
    { sendPaymentOutcomeV2: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'sendPaymentOutcomeV2:over_sla400': (r) => r.timings.duration > 400,
  },
    { sendPaymentOutcomeV2: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'sendPaymentOutcomeV2:over_sla500 ': (r) => r.timings.duration > 500,
  },
    { sendPaymentOutcomeV2: 'over_sla500', ALL: 'over_sla500' }
  );

  check(res, {
    'sendPaymentOutcomeV2:over_sla600': (r) => r.timings.duration > 600,
  },
    { sendPaymentOutcomeV2: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'sendPaymentOutcomeV2:over_sla800': (r) => r.timings.duration > 800,
  },
    { sendPaymentOutcomeV2: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'sendPaymentOutcomeV2:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { sendPaymentOutcomeV2: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let outcome = '';
  try {
    let doc = parseHTML(res.body);
    let script = doc.find('outcome');
    outcome = script.text();
  } catch (error) { }
  /*if(outcome=='KO'){
  console.debug("sendPaymentOutcomeV2 REq----------------"+sendPaymentOutcomeV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, paymentToken));
  console.debug("sendPaymentOutcomeV2 RESPONSE----------------"+res.body);
  }*/



  check(
    res,
    {
      //'sendPaymentOutcomeV2:ok_rate': (r) => r.status == 200,
      'sendPaymentOutcomeV2:ok_rate': (r) => outcome == 'OK',
    },
    { sendPaymentOutcomeV2: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {
      //'sendPaymentOutcomeV2:ko_rate': (r) => r.status !== 200,
      'sendPaymentOutcomeV2:ko_rate': (r) => outcome !== 'OK',
    },
    { sendPaymentOutcomeV2: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail("outcome != ok: " + outcome);
  }

  return res;

}

