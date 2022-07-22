import http from 'k6/http';
import { check } from 'k6';
import { sleep } from 'k6';
 
export function ob_CC_Check_2(baseUrl, idTr) {
 
  console.log(Date.now());
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v3/webview/checkout/check?id='+idTr+'&_='+Date.now(),
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded' } ,
	tags: { ob_CC_Check_2: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  sleep(1-(res.timings.duration/1000));
  
  check(res, {
 	'ob_CC_Check_2:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_Check_2: 'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_Check_2:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_Check_2: 'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_Check_2:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_Check_2: 'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_Check_2:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_Check_2: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_Check_2:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_Check_2: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_Check_2:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_Check_2: 'over_sla1000' }
   );
  
  
   let statusTr = res['statusMessage'];
   	 
   check(
    res,
    {
    
	 'ob_CC_Check_2:ok_rate': (r) =>  statusTr !== undefined,
    },
    { ob_CC_Check_2: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_Check_2:ko_rate': (r) => statusTr == undefined,
    },
    { ob_CC_Check_2: 'ko_rate' }
  );
    
  return res;
   
}

