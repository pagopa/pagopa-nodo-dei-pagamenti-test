import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('nodoChiediListaPendentiRPT');
export const All_Trend = new Trend('ALL');

export function nodoChiediListaPendentiRPTReqBody(pa, intpa, stazpa) {

  return `
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
  <soapenv:Header/>
  <soapenv:Body>
      <ws:nodoChiediListaPendentiRPT>
          <identificativoIntermediarioPA>${intpa}</identificativoIntermediarioPA>
          <identificativoStazioneIntermediarioPA>${stazpa}</identificativoStazioneIntermediarioPA>
          <password>pwdpwdpwd</password>
          <identificativoDominio>${pa}</identificativoDominio>
          <dimensioneLista>9999</dimensioneLista>
      </ws:nodoChiediListaPendentiRPT>
  </soapenv:Body>
  </soapenv:Envelope>`};


export function nodoChiediListaPendentiRPT(baseUrl, rndAnagPa) {

  console.debug(nodoChiediListaPendentiRPTReqBody(rndAnagPa.CF));
  let res = http.post(getBasePath(baseUrl, "nodoChiediListaPendentiRPT"),
    nodoChiediListaPendentiRPTReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoChiediListaPendentiRPT' }),
      tags: { nodoChiediListaPendentiRPT: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoChiediListaPendentiRPT" }
    }
  );

  console.debug("nodoChiediListaPendentiRPT RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'nodoChiediListaPendentiRPT:over_sla300': (r) => r.timings.duration > 300,
  },
    { nodoChiediListaPendentiRPT: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'nodoChiediListaPendentiRPT:over_sla400': (r) => r.timings.duration > 400,
  },
    { nodoChiediListaPendentiRPT: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'nodoChiediListaPendentiRPT:over_sla500': (r) => r.timings.duration > 500,
  },
    { nodoChiediListaPendentiRPT: 'over_sla500', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediListaPendentiRPT:over_sla600': (r) => r.timings.duration > 600,
  },
    { nodoChiediListaPendentiRPT: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediListaPendentiRPT:over_sla800': (r) => r.timings.duration > 800,
  },
    { nodoChiediListaPendentiRPT: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'nodoChiediListaPendentiRPT:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { nodoChiediListaPendentiRPT: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let totRestituiti = '';
  let outcome = '';
  let description = '';
  try{
  const doc = parseHTML(res.body);
  const script = doc.find('totRestituiti');
  const script1 = doc.find('faultCode');
  const script2 = doc.find('description');
  totRestituiti = script.text();
  outcome = script1.text();
  description = script2.text();
  }catch(error){}

    check(
      res,
      {
        //'nodoChiediListaPendentiRPT:ok_rate': (r) => r.status == 200,
        'nodoChiediListaPendentiRPT:ok_rate': (r) => totRestituiti !== '',
      },
      { nodoChiediListaPendentiRPT: 'ok_rate' , ALL:'ok_rate'}
      );
   
    if(check(
      res,
      {
        //'nodoChiediListaPendentiRPT:ko_rate': (r) => r.status !== 200,
        'nodoChiediListaPendentiRPT:ko_rate': (r) => totRestituiti == '',
      },
      { nodoChiediListaPendentiRPT: 'ko_rate', ALL:'ko_rate' }
    )){
      fail("errore lista pendenti : " + outcome + ' --> ' + description);
      }
    
    return res;
     
  }