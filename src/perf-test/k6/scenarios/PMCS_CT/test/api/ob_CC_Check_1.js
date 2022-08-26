import http from 'k6/http';
import { URL } from 'https://jslib.k6.io/url/1.0.0/index.js';
import { check } from 'k6';
import { sleep } from 'k6';
import { Trend } from 'k6/metrics';


export const ob_CC_Check_1_Trend = new Trend('ob_CC_Check_1');
export const All_Trend = new Trend('ALL');

 
export function ob_CC_Check_1(baseUrl, idTr) {
 
 const url = new URL(baseUrl+"/pp-restapi-CD/v3/webview/checkout/check");

 url.searchParams.append('id', idTr);
 url.searchParams.append('_', Date.now());


 const res = http.get(
    url.toString(),
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded' , 'Accept-Encoding':'gzip, deflate, br', 'Accept':'*/*'} ,
	redirects: 0,
	tags: { ob_CC_Check_1: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );


  All_Trend.add(res.timings.duration);
  ob_CC_Check_1_Trend.add(res.timings.duration);
  console.log(res.url);
   sleep(1-(res.timings.duration/1000));
   /*console.log("durInt="+res.timings.duration);
   console.log("dur="+res.timings.duration/1000);
   console.log("durDiff="+(1-(res.timings.duration/1000)));*/
  
   check(res, {
 	'ob_CC_Check_1:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_Check_1: 'over_sla300' , ALL:'over_sla300'}
   );
   
   check(res, {
 	'ob_CC_Check_1:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_Check_1: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_Check_1:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_Check_1: 'over_sla500' , ALL:'over_sla500'}
   );
   
   check(res, {
 	'ob_CC_Check_1:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_Check_1: 'over_sla600' , ALL:'over_sla600'}
   );
   
   check(res, {
 	'ob_CC_Check_1:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_Check_1: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_Check_1:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_Check_1: 'over_sla1000', ALL:'over_sla1000' }
   );
  
   console.log(res.body);
   let statusTr=undefined;
   let result={};
   try{
   let subStMsg=res.body.substr(res.body.indexOf("statusMessage")+16);
   statusTr = subStMsg.split('"')[0];
   result.statusTr=statusTr;
   let subPay=res.body.substr(res.body.indexOf("idPayment")+12);
   let idPayment = subPay.split('"')[0];
   result.idPayment=idPayment;
   }catch(error){result.statusTr=undefined}

   console.log("idTrans|"+idTr+"|");
   console.log("|"+statusTr+"|");
   console.log(res.body);
   //let statusTr = res['statusMessage'];
   //let statusTr=myJSON.json().statusMessage;





   check(
    res,
    {
    
	 'ob_CC_Check_1:ok_rate': (r) =>  statusTr !== undefined,
    },
    { ob_CC_Check_1: 'ok_rate', ALL:'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_Check_1:ko_rate': (r) => statusTr == undefined,
    },
    { ob_CC_Check_1: 'ko_rate', ALL:'ko_rate'}
  );
  
    
  return result;
   
}

