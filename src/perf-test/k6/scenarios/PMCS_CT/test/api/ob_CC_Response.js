import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';


export const ob_CC_Response_Trend = new Trend('ob_CC_Response');
export const All_Trend = new Trend('ALL');



export function ob_CC_Response(basePMUrl, threedstransId, token) {

 let body = {"threeDSServerTransID":threedstransId,"outcome":"00"};
 
 const res = http.post(
    basePMUrl+'/pmmockserviceapi/3ds2.0-manager/challenge/save/response',
	JSON.stringify(body),
    { headers: { 'Content-Type': 'application/json', 'Authorization':'Bearer'+token} ,
	tags: { ob_CC_Response: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );

  All_Trend.add(res.timings.duration);
  ob_CC_Response_Trend.add(res.timings.duration);

  check(res, {
 	'ob_CC_Response:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_Response: 'over_sla300'  , ALL:'over_sla300'}
   );
   
   check(res, {
 	'ob_CC_Response:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_Response: 'over_sla400'  , ALL:'over_sla400'}
   );
   
   check(res, {
 	'ob_CC_Response:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_Response: 'over_sla500'  , ALL:'over_sla500'}
   );
   
   check(res, {
 	'ob_CC_Response:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_Response: 'over_sla600' , ALL:'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_Response:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_Response: 'over_sla800'  , ALL:'over_sla800'}
   );
   
   check(res, {
 	'ob_CC_Response:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_Response: 'over_sla1000' , ALL:'over_sla1000'}
   );
  
   	 
   check(
    res,
    {
    
	 'ob_CC_Response:ok_rate': (r) =>  res.status == 200,
    },
    { ob_CC_Response: 'ok_rate' , ALL:'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'ob_CC_Response:ko_rate': (r) => res.status !== 200,
    },
    { ob_CC_Response: 'ko_rate', ALL:'ko_rate' }
  );
    
  return res;
   
}

