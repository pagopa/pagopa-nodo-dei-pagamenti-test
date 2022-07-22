import http from 'k6/http';
import { SharedArray } from 'k6/data';
import { check } from 'k6';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';


export function verifyIntReqBody(){

return `
browserJavaEnabled=false&browserLanguage=en-US&browserColorDepth=24&browserScreenHeight=1080&browserScreenWidth=1920&browserTZ=-120
`
};


  

export function ob_CC_VerifyInternal(baseUrl) {
 

 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/transactions/cc/verifyInternal',
	verifyIntReqBody(),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: { ob_CC_VerifyInternal:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_CC_VerifyInternal:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_VerifyInternal: 'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_VerifyInternal: 'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_VerifyInternal: 'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_VerifyInternal: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_VerifyInternal: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_VerifyInternal: 'over_sla1000' }
   );
   
   //console.log(res);
   //console.log("headers="+res.headers['Date']);
   const headers= res.headers;
   let redirect = headers['Location'];
   let idTr = "NA";
   let RED_Path = "";
   if(redirect !== undefined){
	 //RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));
     idTr=redirect.substr(redirect.indexOf("id=")+3);  
   }
	
   
   check(
    res,
    {
    
	 'ob_CC_VerifyInternal:ok_rate': (r) => idTr !== 'NA',
    },
    { ob_CC_VerifyInternal: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_VerifyInternal:ko_rate': (r) => idTr == 'NA',
    },
    { ob_CC_VerifyInternal: 'ko_rate' }
  );
  
  return res;
   
}

