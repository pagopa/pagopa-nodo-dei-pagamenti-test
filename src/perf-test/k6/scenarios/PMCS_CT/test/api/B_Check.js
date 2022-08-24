import http from 'k6/http';
import { check } from 'k6';
import { sleep } from 'k6';
import { Trend } from 'k6/metrics';



export const B_Check_Trend = new Trend('B_Check');
export const All_Trend = new Trend('ALL');

export function B_Check(baseUrl, idTr) {

 //console.log("idTr Bcheck="+idTr);
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v3/webview/checkout/check?id='+idTr+'&_='+Date.now(),
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: { B_Check: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  B_Check_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);
  sleep(1-(res.timings.duration/1000));

  check(res, {
 	'B_Check:over_sla300': (r) => r.timings.duration >300,
   },
   { B_Check: 'over_sla300' , ALL: 'over_sla300'}
   );
   
   check(res, {
 	'B_Check:over_sla400': (r) => r.timings.duration >400,
   },
   { B_Check: 'over_sla400', ALL: 'over_sla400' }
   );
   
   check(res, {
 	'B_Check:over_sla500 ': (r) => r.timings.duration >500,
   },
   { B_Check: 'over_sla500', ALL: 'over_sla500' }
   );
   
   check(res, {
 	'B_Check:over_sla600': (r) => r.timings.duration >600,
   },
   { B_Check: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'B_Check:over_sla800': (r) => r.timings.duration >800,
   },
   { B_Check: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'B_Check:over_sla1000': (r) => r.timings.duration >1000,
   },
   { B_Check: 'over_sla1000' , ALL: 'over_sla1000'}
   );
  
   //console.log(res);
   let statusTr=undefined;
   let result={};
   result.statusTr=statusTr;
   try{
   statusTr = res.json().statusMessage;
   console.log("statusTr Bcheck="+statusTr);
   result.statusTr=statusTr;
   }catch(error){}



   check(
    res,
    {
    
	 'B_Check:ok_rate': (r) =>  statusTr !== undefined,
    },
    { B_Check: 'ok_rate' , ALL: 'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'B_Check:ko_rate': (r) => statusTr == undefined,
    },
    { B_Check: 'ko_rate' , ALL: 'ko_rate'}
  );
    
  return result;
   
}

