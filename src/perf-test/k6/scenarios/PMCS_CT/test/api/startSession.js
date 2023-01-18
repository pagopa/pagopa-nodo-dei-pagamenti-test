import http from 'k6/http';
import { check } from 'k6';

export function startSession(baseUrl,tokenIO) {
 
  
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v1/users/actions/start-session?token='+tokenIO,
    { headers: { 'Content-Type': 'application/json' } ,
	tags: { startSession: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   check(res, {
 	'startSession:over_sla300': (r) => r.timings.duration >300,
   },
   { startSession: 'over_sla300' }
   );
   
   check(res, {
 	'startSession:over_sla400': (r) => r.timings.duration >400,
   },
   { startSession: 'over_sla400' }
   );
   
   check(res, {
 	'startSession:over_sla500 ': (r) => r.timings.duration >500,
   },
   { startSession: 'over_sla500' }
   );
   
   check(res, {
 	'startSession:over_sla600': (r) => r.timings.duration >600,
   },
   { startSession: 'over_sla600' }
   );
   
   check(res, {
 	'startSession:over_sla800': (r) => r.timings.duration >800,
   },
   { startSession: 'over_sla800' }
   );
   
   check(res, {
 	'startSession:over_sla1000': (r) => r.timings.duration >1000,
   },
   { startSession: 'over_sla1000' }
   );
  
  
  	 
   check(
    res,
    {
    
	 'startSession:ok_rate': (r) =>  res.body.toString().includes(`"status":"REGISTERED_SPID"`),
    },
    { startSession: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'startSession:ko_rate': (r) => !res.body.toString().includes(`"status":"REGISTERED_SPID"`),
    },
    { startSession: 'ko_rate' }
  );
    
  return res;
   
}

