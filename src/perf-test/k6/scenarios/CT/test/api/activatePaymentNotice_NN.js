import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";

export function activateReqBody (psp, pspint, chpsp, cfpa, noticeNmbr, idempotencyKey, paymentNote) {
  	
var today = new Date();

var dd = String(today.getDate()).padStart(2, '0');
var mm = String(today.getMonth() + 1).padStart(2, '0'); 
var yyyy = today.getFullYear();
today = yyyy + '-' + mm + '-' + dd;

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
         <expirationTime>600000</expirationTime>
         <amount>1.00</amount>
         <dueDate>${today}</dueDate>
         <paymentNote>${paymentNote}</paymentNote>
      </nod:activatePaymentNoticeReq>
   </soapenv:Body>
</soapenv:Envelope>
`};

export function activatePaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey, paymentNote) {
 
 let res=http.post(baseUrl+'?soapAction=activatePaymentNotice',
    activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey, paymentNote),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { activatePaymentNotice_NN: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  //console.log(res);
   check(res, {
 	'activatePaymentNotice_NN:over_sla300': (r) => r.timings.duration >300,
   },
   { activatePaymentNotice_NN: 'over_sla300' }
   );
   
   check(res, {
 	'activatePaymentNotice_NN:over_sla400': (r) => r.timings.duration >400,
   },
   { activatePaymentNotice_NN: 'over_sla400' }
   );
      
   check(res, {
 	'activatePaymentNotice_NN:over_sla500': (r) => r.timings.duration >500,
   },
   { activatePaymentNotice_NN: 'over_sla500' }
   );
   
   check(res, {
 	'activatePaymentNotice_NN:over_sla600': (r) => r.timings.duration >600,
   },
   { activatePaymentNotice_NN: 'over_sla600' }
   );
   
   check(res, {
 	'activatePaymentNotice_NN:over_sla800': (r) => r.timings.duration >800,
   },
   { activatePaymentNotice_NN: 'over_sla800' }
   );
   
   check(res, {
 	'activatePaymentNotice_NN:over_sla1000': (r) => r.timings.duration >1000,
   },
   { activatePaymentNotice_NN: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('outcome');
  const outcome = script.text();
  
  /*if(outcome=='KO'){
  console.log("activateNN REQuest----------------"+ activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey, paymentNote)); 
  console.log("activateNN RESPONSE----------------"+res.body);
  }*/
  
   check(
    res,
    {
     
	  'activatePaymentNotice_NN:ok_rate': (r) => outcome == 'OK',
    },
    { activatePaymentNotice_NN: 'ok_rate' }
	);
	
	 check(
    res,
    {
    
	  'activatePaymentNotice_NN:ko_rate': (r) => outcome !== 'OK',
    },
    { activatePaymentNotice_NN: 'ko_rate' }
  );
   
     return res;
}