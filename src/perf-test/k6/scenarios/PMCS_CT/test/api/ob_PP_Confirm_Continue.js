import http from 'k6/http';
import { check } from 'k6';

  

export function ob_PP_Confirm_Continue(baseUrl, RED_Path) {
 

 //console.log('ob_PP_Confirm_Continue='+baseUrl+RED_Path);
 const res = http.get(
    baseUrl+RED_Path,
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
	tags: { ob_PP_Confirm_Continue:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_Confirm_Continue: 'over_sla300' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_Confirm_Continue: 'over_sla400' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_Confirm_Continue: 'over_sla500' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_Confirm_Continue: 'over_sla600' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_Confirm_Continue: 'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_Confirm_Continue: 'over_sla1000' }
   );
   
   const headers= res.headers;
   let redirect = headers['Location'];
   
   check(
    res,
    {
    
	 'ob_PP_Confirm_Continue:ok_rate': (r) => redirect !== undefined,
    },
    { ob_PP_Confirm_Continue: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_PP_Confirm_Continue:ko_rate': (r) => redirect === undefined,
    },
    { ob_PP_Confirm_Continue: 'ko_rate' }
  );
  
  return res;
   
   
}

