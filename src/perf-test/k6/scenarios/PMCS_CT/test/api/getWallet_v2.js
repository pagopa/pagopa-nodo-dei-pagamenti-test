import http from 'k6/http';
import { check } from 'k6';

export function getWallet_v2(baseUrl,token) {
 
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v2/wallet',
    { headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer '+token } ,
	tags: { getWallet_v2: 'http_req_duration', ALL: 'http_req_duration'}
	}
	
	
  );
   check(res, {
 	'getWallet_v2:over_sla300': (r) => r.timings.duration >300,
   },
   { getWallet_v2: 'over_sla300' }
   );
   
   check(res, {
 	'getWallet_v2:over_sla400': (r) => r.timings.duration >400,
   },
   { getWallet_v2: 'over_sla400' }
   );
   
   check(res, {
 	'getWallet_v2:over_sla500 ': (r) => r.timings.duration >500,
   },
   { getWallet_v2: 'over_sla500' }
   );
   
   check(res, {
 	'getWallet_v2:over_sla600': (r) => r.timings.duration >600,
   },
   { getWallet_v2: 'over_sla600' }
   );
   
   check(res, {
 	'getWallet_v2:over_sla800': (r) => r.timings.duration >800,
   },
   { getWallet_v2: 'over_sla800' }
   );
   
   check(res, {
 	'getWallet_v2:over_sla1000': (r) => r.timings.duration >1000,
   },
   { getWallet_v2: 'over_sla1000' }
   );
  
   // res.status = 200; //to comment
  	 
   check(
    res,
    {
    
	 'getWallet_v2:ok_rate': (r) =>  res.status==200,
    },
    { getWallet_v2: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'getWallet_v2:ko_rate': (r) => res.status!==200,
    },
    { getWallet_v2: 'ko_rate' }
  );
    
  return res;
   
}

