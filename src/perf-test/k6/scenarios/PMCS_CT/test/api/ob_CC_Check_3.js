import http from 'k6/http';
import { check } from 'k6';
import { sleep } from 'k6';

 
export function ob_CC_Check_3(baseUrl, idTr) {
 
  console.log(Date.now());
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v3/webview/checkout/check?id='+idTr+'&_='+Date.now(),
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded' } ,
	tags: { ob_CC_Check_3: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  sleep(1-(res.timings.duration/1000));
  
  check(res, {
 	'ob_CC_Check_3:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_Check_3: 'over_sla300' , ALL:'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_Check_3:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_Check_3: 'over_sla400' , ALL:'over_sla400'}
   );
   
   check(res, {
 	'ob_CC_Check_3:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_Check_3: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_Check_3:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_Check_3: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_Check_3:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_Check_3: 'over_sla800' , ALL:'over_sla800'}
   );
   
   check(res, {
 	'ob_CC_Check_3:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_Check_3: 'over_sla1000', ALL:'over_sla1000' }
   );
  
  
   //let statusTr = res['statusMessage'];
   let statusTr=undefined;
   let result={};
   result.statusTr=statusTr;
   try{
   let subStMsg=res.body.substr(res.body.indexOf("statusMessage")+16);
   statusTr = subStMsg.split('"')[0];
   result.statusTr=statusTr;
   }catch(error){}


   check(
    res,
    {
    
	 'ob_CC_Check_3:ok_rate': (r) =>  statusTr !== undefined,
    },
    { ob_CC_Check_3: 'ok_rate', ALL:'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_Check_3:ko_rate': (r) => statusTr == undefined,
    },
    { ob_CC_Check_3: 'ko_rate', ALL:'ko_rate' }
  );
    
  return result;
   
}

