import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";


export const ActivateIOPayment_Trend = new Trend('ActivateIOPayment');
export const All_Trend = new Trend('ALL');

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
 
 let res=http.post(getBasePath(baseUrl, "activateIOPayment"),
    activateIOPaymentReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPaNew.CF , noticeNmbr, idempotencyKey),
    { headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'activateIOPayment', 'Host':'api.prf.platform.pagopa.it'}) ,
	tags: { ActivateIOPayment: 'http_req_duration' , ALL: 'http_req_duration', primitiva: "activateIOPayment"}
	}
  );
  
  console.debug("ActivateIOPayment RES");
  console.debug(JSON.stringify(res));

  ActivateIOPayment_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

   check(res, {
 	'ActivateIOPayment:over_sla300': (r) => r.timings.duration >300,
   },
   { ActivateIOPayment: 'over_sla300', ALL: 'over_sla300' }
   );
   
   check(res, {
 	'ActivateIOPayment:over_sla400': (r) => r.timings.duration >400,
   },
   { ActivateIOPayment: 'over_sla400', ALL: 'over_sla400' }
   );
      
   check(res, {
 	'ActivateIOPayment:over_sla500': (r) => r.timings.duration >500,
   },
   { ActivateIOPayment: 'over_sla500', ALL: 'over_sla500' }
   );
   
   check(res, {
 	'ActivateIOPayment:over_sla600': (r) => r.timings.duration >600,
   },
   { ActivateIOPayment: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'ActivateIOPayment:over_sla800': (r) => r.timings.duration >800,
   },
   { ActivateIOPayment: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'ActivateIOPayment:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ActivateIOPayment: 'over_sla1000', ALL: 'over_sla1000' }
   );




    let outcome='';
    let paymentToken='';
    let result={};
    result.paymentToken=paymentToken;
    try{
    let doc = parseHTML(res.body);
    let script = doc.find('outcome');
    outcome = script.text();
    let scriptToken = doc.find('paymentToken');
    paymentToken = scriptToken.text();
    result.paymentToken=paymentToken;
    }catch(error){}

  /*
  if(outcome=='KO'){
  console.debug("ActivateIOPayment REQuest----------------"+activateIOPaymentReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPaNew.CF , noticeNmbr, idempotencyKey)); 
  console.debug("ActivateIOPayment RESPONSE----------------"+res.body);
  }*/
  
   check(
    res,
    {
      //'ActivateIOPayment:ok_rate': (r) => r.status == 200,
	  'ActivateIOPayment:ok_rate': (r) => outcome == 'OK' && paymentToken != undefined && paymentToken != '',
    },
    { ActivateIOPayment: 'ok_rate', ALL: 'ok_rate' }
	);
	
	if(check(
    res,
    {
      //'ActivateIOPayment:ko_rate': (r) => r.status !== 200,
	  'ActivateIOPayment:ko_rate': (r) => paymentToken == undefined || paymentToken === '' || outcome != 'OK',
	  
    },
    { ActivateIOPayment: 'ko_rate', ALL: 'ko_rate' }
  )){
	fail("unexpected value for paymentToken/outcome. paymentToken  "+ paymentToken+" outcome "+ outcome);
	}
   
     return result;
}
