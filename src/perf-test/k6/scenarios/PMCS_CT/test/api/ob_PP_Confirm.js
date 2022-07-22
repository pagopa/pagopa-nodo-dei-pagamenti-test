import http from 'k6/http';
import { check } from 'k6';

  

export function ob_PP_Confirm(baseUrlPM, pp_id_back) {
 

 
 const res = http.get(
    baseUrlPM+'/paypalweb/management/success?paypalEmail=thea.peslegrini%40example.com&paypalId=31406&selectRedirect=true',
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
	tags: { ob_PP_Confirm:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_PP_Confirm:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_Confirm: 'over_sla300' }
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_Confirm: 'over_sla400' }
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_Confirm: 'over_sla500' }
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_Confirm: 'over_sla600' }
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_Confirm: 'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_Confirm: 'over_sla1000' }
   );
   
   const headers= res.headers;
   let redirect = headers['Location'];
   
   
   check(
    res,
    {
    
	 'ob_PP_Confirm:ok_rate': (r) => redirect !== undefined,
    },
    { ob_PP_Confirm: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_PP_Confirm:ko_rate': (r) => redirect === undefined,
    },
    { ob_PP_Confirm: 'ko_rate' }
  );
  
  return res;
   
   
}

