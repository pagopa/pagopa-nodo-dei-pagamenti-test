import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath } from "../util/base_path_util.js";



export const activatePaymentNotice_NN_Trend = new Trend('activatePaymentNotice_NN');
export const All_Trend = new Trend('ALL');

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
 
 let res=http.post(getBasePath(baseUrl, "activatePaymentNotice"),
    activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey, paymentNote),
    { headers: { 'Content-Type': 'text/xml', 'SOAPAction':'activatePaymentNotice', 'x-forwarded-for':'10.6.189.192' } ,
	tags: { activatePaymentNotice_NN: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  
  console.debug("activatePaymentNotice_NN RES");
  console.debug(res);
  
  activatePaymentNotice_NN_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);


   check(res, {
 	'activatePaymentNotice_NN:over_sla300': (r) => r.timings.duration >300,
   },
   { activatePaymentNotice_NN: 'over_sla300', ALL: 'over_sla300' }
   );
   
   check(res, {
 	'activatePaymentNotice_NN:over_sla400': (r) => r.timings.duration >400,
   },
   { activatePaymentNotice_NN: 'over_sla400', ALL: 'over_sla400' }
   );
      
   check(res, {
 	'activatePaymentNotice_NN:over_sla500': (r) => r.timings.duration >500,
   },
   { activatePaymentNotice_NN: 'over_sla500', ALL: 'over_sla500' }
   );
   
   check(res, {
 	'activatePaymentNotice_NN:over_sla600': (r) => r.timings.duration >600,
   },
   { activatePaymentNotice_NN: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'activatePaymentNotice_NN:over_sla800': (r) => r.timings.duration >800,
   },
   { activatePaymentNotice_NN: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'activatePaymentNotice_NN:over_sla1000': (r) => r.timings.duration >1000,
   },
   { activatePaymentNotice_NN: 'over_sla1000', ALL: 'over_sla1000'  }
   );

  let outcome='';
  let paymentToken='';
  let result={};
  result.paymentToken=paymentToken;
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  outcome = script.text();
  script = doc.find('paymentToken');
  paymentToken = script.text();
  result.paymentToken=paymentToken;
  }catch(error){}
  //console.debug("activatepaymentNotice="+outcome);



/*
  if(outcome=='KO'){
  //console.debug("activateNN REQuest----------------"+ activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey, paymentNote));
  //console.debug("activateNN RESPONSE----------------"+res.body);
  }*/
  
   check(
    res,
    {
     
	  'activatePaymentNotice_NN:ok_rate': (r) => outcome == 'OK' && paymentToken != undefined || paymentToken !== '',
    },
    { activatePaymentNotice_NN: 'ok_rate', ALL: 'ok_rate'  }
	);

	if(check(
    res,
    {
    
	  'activatePaymentNotice_NN:ko_rate': (r) => paymentToken == undefined || paymentToken === '' || outcome !== 'OK',
    },
    { activatePaymentNotice_NN: 'ko_rate', ALL: 'ko_rate' }
  )){
	fail("unexpected value for paymentToken/outcome. paymentToken  "+ paymentToken+" outcome "+ outcome);
}
   
     return result;
}
