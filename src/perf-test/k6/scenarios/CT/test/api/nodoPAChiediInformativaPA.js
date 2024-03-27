import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('nodoPAChiediInformativaPA');
export const All_Trend = new Trend('ALL');

export function nodoPAChiediInformativaPAReqBody(pa, intpa, stazpa) {

  return `
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
  <soapenv:Header/>
  <soapenv:Body>
      <ws:nodoPAChiediInformativaPA>
          <identificativoIntermediarioPA>${intpa}</identificativoIntermediarioPA>
          <identificativoStazioneIntermediarioPA>${stazpa}</identificativoStazioneIntermediarioPA>
          <password>pwdpwdpwd</password>
          <identificativoDominio>${pa}</identificativoDominio>
      </ws:nodoPAChiediInformativaPA>
  </soapenv:Body>
  </soapenv:Envelope>`};


export function nodoPAChiediInformativaPA(baseUrl, rndAnagPa) {

  console.debug(nodoPAChiediInformativaPAReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA));
  let res = http.post(getBasePath(baseUrl, "nodoPAChiediInformativaPA"),
    nodoPAChiediInformativaPAReqBody(rndAnagPa.PA, rndAnagPa.INTPA, rndAnagPa.STAZPA),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'nodoPAChiediInformativaPA' }),
      tags: { nodoPAChiediInformativaPA: 'http_req_duration', ALL: 'http_req_duration', primitiva: "nodoPAChiediInformativaPA" }
    }
  );

  console.debug("nodoPAChiediInformativaPA RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'nodoPAChiediInformativaPA:over_sla300': (r) => r.timings.duration > 300,
  },
    { nodoPAChiediInformativaPA: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'nodoPAChiediInformativaPA:over_sla400': (r) => r.timings.duration > 400,
  },
    { nodoPAChiediInformativaPA: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'nodoPAChiediInformativaPA:over_sla500': (r) => r.timings.duration > 500,
  },
    { nodoPAChiediInformativaPA: 'over_sla500', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoPAChiediInformativaPA:over_sla600': (r) => r.timings.duration > 600,
  },
    { nodoPAChiediInformativaPA: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'nodoPAChiediInformativaPA:over_sla800': (r) => r.timings.duration > 800,
  },
    { nodoPAChiediInformativaPA: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'nodoPAChiediInformativaPA:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { nodoPAChiediInformativaPA: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let outcome = '';
  let description = '';
  let xmlInformativa = '';
  try {
    const doc = parseHTML(res.body);
    const script = doc.find('stato');
    const script1 = doc.find('faultCode');
    const script2 = doc.find('description');
    const script3 = doc.find('xmlInformativa');
    outcome = script1.text();
    description = script2.text();
    xmlInformativa = script3.text();
  } catch (error) { }

  check(
    res,
    {
      //'nodoPAChiediInformativaPA:ok_rate': (r) => r.status == 200,
      'nodoPAChiediInformativaPA:ok_rate': (r) => xmlInformativa,
    },
    { nodoPAChiediInformativaPA: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {
      //'nodoPAChiediInformativaPA:ko_rate': (r) => r.status !== 200,
      'nodoPAChiediInformativaPA:ko_rate': (r) => !xmlInformativa,
    },
    { nodoPAChiediInformativaPA: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail("errore PAchiediInformativaPA : " + outcome + ' --> ' + description);
  }

  return res;

}