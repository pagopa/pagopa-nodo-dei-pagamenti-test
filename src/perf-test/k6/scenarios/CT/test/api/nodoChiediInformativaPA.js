import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('nodoChiediInformativaPA');
export const All_Trend = new Trend('ALL');

export function nodoChiediInformativaPAReqBody(psp, pspint, chpsp) {

  return `
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
  <soapenv:Header/>
  <soapenv:Body>
      <ws:nodoChiediInformativaPA>
        <identificativoPSP>${psp}</identificativoPSP>
        <identificativoIntermediarioPSP>${pspint}</identificativoIntermediarioPSP>
        <identificativoCanale>${chpsp}</identificativoCanale>
        <password>pwdpwdpwd</password>
      </ws:nodoChiediInformativaPA>
  </soapenv:Body>
  </soapenv:Envelope>`};


export function nodoChiediInformativaPA(baseUrl, rndAnagPsp) {

  console.debug(nodoChiediInformativaPAReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP));
  let res = http.post(getBasePath(baseUrl, "nodoChiediInformativaPA"),
    nodoChiediInformativaPAReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoChiediInformativaPA' }),
      tags: { nodoChiediInformativaPA: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoChiediInformativaPA" }
    }
  );

  console.debug("nodoChiediInformativaPA RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'nodoChiediInformativaPA:over_sla300': (r) => r.timings.duration > 300,
  },
    { nodoChiediInformativaPA: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'nodoChiediInformativaPA:over_sla400': (r) => r.timings.duration > 400,
  },
    { nodoChiediInformativaPA: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'nodoChiediInformativaPA:over_sla500': (r) => r.timings.duration > 500,
  },
    { nodoChiediInformativaPA: 'over_sla500', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediInformativaPA:over_sla600': (r) => r.timings.duration > 600,
  },
    { nodoChiediInformativaPA: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediInformativaPA:over_sla800': (r) => r.timings.duration > 800,
  },
    { nodoChiediInformativaPA: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'nodoChiediInformativaPA:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { nodoChiediInformativaPA: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let outcome = '';
  let description = '';
  let xmlInformativa = '';
  try{
  const doc = parseHTML(res.body);
  const script = doc.find('stato');
  const script1 = doc.find('faultCode');
  const script2 = doc.find('description');
  const script3 = doc.find('xmlInformativa');
  outcome = script1.text();
  description = script2.text();
  xmlInformativa = script3.text();
  }catch(error){}

  check(
    res,
    {
      //'nodoChiediInformativaPA:ok_rate': (r) => r.status == 200,
      'nodoChiediInformativaPA:ok_rate': (r) => xmlInformativa,
    },
    { nodoChiediInformativaPA: 'ok_rate' , ALL:'ok_rate'}
  );

  if(check(
    res,
    {
      //'nodoChiediInformativaPA:ko_rate': (r) => r.status !== 200,
      'nodoChiediInformativaPA:ko_rate': (r) => !xmlInformativa,
    },
    { nodoChiediInformativaPA: 'ko_rate', ALL:'ko_rate' }
  )){
    fail("errore chiediInformativaPA : " + outcome + ' --> ' + description);
  }

  return res;
     
  }