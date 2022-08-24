import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';


export const ob_CC_continueToStep1_Trend = new Trend('ob_CC_continueToStep1');
export const All_Trend = new Trend('ALL');



export function ob_CC_continueToStep1(baseUrl, idTr, threeDSMethodData) {

 let body= {"transId":idTr,"methodCompleted":"Y","threeDSMethodData":threeDSMethodData}
 
 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/checkout/continueToStep1',
	JSON.stringify(body),
    { headers: { 'Content-Type': 'application/json', 'Sec-Fetch-Dest': 'empty', 'Sec-Fetch-Mode': 'cors', 'Sec-Fetch-Site': 'same-origin',
	'Upgrade-Insecure-Requests': '1', 'X-Requested-With':'XMLHttpRequest'},
    tags: { ob_CC_continueToStep1:'http_req_duration', ALL:'http_req_duration'}	
	}
  );


  All_Trend.add(res.timings.duration);
  ob_CC_continueToStep1_Trend.add(res.timings.duration);
  
    check(res, {
 	'ob_CC_continueToStep1:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_continueToStep1: 'over_sla300' , ALL:'over_sla300'}
   );
   
   check(res, {
 	'ob_CC_continueToStep1:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_continueToStep1: 'over_sla400' , ALL:'over_sla400'}
   );
   
   check(res, {
 	'ob_CC_continueToStep1:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_continueToStep1: 'over_sla500' , ALL:'over_sla500'}
   );
   
   check(res, {
 	'ob_CC_continueToStep1:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_continueToStep1: 'over_sla600' , ALL:'over_sla600'}
   );
   
   check(res, {
 	'ob_CC_continueToStep1:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_continueToStep1: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_continueToStep1:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_continueToStep1: 'over_sla1000' , ALL:'over_sla1000'}
   );
   
     
   check(
    res,
    {
    
	 'ob_CC_continueToStep1:ok_rate': (r) => res.status === 200,
    },
    { ob_CC_continueToStep1: 'ok_rate', ALL:'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_continueToStep1:ko_rate': (r) => res.status !== 200,
    },
    { ob_CC_continueToStep1: 'ko_rate', ALL:'ko_rate' }
  );
  
  return res;
   
}

