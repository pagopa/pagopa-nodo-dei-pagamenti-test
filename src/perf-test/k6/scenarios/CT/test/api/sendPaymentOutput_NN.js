import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';



export const sendPaymentOutput_NN_Trend = new Trend('sendPaymentOutput_NN');
export const All_Trend = new Trend('ALL');

export function sendPaymentOutputReqBody(psp, intpsp, chpsp, paymentToken){
	
var today = new Date();
var tomorrow = new Date();
tomorrow.setDate(tomorrow.getDate() + 1)

//console.log(tomorrow);
var dd = String(today.getDate()).padStart(2, '0');
var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
var yyyy = today.getFullYear();
today = yyyy + '-' + mm + '-' + dd;

var dd_ = String(tomorrow.getDate()).padStart(2, '0');
var mm_ = String(tomorrow.getMonth() + 1).padStart(2, '0'); //January is 0!
var yyyy_ = tomorrow.getFullYear();
tomorrow = yyyy_ + '-' + mm_ + '-' + dd_;

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

export function sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken) {
 //console.log("VERIFY="+noticeNmbr);
 
 const res = http.post(
    baseUrl+'?soapAction=sendPaymentOutcome',
    sendPaymentOutputReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, paymentToken),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { sendPaymentOutcome_NN: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   sendPaymentOutput_NN_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);

   check(res, {
 	'sendPaymentOutcome_NN:over_sla300': (r) => r.timings.duration >300,
   },
   { sendPaymentOutcome_NN: 'over_sla300' , ALL:'over_sla300'}
   );
   
   check(res, {
 	'sendPaymentOutcome_NN:over_sla400': (r) => r.timings.duration >400,
   },
   { sendPaymentOutcome_NN: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'sendPaymentOutcome_NN:over_sla500 ': (r) => r.timings.duration >500,
   },
   { sendPaymentOutcome_NN: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'sendPaymentOutcome_NN:over_sla600': (r) => r.timings.duration >600,
   },
   { sendPaymentOutcome_NN: 'over_sla600' , ALL:'over_sla600'}
   );
   
   check(res, {
 	'sendPaymentOutcome_NN:over_sla800': (r) => r.timings.duration >800,
   },
   { sendPaymentOutcome_NN: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'sendPaymentOutcome_NN:over_sla1000': (r) => r.timings.duration >1000,
   },
   { sendPaymentOutcome_NN: 'over_sla1000', ALL:'over_sla1000' }
   );


  let outcome='';
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  outcome = script.text();
  }catch(error){}

  /*if(outcome=='KO'){
  console.log("sendOutcomeNN REQuest----------------"+ sendPaymentOutputReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, paymentToken)); 
  console.log("sendOutcomeNN RESPONSE----------------"+res.body);
  }*/
  
   check(
    res,
    {
    
	  'sendPaymentOutcome_NN:ok_rate': (r) => outcome == 'OK',
    },
    { sendPaymentOutcome_NN: 'ok_rate' , ALL:'ok_rate'}
	);
 
  check(
    res,
    {
      
	  'sendPaymentOutcome_NN:ko_rate': (r) => outcome !== 'OK',
    },
    { sendPaymentOutcome_NN: 'ko_rate', ALL:'ko_rate' }
  );
  
  return res;
   
}

