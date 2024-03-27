import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('nodoChiediCatalogoServiziV2');
export const All_Trend = new Trend('ALL');

export function nodoChiediCatalogoServiziV2ReqBody(psp, pspint, chpsp) {

  return `
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
  <soapenv:Header/>
  <soapenv:Body>
  <nod:nodoChiediCatalogoServiziV2Request>
  <identificativoPSP>${psp}</identificativoPSP>
  <identificativoIntermediarioPSP>${pspint}</identificativoIntermediarioPSP>
  <identificativoCanale>${chpsp}</identificativoCanale>
  <password>pwdpwdpwd</password>

  </nod:nodoChiediCatalogoServiziV2Request>
  </soapenv:Body>
  </soapenv:Envelope>`};


export function nodoChiediCatalogoServiziV2(baseUrl, rndAnagPsp) {

  console.debug(nodoChiediCatalogoServiziV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP));
  let res = http.post(getBasePath(baseUrl, "nodoChiediCatalogoServiziV2"),
    nodoChiediCatalogoServiziV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoChiediCatalogoServiziV2' }),
      tags: { nodoChiediCatalogoServiziV2: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoChiediCatalogoServiziV2" }
    }
  );

  console.debug("nodoChiediCatalogoServiziV2 RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'nodoChiediCatalogoServiziV2:over_sla300': (r) => r.timings.duration > 300,
  },
    { nodoChiediCatalogoServiziV2: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'nodoChiediCatalogoServiziV2:over_sla400': (r) => r.timings.duration > 400,
  },
    { nodoChiediCatalogoServiziV2: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'nodoChiediCatalogoServiziV2:over_sla500': (r) => r.timings.duration > 500,
  },
    { nodoChiediCatalogoServiziV2: 'over_sla500', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediCatalogoServiziV2:over_sla600': (r) => r.timings.duration > 600,
  },
    { nodoChiediCatalogoServiziV2: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediCatalogoServiziV2:over_sla800': (r) => r.timings.duration > 800,
  },
    { nodoChiediCatalogoServiziV2: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'nodoChiediCatalogoServiziV2:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { nodoChiediCatalogoServiziV2: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let outcome = '';
  let description = '';
  let xmlCatalogoServizi = '';
  try{
  const doc = parseHTML(res.body);
  const script1 = doc.find('faultCode');
  const script2 = doc.find('description');
  const script3 = doc.find('xmlCatalogoServizi');
  outcome = script1.text();
  description = script2.text();
  xmlCatalogoServizi = script3.text();
  }catch(error){}

  check(
    res,
    {
      //'nodoChiediCatalogoServiziV2:ok_rate': (r) => r.status == 200,
      'nodoChiediCatalogoServiziV2:ok_rate': (r) => xmlCatalogoServizi,
    },
    { nodoChiediCatalogoServiziV2: 'ok_rate' , ALL:'ok_rate'}
  );

  if(check(
    res,
    {
      //'nodoChiediCatalogoServiziV2:ko_rate': (r) => r.status !== 200,
      'nodoChiediCatalogoServiziV2:ko_rate': (r) => !xmlCatalogoServizi,
    },
    { nodoChiediCatalogoServiziV2: 'ko_rate', ALL:'ko_rate' }
  )){
    fail("errore nodoChiediCatalogoServiziV2 : " + outcome + ' --> ' + description);
     
  }
  return res;
     
}