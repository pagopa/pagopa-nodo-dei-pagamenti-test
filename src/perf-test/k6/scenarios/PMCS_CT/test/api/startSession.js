import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';


export const startSession_Trend = new Trend('startSession');
export const All_Trend = new Trend('ALL');



export function startSession(baseUrl,tokenIO) {
 
  console.log("startSession request ["+baseUrl+'/pp-restapi-CD/v1/users/actions/start-session?token='+tokenIO+"]")
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v1/users/actions/start-session?token='+tokenIO,
    { headers: { 'Content-Type': 'application/json' } ,
	tags: { startSession: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
	console.log("------startSession response-----");
	console.log(res);
	console.log("------startSession response end-----");
   startSession_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);


   check(res, {
 	'startSession:over_sla300': (r) => r.timings.duration >300,
   },
   { startSession: 'over_sla300', ALL: 'over_sla300'}
   );
   
   check(res, {
 	'startSession:over_sla400': (r) => r.timings.duration >400,
   },
   { startSession: 'over_sla400', ALL: 'over_sla400' }
   );
   
   check(res, {
 	'startSession:over_sla500 ': (r) => r.timings.duration >500,
   },
   { startSession: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'startSession:over_sla600': (r) => r.timings.duration >600,
   },
   { startSession: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'startSession:over_sla800': (r) => r.timings.duration >800,
   },
   { startSession: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'startSession:over_sla1000': (r) => r.timings.duration >1000,
   },
   { startSession: 'over_sla1000' , ALL: 'over_sla1000'}
   );



  //console.log(res);
  let result={};
  let out = '';
  result.token='NA';
  try{
  out= res.body.toString();
  result.token=res.json().data.sessionToken;
  }catch(error){}



   check(
    res,
    {
    
	 'startSession:ok_rate': (r) =>  out.includes(`"status":"REGISTERED_SPID"`),
    },
    { startSession: 'ok_rate', ALL: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'startSession:ko_rate': (r) => ! out.includes(`"status":"REGISTERED_SPID"`),
    },
    { startSession: 'ko_rate', ALL: 'ko_rate' }
  );
    
  return result;
   
}

