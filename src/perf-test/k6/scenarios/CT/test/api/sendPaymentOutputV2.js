import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';


export const sendPaymentOutputV2_Trend = new Trend('sendPaymentOutputV2');
export const All_Trend = new Trend('ALL');


export function sendPaymentOutputV2ReqBody(psp, intpsp, chpsp, idempotencyKey, paymentToken){
	
let today = new Date();
let tomorrow = new Date();
tomorrow.setDate(tomorrow.getDate() + 1)

let dd = String(today.getDate()).padStart(2, '0');
let mm = String(today.getMonth() + 1).padStart(2, '0');
let yyyy = today.getFullYear();
today = yyyy + '-' + mm + '-' + dd;

let dd_ = String(tomorrow.getDate()).padStart(2, '0');
let mm_ = String(tomorrow.getMonth() + 1).padStart(2, '0');
let yyyy_ = tomorrow.getFullYear();
tomorrow = yyyy_ + '-' + mm_ + '-' + dd_;

return `
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
        <ns2:sendPaymentOutcomeV2Request xmlns:ns2="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <idPSP>${psp}</idPSP>
         <idBrokerPSP>${intpsp}</idBrokerPSP>
         <idChannel>${chpsp}</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>${idempotencyKey}</idempotencyKey>
        <paymentTokens>
                <paymentToken>${paymentToken}</paymentToken>
            </paymentTokens>
            <outcome>OK</outcome>
            <details>
                <paymentMethod>creditCard</paymentMethod>
                <fee>0.01</fee>
	<primaryCiIncurredFee>15.73</primaryCiIncurredFee>
	<idBundle>15.73</idBundle>
	<idCiBundle>15.73</idCiBundle>
	<applicationDate>${today}</applicationDate>
            <transferDate>${tomorrow}</transferDate>
            </details>
        </ns2:sendPaymentOutcomeV2Request>
    </soap:Body>
</soap:Envelope>
`
};

export function sendPaymentOutputV2(baseUrl,rndAnagPsp, idempotencyKey, paymentToken) {
 
 const res = http.post(
    baseUrl,
    sendPaymentOutputV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP,idempotencyKey, paymentToken),
    { headers: { 'Content-Type': 'text/xml', 'SOAPAction': 'sendPaymentOutcomeV2' } ,
	tags: { sendPaymentOutcome: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  console.debug("sendPaymentOutputV2 RES");
  console.debug(res);

  sendPaymentOutputV2_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);
   
   check(res, {
 	'sendPaymentOutputV2:over_sla300': (r) => r.timings.duration >300,
   },
   { sendPaymentOutputV2: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'sendPaymentOutputV2:over_sla400': (r) => r.timings.duration >400,
   },
   { sendPaymentOutputV2: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'sendPaymentOutputV2:over_sla500 ': (r) => r.timings.duration >500,
   },
   { sendPaymentOutputV2: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'sendPaymentOutputV2:over_sla600': (r) => r.timings.duration >600,
   },
   { sendPaymentOutputV2: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'sendPaymentOutputV2:over_sla800': (r) => r.timings.duration >800,
   },
   { sendPaymentOutputV2: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'sendPaymentOutputV2:over_sla1000': (r) => r.timings.duration >1000,
   },
   { sendPaymentOutputV2: 'over_sla1000', ALL:'over_sla1000' }
   );


  let outcome;

  try{
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  outcome = script.text();
  }catch(error){
    console.log(error)
  }
  check(
    res,
    {
	  'sendPaymentOutputV2:ok_rate': (r) => outcome == 'OK',
    },
    { sendPaymentOutputV2: 'ok_rate', ALL:'ok_rate' }
	);
 
  if(check(
    res,
    {
	  'sendPaymentOutputV2:ko_rate': (r) => outcome != 'OK',
    },
    { sendPaymentOutputV2: 'ko_rate' , ALL:'ko_rate'}
  )){
	fail("Outcome != ok: " + outcome);
	}
  
  return res;
   
}
