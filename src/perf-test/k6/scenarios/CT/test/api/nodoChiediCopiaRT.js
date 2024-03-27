import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('nodoChiediCopiaRT');
export const All_Trend = new Trend('ALL');

export function nodoChiediCopiaRTReqBody(pa, intpa, stazpa, iuv, ccp) {

  return `
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
  <soapenv:Header/>
  <soapenv:Body>
  <ws:nodoChiediCopiaRT>
  <identificativoIntermediarioPA>${intpa}</identificativoIntermediarioPA>
  <identificativoStazioneIntermediarioPA>${stazpa}</identificativoStazioneIntermediarioPA>
  <password>pwdpwdpwd</password>
  <identificativoDominio>${pa}</identificativoDominio>
  <identificativoUnivocoVersamento>${iuv}</identificativoUnivocoVersamento>
  <codiceContestoPagamento>${ccp}</codiceContestoPagamento>
  </ws:nodoChiediCopiaRT>
  </soapenv:Body>
  </soapenv:Envelope>`};


export function nodoChiediCopiaRT(baseUrl, rndAnagPa, iuv, ccp) {

  console.debug(nodoChiediCopiaRTReqBody(rndAnagPa.CF, iuv, ccp));
  let res = http.post(getBasePath(baseUrl, "nodoChiediCopiaRT"),
    nodoChiediCopiaRTReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, ccp),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoChiediCopiaRT' }),
      tags: { nodoChiediCopiaRT: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoChiediCopiaRT" }
    }
  );

  console.debug("nodoChiediCopiaRT RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'nodoChiediCopiaRT:over_sla300': (r) => r.timings.duration > 300,
  },
    { nodoChiediCopiaRT: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'nodoChiediCopiaRT:over_sla400': (r) => r.timings.duration > 400,
  },
    { nodoChiediCopiaRT: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'nodoChiediCopiaRT:over_sla500': (r) => r.timings.duration > 500,
  },
    { nodoChiediCopiaRT: 'over_sla500', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediCopiaRT:over_sla600': (r) => r.timings.duration > 600,
  },
    { nodoChiediCopiaRT: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediCopiaRT:over_sla800': (r) => r.timings.duration > 800,
  },
    { nodoChiediCopiaRT: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'nodoChiediCopiaRT:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { nodoChiediCopiaRT: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let rt = '';
  let outcome = '';
  let description = '';
  try{
  const doc = parseHTML(res.body);
  const script = doc.find('rt');
  const script1 = doc.find('faultCode');
  const script2 = doc.find('description');
  rt = script.text();
  outcome = script1.text();
  description = script2.text();
  }catch(error){}

    check(
      res,
      {
        //'nodoChiediCopiaRT:ok_rate': (r) => r.status == 200,
        'nodoChiediCopiaRT:ok_rate': (r) => rt !== '',
      },
      { nodoChiediCopiaRT: 'ok_rate' , ALL:'ok_rate'}
      );
   
    if(check(
      res,
      {
        //'nodoChiediCopiaRT:ko_rate': (r) => r.status !== 200,
        'nodoChiediCopiaRT:ko_rate': (r) => rt == '',
      },
      { nodoChiediCopiaRT: 'ko_rate', ALL:'ko_rate' }
    )){
      fail("nessuna RT : " + outcome + ' --> ' + description);
      }
    
    return res;
     
  }