import http from 'k6/http';
import { check } from 'k6';

export function challengeReqBody(creq){

return `
creq=${creq}
`
};

  

export function ob_CC_Challenge(basePMUrl, creq) {
 

 
 const res = http.post(
    basePMUrl+'/pmmockserviceapi/issuer/3ds2.0/challenge',
	challengeReqBody(creq),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Upgrade-Insecure-Requests': '1'},
	tags: { ob_CC_Challenge: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  check(res, {
 	'ob_CC_Challenge:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_Challenge: 'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_Challenge: 'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_Challenge: 'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_Challenge: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_Challenge: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_Challenge: 'over_sla1000' }
   );
  
   	 
   check(
    res,
    {
    
	 'ob_CC_Challenge:ok_rate': (r) =>  res.status == 200,
    },
    { ob_CC_Challenge: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_Challenge:ko_rate': (r) => res.status !== 200,
    },
    { ob_CC_Challenge: 'ko_rate' }
  );
    
  return res;
}

