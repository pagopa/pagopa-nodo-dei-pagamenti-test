import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";


export const activatePaymentNotice_Trend = new Trend('activatePaymentNotice');
export const All_Trend = new Trend('ALL');

export function activatePosteReqBody(cfpa, noticeNmbr, idempotencyKey) {
  //console.debug("noticeNmbr="+noticeNmbr+" |psp="+psp+" |pspint="+pspint+" |chpsp="+chpsp+" |idempotencyKey="+idempotencyKey+" |cfpa="+cfpa);
	
	return `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
<soapenv:Header/>
<soapenv:Body>
<nod:activatePaymentNoticeReq>
<idPSP>POSTE3</idPSP>
<idBrokerPSP>BANCOPOSTA</idBrokerPSP>
<idChannel>POSTE3</idChannel>
<password>pwdpwdpwd</password>
<idempotencyKey>${idempotencyKey}</idempotencyKey>
<qrCode>
<fiscalCode>${cfpa}</fiscalCode>
<noticeNumber>${noticeNmbr}</noticeNumber>
</qrCode>
<expirationTime>6000</expirationTime>
<amount>10.00</amount>
<dueDate>2056-01-26</dueDate>
<paymentNote>Test payment</paymentNote>
</nod:activatePaymentNoticeReq>
</soapenv:Body>
</soapenv:Envelope>`};

export function activatePaymentNotice(baseUrl,rndAnagPa,noticeNmbr,idempotencyKey) {
  
 console.debug( activatePosteReqBody(rndAnagPa.CF , noticeNmbr, idempotencyKey));
 let res=http.post(getBasePath(baseUrl, "activatePaymentNotice"),
    activatePosteReqBody(rndAnagPa.CF , noticeNmbr, idempotencyKey),
    { headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'activatePaymentNotice'}) ,
	tags: { activatePaymentNotice: 'http_req_duration' , ALL: 'http_req_duration', primitiva: "activatePaymentNotice"}
	}
  );
  
  console.debug("activatePaymentNotice RES");
  console.debug(JSON.stringify(res));

   activatePaymentNotice_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);

   check(res, {
 	'activatePaymentNotice:over_sla300': (r) => r.timings.duration >300,
   },
   { activatePaymentNotice: 'over_sla300', ALL: 'over_sla300' }
   );
   
   check(res, {
 	'activatePaymentNotice:over_sla400': (r) => r.timings.duration >400,
   },
   { activatePaymentNotice: 'over_sla400', ALL: 'over_sla400' }
   );
      
   check(res, {
 	'activatePaymentNotice:over_sla500': (r) => r.timings.duration >500,
   },
   { activatePaymentNotice: 'over_sla500', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'activatePaymentNotice:over_sla600': (r) => r.timings.duration >600,
   },
   { activatePaymentNotice: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'activatePaymentNotice:over_sla800': (r) => r.timings.duration >800,
   },
   { activatePaymentNotice: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'activatePaymentNotice:over_sla1000': (r) => r.timings.duration >1000,
   },
   { activatePaymentNotice: 'over_sla1000', ALL: 'over_sla1000' }
   );


  let outcome='';
  let paymentToken='';
  let creditorReferenceId='';
  let result={};
  result.paymentToken=paymentToken;
  result.creditorReferenceId=creditorReferenceId;
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  outcome = script.text();
  script = doc.find('paymentToken');
  paymentToken = script.text();
  result.paymentToken=paymentToken;
  script = doc.find('creditorReferenceId');
  creditorReferenceId = script.text();
  result.creditorReferenceId=creditorReferenceId;
  script = doc.find('totalAmount');
  result.amount = script.text();
  console.debug("activatePaymentNotice totalAmount: "+result.amount);
  }catch(error){}

/*
  if(outcome=='KO'){
  console.debug("activate REQuest----------------"+activatePosteReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr, idempotencyKey)); 
  console.debug("activate RESPONSE----------------"+res.body);
  } */ 


   check(
    res,
    {
      //'activatePaymentNotice:ok_rate': (r) => r.status == 200,
	  'activatePaymentNotice:ok_rate': (r) => outcome == 'OK' && result.creditorReferenceId != undefined && result.creditorReferenceId !== '',
    },
    { activatePaymentNotice: 'ok_rate', ALL: 'ok_rate' }
	);
	
	if(check(
    res,
    {
      //'activatePaymentNotice:ko_rate': (r) => r.status !== 200,
	  'activatePaymentNotice:ko_rate': (r) => result.creditorReferenceId == undefined || result.creditorReferenceId === '' || outcome !== 'OK',
    },
    { activatePaymentNotice: 'ko_rate', ALL: 'ko_rate' }
  )){
	fail('result.creditorReferenceId undefined or empty: '+ result.creditorReferenceId + "or outcome != OK: "+ outcome);
	}
   
     return result;
}
