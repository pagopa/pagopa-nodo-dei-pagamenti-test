import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';


export const closePayment_Trend = new Trend('closePayment');
export const All_Trend = new Trend('ALL');


export function closePaymentReqBody(psp, intpsp, chpsp_c, paymentToken, outcome, transactionId, additionalTransactionId){

var dt = new Date();
let ms = dt.getMilliseconds();

var timezone_offset_min = dt.getTimezoneOffset()-120,
	offset_hrs = parseInt(Math.abs(timezone_offset_min/60)),
	offset_min = Math.abs(timezone_offset_min%60),
	timezone_standard;

if(offset_hrs < 10)
	offset_hrs = '0' + offset_hrs;

if(offset_min < 10)
	offset_min = '0' + offset_min;


if(timezone_offset_min < 0)
	timezone_standard = '+' + offset_hrs + ':' + offset_min;
else if(timezone_offset_min > 0)
	timezone_standard = '-' + offset_hrs + ':' + offset_min;
else if(timezone_offset_min == 0)
	timezone_standard = 'Z';

//console.debug(timezone_standard); 

dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" +  ("0" + dt.getDate()).slice(-2) + "T" + 
("0" + dt.getHours() ).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2)+ "." + ms + timezone_standard;

return `
{
    "paymentTokens": [
        "${paymentToken}"
    ],
    "outcome": "${outcome}",
    "identificativoPsp": "${psp}",
    "tipoVersamento": "BPAY",
    "identificativoIntermediario": "${intpsp}",
    "identificativoCanale": "${chpsp_c}",
    "pspTransactionId": "${transactionId}",
    "totalAmount": 2.00,
    "fee": 1.00,
    "timestampOperation": "${dt}",
    "additionalPaymentInformations": {
        "transactionId": "${additionalTransactionId}", //925676 o 025676 
        "outcomePaymentGateway": "EFF",
        "authorizationCode": "yenhcunuy37dhu3n7fhjer783hc"
    }
}
`
};

export function closePayment(baseUrl,rndAnagPsp,paymentToken, outcome, transactionId, additionalTransactionId) {

 var dt = new Date();
 let ms = dt.getMilliseconds();

 var timezone_offset_min = dt.getTimezoneOffset()-120,
 	offset_hrs = parseInt(Math.abs(timezone_offset_min/60)),
 	offset_min = Math.abs(timezone_offset_min%60),
 	timezone_standard;

 if(offset_hrs < 10)
 	offset_hrs = '0' + offset_hrs;

 if(offset_min < 10)
 	offset_min = '0' + offset_min;


 if(timezone_offset_min < 0)
 	timezone_standard = '+' + offset_hrs + ':' + offset_min;
 else if(timezone_offset_min > 0)
 	timezone_standard = '-' + offset_hrs + ':' + offset_min;
 else if(timezone_offset_min == 0)
 	timezone_standard = 'Z';

 //console.debug(timezone_standard);

 dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" +  ("0" + dt.getDate()).slice(-2) + "T" +
 ("0" + dt.getHours() ).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2)+ "." + ms + timezone_standard;



  let body={
               "paymentTokens": [
                   paymentToken
               ],
               "outcome": outcome,
               "identificativoPsp": rndAnagPsp.PSP,
               "tipoVersamento": "BPAY",
               "identificativoIntermediario": rndAnagPsp.INTPSP,
               "identificativoCanale": rndAnagPsp.CHPSP_C,
               "pspTransactionId": transactionId,
               "totalAmount": 2.00,
               "fee": 1.00,
               "timestampOperation": dt,
               "additionalPaymentInformations": {
                   "transactionId": additionalTransactionId, //925676 o 025676
                   "outcomePaymentGateway": "EFF",
                   "authorizationCode": "yenhcunuy37dhu3n7fhjer783hc"
               }
           };


 const res = http.post(
    baseUrl+'/v1/closepayment',
    //JSON.stringify(closePaymentReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken, outcome, transactionId, additionalTransactionId)),
    JSON.stringify(body),
    { headers: { 'Content-Type': 'application/json' } ,
	tags: { closePayment: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  console.debug("closePayment RES");
  console.debug(res);


  closePayment_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);


   check(res, {
 	'closePayment:over_sla300': (r) => r.timings.duration >300,
   },
   { closePayment: 'over_sla300' , ALL: 'over_sla300'}
   );
   
   check(res, {
 	'closePayment:over_sla400': (r) => r.timings.duration >400,
   },
   { closePayment: 'over_sla400', ALL: 'over_sla400' }
   );
   
   check(res, {
 	'closePayment:over_sla500 ': (r) => r.timings.duration >500,
   },
   { closePayment: 'over_sla500' , ALL: 'over_sla500'}
   );
   
   check(res, {
 	'closePayment:over_sla600': (r) => r.timings.duration >600,
   },
   { closePayment: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'closePayment:over_sla800': (r) => r.timings.duration >800,
   },
   { closePayment: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'closePayment:over_sla1000': (r) => r.timings.duration >1000,
   },
   { closePayment: 'over_sla1000' , ALL: 'over_sla1000' }
   );

   let esito='';
   try{
   esito= res["esito"];
   }catch(error){}
    
   check(
    res,
    {
    
	 'closePayment:ok_rate': (r) => esito == 'OK',
    },
    { closePayment: 'ok_rate', ALL: 'ok_rate' }
	);
 
  if(check(
    res,
    {
     
	  'closePayment:ko_rate': (r) => esito !== 'OK',
    },
    { closePayment: 'ko_rate', ALL: 'ko_rate'}
  )){
	fail("esito != ok: "+esito);
	}
  
  return res;
   
}

