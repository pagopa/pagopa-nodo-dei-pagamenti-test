import http from 'k6/http';
import { check } from 'k6';

export function resume3ds2ReqBody(rndCres){

return `
cres=${rndCres}
`
};

  

export function ob_CC_resume3ds2(baseUrl, idTr, rndCres) {
 

 
 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/checkout/'+idTr+'/resume3ds2',
	resume3ds2ReqBody(rndCres),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: { ob_CC_resume3ds2: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  check(res, {
 	'ob_CC_resume3ds2:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_resume3ds2: 'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_resume3ds2:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_resume3ds2: 'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_resume3ds2:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_resume3ds2: 'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_resume3ds2:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_resume3ds2: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_resume3ds2:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_resume3ds2: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_resume3ds2:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_resume3ds2: 'over_sla1000' }
   );
  
   	 
   check(
    res,
    {
    
	 'ob_CC_resume3ds2:ok_rate': (r) =>  res.status == 200,
    },
    { ob_CC_resume3ds2: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_resume3ds2:ko_rate': (r) => res.status !== 200,
    },
    { ob_CC_resume3ds2: 'ko_rate' }
  );
    
  return res;
   
}

