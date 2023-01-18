import http from 'k6/http';
import { check } from 'k6';

  

export function ob_PP_Confirm_Call(baseUrlPM, pp_id_back) {
 

 //console.log("ob_PP_Confirm_Call="+baseUrlPM+'/paypalweb/pp_onboarding_call?id_back='+pp_id_back);
 const res = http.get(
    baseUrlPM+'/paypalweb/pp_onboarding_call?id_back='+pp_id_back,
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
	tags: { ob_PP_Confirm_Call:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_PP_Confirm_Call:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_Confirm_Call: 'over_sla300' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Call:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_Confirm_Call: 'over_sla400' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Call:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_Confirm_Call: 'over_sla500' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Call:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_Confirm_Call: 'over_sla600' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Call:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_Confirm_Call: 'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Call:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_Confirm_Call: 'over_sla1000' }
   );
   
   
   check(
    res,
    {
    
	 'ob_PP_Confirm_Call:ok_rate': (r) => r.status === 200,
    },
    { ob_PP_Confirm_Call: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_PP_Confirm_Call:ko_rate': (r) => r.status !== 200,
    },
    { ob_PP_Confirm_Call: 'ko_rate' }
  );
  
  return res;
   
   
}

