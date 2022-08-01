import http from 'k6/http';
import { check } from 'k6';

/*
export function onboardReqBody(cardNumber, scdMese, scdAnno){


return `
{
    "data": {
        "type":"CREDIT_CARD",
        "creditCard":{
            "holder":"Nome Cognome",
            "pan":cardNumber,//5255000010002856
            "expireMonth":scdMese,
            "expireYear":scdAnno
        }
    }
} `

};*/

  

export function ob_CC_Onboard(baseUrl,token, rndCard, scdMese, scdAnno) {
 
 let body =
 {
     "data": {
         "type":"CREDIT_CARD",
         "creditCard":{
             "holder":"Nome Cognome",
             "pan":rndCard,//5255000010002856
             "expireMonth":scdMese,
             "expireYear":scdAnno
         }
     }
 } ;

 const res = http.post(
    baseUrl+'/pp-restapi-CD/v1/wallet/cc',
	JSON.stringify(body),
    { headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer '+token } ,
	tags: { ob_CC_Onboard: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_CC_Onboard:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_Onboard: 'over_sla300' , ALL:'over_sla300'}
   );
   
   check(res, {
 	'ob_CC_Onboard:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_Onboard: 'over_sla400' , ALL:'over_sla400'}
   );
   
   check(res, {
 	'ob_CC_Onboard:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_Onboard: 'over_sla500' , ALL:'over_sla500'}
   );
   
   check(res, {
 	'ob_CC_Onboard:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_Onboard: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_Onboard:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_Onboard: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_Onboard:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_Onboard: 'over_sla1000' , ALL:'over_sla1000'}
   );

    let outcome=undefined;
    //console.log(res);
    let result={};
    try{
    outcome= res.json().data.idWallet;
    result.outcome=outcome;
    result.status=res.status;
    }catch(error){
    outcome=undefined;
    result.outcome=outcome;
    result.status=res.status;
    }


   check(
    res,
    {
    
	 'ob_CC_Onboard:ok_rate': (r) => outcome !== undefined,
    },
    { ob_CC_Onboard: 'ok_rate' , ALL:'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'ob_CC_Onboard:ko_rate': (r) => outcome == undefined,
    },
    { ob_CC_Onboard: 'ko_rate', ALL:'ko_rate' }
  );
  
  return result;
   
}

