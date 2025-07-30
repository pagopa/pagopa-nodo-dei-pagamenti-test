import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";


export const activatePaymentNotice_IDMP_Trend = new Trend('activatePaymentNotice_IDMP');
export const All_Trend = new Trend('ALL');

export function activateReqBody (psp, pspint, chpsp, cfpa, noticeNmbr, idempotencyKey) {
  
	return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
<soapenv:Header/>
<soapenv:Body>
<nod:activatePaymentNoticeReq>
<idPSP>${psp}</idPSP>
<idBrokerPSP>${pspint}</idBrokerPSP>
<idChannel>${chpsp}</idChannel>
<password>pwdpwdpwd</password>
<idempotencyKey>${idempotencyKey}</idempotencyKey>
<qrCode>
<fiscalCode>${cfpa}</fiscalCode>
<noticeNumber>${noticeNmbr}</noticeNumber>
</qrCode>
<expirationTime>60000</expirationTime>
<amount>10.00</amount>
<dueDate>2056-01-27</dueDate>
<paymentNote>responseFull</paymentNote>
</nod:activatePaymentNoticeReq>
</soapenv:Body>
</soapenv:Envelope>`};

export function activatePaymentNotice_IDMP(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey) {
 
 let res=http.post(getBasePath(baseUrl, "activatePaymentNotice"),
    activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey),
    { headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction':'activatePaymentNotice' }) ,
	tags: { activatePaymentNotice_IDMP: 'http_req_duration' , ALL: 'http_req_duration', primitiva: "activatePaymentNotice"}
	}
  );
  console.debug("activatePaymentNotice_IDMP RES");
  console.debug(JSON.stringify(res));

  activatePaymentNotice_IDMP_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

   check(res, {
 	'activatePaymentNotice_IDMP:over_sla300': (r) => r.timings.duration >300,
   },
   { activatePaymentNotice_IDMP: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla400': (r) => r.timings.duration >400,
   },
   { activatePaymentNotice_IDMP: 'over_sla400', ALL:'over_sla400' }
   );
      
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla500': (r) => r.timings.duration >500,
   },
   { activatePaymentNotice_IDMP: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla600': (r) => r.timings.duration >600,
   },
   { activatePaymentNotice_IDMP: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla800': (r) => r.timings.duration >800,
   },
   { activatePaymentNotice_IDMP: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla1000': (r) => r.timings.duration >1000,
   },
   { activatePaymentNotice_IDMP: 'over_sla1000', ALL:'over_sla1000' }
   );
  let result={};
  let outcome='';
	let creditorReferenceId = undefined;
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  outcome = script.text();
  script = doc.find('paymentToken');
  result.paymentToken = script.text();
  script = doc.find('totalAmount');
  result.amount = script.text();
  script = doc.find('creditorReferenceId');
  creditorReferenceId = script.text();
  result.creditorReferenceId=creditorReferenceId;
  }catch(error){}
  /*
  if(outcome=='KO'){
  console.debug("activateIDP REQuest----------------"+ activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey)); 
  console.debug("activateIDP RESPONSE----------------"+res.body);
  }*/ 
  
   check(
    res,
    {
      'activatePaymentNotice_IDMP:ok_rate': (r) => outcome == 'OK',
    },
    { activatePaymentNotice_IDMP: 'ok_rate', ALL:'ok_rate' }
	);
	
	if(check(
    res,
    {
      'activatePaymentNotice_IDMP:ko_rate': (r) => outcome !== 'OK',
    },
    { activatePaymentNotice_IDMP: 'ko_rate', ALL:'ko_rate' }
  )){
	fail('outcome != ok '+ outcome);
	}
   console.debug("activatePaymentNotice_IDMP creditorReferenceId" + creditorReferenceId);
     return result;
}
