import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('verificaBollettino');
export const All_Trend = new Trend('ALL');

export function verificaBollettinoReqBody(cfpa, noticeNmbr) {

  return `
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
  <soapenv:Header/>
  <soapenv:Body>
  <nod:verificaBollettinoReq>
    <idPSP>POSTE3</idPSP>
    <idBrokerPSP>BANCOPOSTA</idBrokerPSP>
    <idChannel>POSTE3</idChannel>
  <password>pwdpwdpwd</password>
  <ccPost>0${cfpa}</ccPost>
  <noticeNumber>${noticeNmbr}</noticeNumber>
  </nod:verificaBollettinoReq>
  </soapenv:Body>
  </soapenv:Envelope>`};


export function verificaBollettino(baseUrl, rndAnagPa, noticeNmbr) {

  console.debug(verificaBollettinoReqBody(rndAnagPa.CF, noticeNmbr));
  let res = http.post(getBasePath(baseUrl, "verificaBollettino"),
    verificaBollettinoReqBody(rndAnagPa.CF, noticeNmbr),
    {
      headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'verificaBollettino' }),
      tags: { verificaBollettino: 'http_req_duration', ALL: 'http_req_duration', primitiva: "verificaBollettino" }
    }
  );

  console.debug("verificaBollettino RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

  check(res, {
    'verificaBollettino:over_sla300': (r) => r.timings.duration > 300,
  },
    { verificaBollettino: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'verificaBollettino:over_sla400': (r) => r.timings.duration > 400,
  },
    { verificaBollettino: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'verificaBollettino:over_sla500': (r) => r.timings.duration > 500,
  },
    { verificaBollettino: 'over_sla500', ALL: 'over_sla600' }
  );

  check(res, {
    'verificaBollettino:over_sla600': (r) => r.timings.duration > 600,
  },
    { verificaBollettino: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'verificaBollettino:over_sla800': (r) => r.timings.duration > 800,
  },
    { verificaBollettino: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'verificaBollettino:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { verificaBollettino: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let outcome='';
  try{
  const doc = parseHTML(res.body);
  const script = doc.find('outcome');
  outcome = script.text();
  }catch(error){}

  /*
    if(outcome=='KO'){
    console.debug("activate REQuest----------------"+verificaBollettinoReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey)); 
    console.debug("activate RESPONSE----------------"+res.body);
    } */
  
    check(
        res,
        {
          //'verificaBollettino:ok_rate': (r) => r.status == 200,
          'verificaBollettino:ok_rate': (r) => outcome == 'OK',
        },
        { verificaBollettino: 'ok_rate' , ALL:'ok_rate'}
        );
     
      if(check(
        res,
        {
          //'verificaBollettino:ko_rate': (r) => r.status !== 200,
          'verificaBollettino:ko_rate': (r) => outcome !== 'OK',
        },
        { verificaBollettino: 'ko_rate', ALL:'ko_rate' }
      )){
        fail("outcome != ok: "+outcome);
        }
      
      return res;
       
    }