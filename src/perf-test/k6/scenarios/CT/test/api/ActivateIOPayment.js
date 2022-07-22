import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";

export function activateIOPaymentReqBody (psp, pspint, chpsp, cf, noticeNumber, idempotencyKey) {
 
 var today = new Date();

 var dd = String(today.getDate()).padStart(2, '0');
 var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
 var yyyy = today.getFullYear();
 today = yyyy + '-' + mm + '-' + dd;

	
	return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <nod:activateIOPaymentReq>
         <idPSP>${psp}</idPSP>
         <idBrokerPSP>${pspint}</idBrokerPSP>
         <idChannel>${chpsp}</idChannel>
         <password>pwdpwdpwd</password>
         <idempotencyKey>${idempotencyKey}</idempotencyKey>
         <qrCode>
            <fiscalCode>${cf}</fiscalCode>
            <noticeNumber>${noticeNumber}</noticeNumber>
         </qrCode>
         <expirationTime>60000</expirationTime>
         <amount>1.00</amount>
         <dueDate>${today}</dueDate>
         <paymentNote>2</paymentNote>
      </nod:activateIOPaymentReq>
   </soapenv:Body>
</soapenv:Envelope>
`};

export function ActivateIOPayment(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey) {
 
 let res=http.post(baseUrl+'?soapAction=ActivateIOPayment',
    activateIOPaymentReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPaNew.CF , noticeNmbr, idempotencyKey),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { ActivateIOPayment: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  //console.log(res);
   check(res, {
 	'ActivateIOPayment:over_sla300': (r) => r.timings.duration >300,
   },
   { ActivateIOPayment: 'over_sla300' }
   );
   
   check(res, {
 	'ActivateIOPayment:over_sla400': (r) => r.timings.duration >400,
   },
   { ActivateIOPayment: 'over_sla400' }
   );
      
   check(res, {
 	'ActivateIOPayment:over_sla500': (r) => r.timings.duration >500,
   },
   { ActivateIOPayment: 'over_sla500' }
   );
   
   check(res, {
 	'ActivateIOPayment:over_sla600': (r) => r.timings.duration >600,
   },
   { ActivateIOPayment: 'over_sla600' }
   );
   
   check(res, {
 	'ActivateIOPayment:over_sla800': (r) => r.timings.duration >800,
   },
   { ActivateIOPayment: 'over_sla800' }
   );
   
   check(res, {
 	'ActivateIOPayment:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ActivateIOPayment: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('outcome');
  const outcome = script.text();
  
  if(outcome=='KO'){
  console.log("ActivateIOPayment REQuest----------------"+activateIOPaymentReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPaNew.CF , noticeNmbr, idempotencyKey)); 
  console.log("ActivateIOPayment RESPONSE----------------"+res.body);
  }
  
   check(
    res,
    {
      //'ActivateIOPayment:ok_rate': (r) => r.status == 200,
	  'ActivateIOPayment:ok_rate': (r) => outcome == 'OK',
    },
    { ActivateIOPayment: 'ok_rate' }
	);
	
	 check(
    res,
    {
      //'ActivateIOPayment:ko_rate': (r) => r.status !== 200,
	  'ActivateIOPayment:ko_rate': (r) => outcome !== 'OK',
    },
    { ActivateIOPayment: 'ko_rate' }
  );
   
     return res;
}