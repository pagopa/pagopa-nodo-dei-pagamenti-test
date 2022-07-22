import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";

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
<paymentNote>responseFull</paymentNote>
</nod:activatePaymentNoticeReq>
</soapenv:Body>
</soapenv:Envelope>`};

export function activatePaymentNotice_IDMP(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey) {
 
 let res=http.post(baseUrl+'?soapAction=activatePaymentNotice',
    activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { activatePaymentNotice_IDMP: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  //console.log(res);
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla300': (r) => r.timings.duration >300,
   },
   { activatePaymentNotice_IDMP: 'over_sla300' }
   );
   
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla400': (r) => r.timings.duration >400,
   },
   { activatePaymentNotice_IDMP: 'over_sla400' }
   );
      
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla500': (r) => r.timings.duration >500,
   },
   { activatePaymentNotice_IDMP: 'over_sla500' }
   );
   
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla600': (r) => r.timings.duration >600,
   },
   { activatePaymentNotice_IDMP: 'over_sla600' }
   );
   
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla800': (r) => r.timings.duration >800,
   },
   { activatePaymentNotice_IDMP: 'over_sla800' }
   );
   
   check(res, {
 	'activatePaymentNotice_IDMP:over_sla1000': (r) => r.timings.duration >1000,
   },
   { activatePaymentNotice_IDMP: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('outcome');
  const outcome = script.text();
  
  if(outcome=='KO'){
  console.log("activateIDP REQuest----------------"+ activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey)); 
  console.log("activateIDP RESPONSE----------------"+res.body);
  } 
  
   check(
    res,
    {
      'activatePaymentNotice_IDMP:ok_rate': (r) => outcome == 'OK',
    },
    { activatePaymentNotice_IDMP: 'ok_rate' }
	);
	
	 check(
    res,
    {
      'activatePaymentNotice_IDMP:ko_rate': (r) => outcome !== 'OK',
    },
    { activatePaymentNotice_IDMP: 'ko_rate' }
  );
   
     return res;
}