import http from 'k6/http';
import { SharedArray } from 'k6/data';
import { check } from 'k6';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';


export function verifyIntReqBody(){

return 'browserJavaEnabled=false&browserLanguage=en-US&browserColorDepth=24&browserScreenHeight=1080&browserScreenWidth=1920&browserTZ=-120'
};


  

export function ob_CC_VerifyInternal(baseUrl) {
 

 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/transactions/cc/verifyInternal',
	verifyIntReqBody(),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': '*/*'} ,
	redirects: 0,
	tags: { ob_CC_VerifyInternal:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_CC_VerifyInternal:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_VerifyInternal: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_VerifyInternal: 'over_sla400' , ALL:'over_sla400'}
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_VerifyInternal: 'over_sla500' , ALL:'over_sla500'}
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_VerifyInternal: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_VerifyInternal: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_VerifyInternal:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_VerifyInternal: 'over_sla1000', ALL:'over_sla1000' }
   );

   console.log(res);
   //console.log("headers="+res.headers['Date']);

   let idTr = "NA";
   let RED_Path = "NA";
   let result={};
   try{
   const headers= res.headers;
   console.log(res);
   let redirect = headers['Location'];

   result.RED_Path=RED_Path;
   result.idTr=idTr;
   if(redirect !== undefined){
	 idTr=redirect.substr(redirect.indexOf("id=")+3);
	 result.idTr=idTr;
     RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));
     result.RED_Path=RED_Path;
   }
   }catch(err){}

   
   check(
    res,
    {
    
	 'ob_CC_VerifyInternal:ok_rate': (r) => idTr !== 'NA',
    },
    { ob_CC_VerifyInternal: 'ok_rate' , ALL:'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'ob_CC_VerifyInternal:ko_rate': (r) => idTr == 'NA',
    },
    { ob_CC_VerifyInternal: 'ko_rate', ALL:'ko_rate' }
  );
  
  return result;
   
}

