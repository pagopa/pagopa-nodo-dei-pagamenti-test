import http from 'k6/http';
import { check } from 'k6';

export function verifyReqBody(idWallet, token){

return `
idWallet=${idWallet}&securityCode=555&sessionToken=${token}&language=&Request-Id=
`
};

  

export function ob_CC_Verify(baseUrl, idWallet, token) {
 

 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/transactions/cc/verify',
	verifyReqBody(idWallet, token),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: { ob_CC_Verify: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_CC_Verify:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_Verify: 'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_Verify:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_Verify: 'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_Verify:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_Verify: 'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_Verify:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_Verify: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_Verify:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_Verify: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_Verify:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_Verify: 'over_sla1000' }
   );
  
    
   check(
    res,
    {
    
	 'ob_CC_Verify:ok_rate': (r) => res.toString().includes('DOCTYPE html'), 
    },
    { ob_CC_Verify: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_Verify:ko_rate': (r) => !res.toString().includes('DOCTYPE html'),
    },
    { ob_CC_Verify: 'ko_rate' }
  );
  
  return res;
   
}

