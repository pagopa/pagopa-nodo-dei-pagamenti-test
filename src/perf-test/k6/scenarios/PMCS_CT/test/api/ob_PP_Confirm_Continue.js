import http from 'k6/http';
import { check } from 'k6';

  

export function ob_PP_Confirm_Continue(baseUrl, RED_Path) {
 

 //console.log('ob_PP_Confirm_Continue='+baseUrl+RED_Path);
 const res = http.get(
    baseUrl+RED_Path,
    //'https://api.dev.platform.pagopa.it/pp-restapi-CD/v3/webview/paypal/onboarding/continue/58896a04-b2ee-4b83-9940-a46207ec2848?esito=1&email_pp=the***@****.com&id_pp=31406&sha_val=d40b1a8cde0526f68b5af41b4753cf0015550eceeda3e50f4ebc8c73ef39dbbc',
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
	redirects: 0,
	tags: { ob_PP_Confirm_Continue:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_Confirm_Continue: 'over_sla300', ALL: 'over_sla300' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_Confirm_Continue: 'over_sla400' , ALL: 'over_sla400'}
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_Confirm_Continue: 'over_sla500', ALL: 'over_sla500' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_Confirm_Continue: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_Confirm_Continue: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Continue:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_Confirm_Continue: 'over_sla1000', ALL: 'over_sla1000' }
   );
   
   //console.log("continue header...");
   //console.log(res);
   //console.log(res.headers);
   let redirect=undefined;
   RED_Path = "NA";
   let result={};
   try{
   const headers= res.headers;
   redirect = headers['Location'];
   }catch(error){}

   result.RED_Path = "NA";
   if(redirect !== undefined){
   try{
      RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));
      //RED_Path=redirect.substr(redirect.indexOf("/mock-psp"));
      result.RED_Path = RED_Path;
   }catch(error){}
   }



   check(
    res,
    {
    
	 'ob_PP_Confirm_Continue:ok_rate': (r) => redirect !== undefined,
    },
    { ob_PP_Confirm_Continue: 'ok_rate', ALL: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_PP_Confirm_Continue:ko_rate': (r) => redirect === undefined,
    },
    { ob_PP_Confirm_Continue: 'ko_rate' , ALL: 'ko_rate' }
  );
  
  return result;
   
   
}

