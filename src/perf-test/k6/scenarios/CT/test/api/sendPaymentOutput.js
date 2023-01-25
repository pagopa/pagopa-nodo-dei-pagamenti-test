import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath } from "../util/base_path_util.js";


export const sendPaymentOutput_Trend = new Trend('sendPaymentOutput');
export const All_Trend = new Trend('ALL');


export function sendPaymentOutputReqBody(psp, intpsp, chpsp, paymentToken){
	
var today = new Date();
var tomorrow = new Date();
tomorrow.setDate(tomorrow.getDate() + 1)

//console.debug(tomorrow);
var dd = String(today.getDate()).padStart(2, '0');
var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
var yyyy = today.getFullYear();
today = yyyy + '-' + mm + '-' + dd;

var dd_ = String(tomorrow.getDate()).padStart(2, '0');
var mm_ = String(tomorrow.getMonth() + 1).padStart(2, '0'); //January is 0!
var yyyy_ = tomorrow.getFullYear();
tomorrow = yyyy_ + '-' + mm_ + '-' + dd_;
//<password>pwdpwdpwd</password>
return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
         <idPSP>${psp}</idPSP>
         <idBrokerPSP>${intpsp}</idBrokerPSP>
         <idChannel>${chpsp}</idChannel>
         <password>pwdpwdpwd</password>
         <paymentToken>${paymentToken}</paymentToken>
         <outcome>OK</outcome>
         <details>
            <paymentMethod>creditCard</paymentMethod>
            <fee>0.01</fee>
            <applicationDate>${today}</applicationDate>
            <transferDate>${tomorrow}</transferDate>
         </details>
      </nod:sendPaymentOutcomeReq>
   </soapenv:Body>
</soapenv:Envelope>
`
};

export function sendPaymentOutput(baseUrl,rndAnagPsp,paymentToken) {
 //console.debug("VERIFY="+noticeNmbr);
 
 const res = http.post(
    getBasePath(baseUrl, "sendPaymentOutcome"),
    sendPaymentOutputReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, paymentToken),
    { headers: { 'Content-Type': 'text/xml', 'SOAPAction': 'sendPaymentOutcome' } ,
	tags: { sendPaymentOutcome: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  console.debug("sendPaymentOutput RES");
  console.debug(res);

  sendPaymentOutput_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);
   
   check(res, {
 	'sendPaymentOutcome:over_sla300': (r) => r.timings.duration >300,
   },
   { sendPaymentOutcome: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'sendPaymentOutcome:over_sla400': (r) => r.timings.duration >400,
   },
   { sendPaymentOutcome: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'sendPaymentOutcome:over_sla500 ': (r) => r.timings.duration >500,
   },
   { sendPaymentOutcome: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'sendPaymentOutcome:over_sla600': (r) => r.timings.duration >600,
   },
   { sendPaymentOutcome: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'sendPaymentOutcome:over_sla800': (r) => r.timings.duration >800,
   },
   { sendPaymentOutcome: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'sendPaymentOutcome:over_sla1000': (r) => r.timings.duration >1000,
   },
   { sendPaymentOutcome: 'over_sla1000', ALL:'over_sla1000' }
   );


  let outcome='';
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  outcome = script.text();
  }catch(error){}
  /*if(outcome=='KO'){
  console.debug("SendPaymentOutput REq----------------"+sendPaymentOutputReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, paymentToken));
  console.debug("SendPaymentOutput RESPONSE----------------"+res.body);
  }*/



   check(
    res,
    {
      //'sendPaymentOutput:ok_rate': (r) => r.status == 200,
	  'sendPaymentOutcome:ok_rate': (r) => outcome == 'OK',
    },
    { sendPaymentOutcome: 'ok_rate', ALL:'ok_rate' }
	);
 
  if(check(
    res,
    {
      //'sendPaymentOutput:ko_rate': (r) => r.status !== 200,
	  'sendPaymentOutcome:ko_rate': (r) => outcome !== 'OK',
    },
    { sendPaymentOutcome: 'ko_rate' , ALL:'ko_rate'}
  )){
	fail("outcome != ok: "+outcome);
	}
  
  return res;
   
}

