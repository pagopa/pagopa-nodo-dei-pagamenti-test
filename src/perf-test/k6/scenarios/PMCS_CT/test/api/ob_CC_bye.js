import http from 'k6/http';
import { check } from 'k6';

 
export function ob_CC_bye(baseUrl, RED_Path) {
 

 const res = http.get(
    baseUrl+RED_Path,
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: {ob_CC_bye: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  
  check(res, {
 	'ob_CC_bye:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_bye: 'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_bye:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_bye: 'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_bye:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_bye: 'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_bye:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_bye: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_bye:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_bye: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_bye:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_bye: 'over_sla1000' }
   );
  
  
   let esitoTrEdt = 'NA';
   if (RED_Path!=="NA"){
   esitoTrEdt = RED_Path.substr(RED_Path.indexOf("outcome=")+8);
   }
   	 
   check(
    res,
    {
    
	 'ob_CC_bye:ok_rate': (r) =>  esitoTrEdt == '0',
    },
    { ob_CC_bye: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_bye:ko_rate': (r) => esitoTrEdt !== '0',
    },
    { ob_CC_bye: 'ko_rate' }
  );
    
  return res;
   
}

