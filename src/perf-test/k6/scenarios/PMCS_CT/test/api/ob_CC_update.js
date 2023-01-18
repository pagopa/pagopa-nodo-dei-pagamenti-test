import http from 'k6/http';
import { check } from 'k6';


export function updateReqBody(cardNumber, scdMese, scdAnno){


return `
{
    "data": {
        "type":"CREDIT_CARD",
        "idPsp":"171474",
        "creditCard":{
            "holder":"Nome Cognome",
            "pan":"${cardNumber}",
            "expireMonth":"${scdMese}",
            "expireYear":"${scdAnno}"
        }
    }
}
`
};


export function ob_CC_update(baseUrl,token, rndCard, scdMese, scdAnno) {
 
 
 const res = http.put(
    baseUrl+'/pmmockserviceapi/3ds2.0-manager/challenge/save/response',
	JSON.stringify(updateReqBody(rndCard, scdMese, scdAnno)),
    { headers: { 'Content-Type': 'application/json', 'Authorization':'Bearer'+token} ,
	tags: { ob_CC_update: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  
   check(res, {
 	'ob_CC_update:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_update: 'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_update:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_update: 'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_update:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_update: 'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_update:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_update: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_update:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_update: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_update:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_update: 'over_sla1000' }
   );
  
  
   let esito = res['data.saved'];
      	 
   check(
    res,
    {
    
	 'ob_CC_update:ok_rate': (r) =>  esito == true,
    },
    { ob_CC_update: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_update:ko_rate': (r) => esito !== true,
    },
    { ob_CC_update: 'ko_rate' }
  );
  
  return res;
   
}

