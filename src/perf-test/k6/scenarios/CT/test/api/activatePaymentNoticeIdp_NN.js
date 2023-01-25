import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath } from "../util/base_path_util.js";


export const activatePaymentNoticeIdp_NN_Trend = new Trend('activatePaymentNoticeIdp_NN');
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

export function activatePaymentNoticeIdp_NN(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey, paymentNote) {
 
 let res=http.post(getBasePath(baseUrl, "activatePaymentNotice"),
    activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey, paymentNote),
    { headers: { 'Content-Type': 'text/xml', 'SOAPAction':'activatePaymentNotice' } ,
	tags: { activatePaymentNoticeIdp_NN: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  
  console.debug("activatePaymentNoticeIdp_NN RES");
  console.debug(res);

  activatePaymentNoticeIdp_NN_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

   check(res, {
 	'activatePaymentNoticeIdp_NN:over_sla300': (r) => r.timings.duration >300,
   },
   { activatePaymentNoticeIdp_NN: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'activatePaymentNoticeIdp_NN:over_sla400': (r) => r.timings.duration >400,
   },
   { activatePaymentNoticeIdp_NN: 'over_sla400', ALL:'over_sla400' }
   );
      
   check(res, {
 	'activatePaymentNoticeIdp_NN:over_sla500': (r) => r.timings.duration >500,
   },
   { activatePaymentNoticeIdp_NN: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'activatePaymentNoticeIdp_NN:over_sla600': (r) => r.timings.duration >600,
   },
   { activatePaymentNoticeIdp_NN: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'activatePaymentNoticeIdp_NN:over_sla800': (r) => r.timings.duration >800,
   },
   { activatePaymentNoticeIdp_NN: 'over_sla800', ALL:'over_sla800' }
   );

   check(res, {
 	'activatePaymentNoticeIdp_NN:over_sla1000': (r) => r.timings.duration >1000,
   },
   { activatePaymentNoticeIdp_NN: 'over_sla1000', ALL:'over_sla1000' }
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



   check(
    res,
    {
     
	  'activatePaymentNoticeIdp_NN:ok_rate': (r) => outcome == 'OK' && result.paymentToken != undefined && result.paymentToken !=='',
    },
    { activatePaymentNoticeIdp_NN: 'ok_rate', ALL:'ok_rate' }
	);
		
	if(check(
    res,
    {
    
	  'activatePaymentNoticeIdp_NN:ko_rate': (r) => outcome != 'OK' || result.paymentToken == undefined || result.paymentToken ==='',
    },
    { activatePaymentNoticeIdp_NN: 'ko_rate', ALL:'ko_rate'}
  )){
	fail('result.paymentToken undefined or empty: '+ result.paymentToken + "or outcome != ok "+ outcome);
	}
   
     return result;
}
