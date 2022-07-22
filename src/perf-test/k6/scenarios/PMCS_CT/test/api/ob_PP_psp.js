import http from 'k6/http';
import { check } from 'k6';



export function ob_PP_psp(baseUrl, token) {
  

  const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/paypal/onboarding/psp?idPsp=PAYPAL_PSP_MOCK_AZURE&sessionToken='+token,
	'',
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	tags: { ob_PP_psp: 'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_PP_psp:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_psp: 'over_sla300' }
   );
   
   check(res, {
 	'ob_PP_psp:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_psp: 'over_sla400' }
   );
   
   check(res, {
 	'ob_PP_psp:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_psp: 'over_sla500' }
   );
   
   check(res, {
 	'ob_PP_psp:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_psp: 'over_sla600' }
   );
   
   check(res, {
 	'ob_PP_psp:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_psp: 'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_psp:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_psp: 'over_sla1000' }
   );
   
  	
   
   check(
    res,
    {
    
	 'ob_PP_psp:ok_rate': (r) =>  r.status === 200,
    },
    { ob_PP_psp: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_PP_psp:ko_rate': (r) =>  r.status !== 200,
    },
    { ob_PP_psp: 'ko_rate' }
  );
  
  return res;
   
   
}

