import http from 'k6/http';
import { check } from 'k6';


export function reqBody( rndSecCode){


return `
securityCode=${rndSecCode}&browserJavaEnabled=false&browserLanguage=en-US&browserColorDepth=24&browserScreenHeight=1080&browserScreenWidth=1920&browserTZ=-60
`
};


export function pay_CC_PayINternal(baseUrl, rndSecCode) {
 
 
 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/transactions/payInternal',
	reqBody( rndSecCode),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: { pay_CC_PayINternal: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  check(res, {
 	'pay_CC_PayINternal:over_sla300': (r) => r.timings.duration >300,
   },
   { pay_CC_PayINternal: 'over_sla300' }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla400': (r) => r.timings.duration >400,
   },
   { pay_CC_PayINternal: 'over_sla400' }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla500 ': (r) => r.timings.duration >500,
   },
   { pay_CC_PayINternal: 'over_sla500' }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla600': (r) => r.timings.duration >600,
   },
   { pay_CC_PayINternal: 'over_sla600' }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla800': (r) => r.timings.duration >800,
   },
   { pay_CC_PayINternal: 'over_sla800' }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla1000': (r) => r.timings.duration >1000,
   },
   { pay_CC_PayINternal: 'over_sla1000' }
   );
  
   const headers= res.headers;
   let redirect = headers['Location'];
   let idTr='NA';
   try{
   if (redirect!=undefined){
   //vars.put("RED_Path", vars.get("redirect").substring(vars.get("redirect").indexOf("/pp-restapi-CD")));
   idTr=redirect.substr(redirect.indexOf("id=")+3);
   }
   }catch(err){idTr='NA';}
   
   check(
    res,
    {
    
	 'pay_CC_PayINternal:ok_rate': (r) =>  idTr !== 'NA',
    },
    { pay_CC_PayINternal: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'pay_CC_PayINternal:ko_rate': (r) => idTr == 'NA',
    },
    { pay_CC_PayINternal: 'ko_rate' }
  );
    
  return res;
   
}

