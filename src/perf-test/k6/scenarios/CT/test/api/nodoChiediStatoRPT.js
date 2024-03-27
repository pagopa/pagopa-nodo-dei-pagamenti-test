import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('nodoChiediStatoRPT');
export const All_Trend = new Trend('ALL');

export function nodoChiediStatoRPTReqBody(pa, intpa, stazpa, iuv, ccp) {

  return `
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
  <soapenv:Header />
  <soapenv:Body>
      <ws:nodoChiediStatoRPT>
          <identificativoIntermediarioPA>${intpa}</identificativoIntermediarioPA>
          <identificativoStazioneIntermediarioPA>${stazpa}</identificativoStazioneIntermediarioPA>
          <password>pwdpwdpwd</password>
          <identificativoDominio>${pa}</identificativoDominio>
          <identificativoUnivocoVersamento>${iuv}</identificativoUnivocoVersamento>
          <codiceContestoPagamento>${ccp}</codiceContestoPagamento>
      </ws:nodoChiediStatoRPT>
  </soapenv:Body>
</soapenv:Envelope>`};


export function nodoChiediStatoRPT(baseUrl, rndAnagPa, iuv, ccp) {

  console.debug(nodoChiediStatoRPTReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, ccp));
  let res = http.post(getBasePath(baseUrl, "nodoChiediStatoRPT"),
    nodoChiediStatoRPTReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA, iuv, ccp),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoChiediStatoRPT' }),
      tags: { nodoChiediStatoRPT: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoChiediStatoRPT" }
    }
  );

  console.debug("nodoChiediStatoRPT RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'nodoChiediStatoRPT:over_sla300': (r) => r.timings.duration > 300,
  },
    { nodoChiediStatoRPT: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'nodoChiediStatoRPT:over_sla400': (r) => r.timings.duration > 400,
  },
    { nodoChiediStatoRPT: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'nodoChiediStatoRPT:over_sla500': (r) => r.timings.duration > 500,
  },
    { nodoChiediStatoRPT: 'over_sla500', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediStatoRPT:over_sla600': (r) => r.timings.duration > 600,
  },
    { nodoChiediStatoRPT: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoChiediStatoRPT:over_sla800': (r) => r.timings.duration > 800,
  },
    { nodoChiediStatoRPT: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'nodoChiediStatoRPT:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { nodoChiediStatoRPT: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let stato = '';
  let outcome = '';
  let description = '';
  let redirect = '';
  try{
  const doc = parseHTML(res.body);
  const script = doc.find('stato');
  const script1 = doc.find('faultCode');
  const script2 = doc.find('description');
  const script3 = doc.find('redirect');
  stato = script.text();
  outcome = script1.text();
  description = script2.text();
  redirect = script3.text();
  }catch(error){}

    check(
      res,
      {
        //'nodoChiediStatoRPT:ok_rate': (r) => r.status == 200,
        'nodoChiediStatoRPT:ok_rate': (r) => redirect,
      },
      { nodoChiediStatoRPT: 'ok_rate' , ALL:'ok_rate'}
    );

    if(check(
      res,
      {
        //'nodoChiediStatoRPT:ko_rate': (r) => r.status !== 200,
        'nodoChiediStatoRPT:ko_rate': (r) => !redirect,
      },
      { nodoChiediStatoRPT: 'ko_rate', ALL:'ko_rate' }
    )){
      fail("errore lista pendenti : " + outcome + ' --> ' + description);
    }

    return res;
     
  }