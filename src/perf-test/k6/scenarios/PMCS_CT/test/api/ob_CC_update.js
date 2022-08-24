import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';


export const ob_CC_update_Trend = new Trend('ob_CC_update');
export const All_Trend = new Trend('ALL');


export function ob_CC_update(baseUrl,token, rndCard, scdMese, scdAnno) {
 
 let body={
          "data": {
              "type":"CREDIT_CARD",
              "idPsp":"171474",
              "creditCard":{
                  "holder":"Nome Cognome",
                  "pan":rndCard,
                  "expireMonth":scdMese,
                  "expireYear":scdAnno
              }
          }
      };
 const res = http.post(
    baseUrl+'/pmmockserviceapi/3ds2.0-manager/challenge/save/response',
	JSON.stringify(body),
    { headers: { 'Content-Type': 'application/json', 'Authorization':'Bearer'+token} ,
	tags: { ob_CC_update: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );

  All_Trend.add(res.timings.duration);
  ob_CC_update.add(res.timings.duration);
  
   check(res, {
 	'ob_CC_update:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_update: 'over_sla300' , ALL: 'over_sla300'}
   );
   
   check(res, {
 	'ob_CC_update:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_update: 'over_sla400' , ALL: 'over_sla400'}
   );
   
   check(res, {
 	'ob_CC_update:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_update: 'over_sla500' , ALL: 'over_sla500'}
   );
   
   check(res, {
 	'ob_CC_update:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_update: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_update:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_update: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_update:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_update: 'over_sla1000', ALL: 'over_sla1000'  }
   );
  

   //let esito = res['data.saved'];
   let esito=undefined;
   console.log("CCupdate status..."+res.status)
   console.log(res.json());
   try{
       esito= res.json().data.saved;
   }catch(error){}


   check(
    res,
    {
    
	 'ob_CC_update:ok_rate': (r) =>  esito == true,
    },
    { ob_CC_update: 'ok_rate', ALL: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_update:ko_rate': (r) => esito !== true,
    },
    { ob_CC_update: 'ko_rate', ALL: 'ko_rate' }
  );
  
  return res;
   
}

