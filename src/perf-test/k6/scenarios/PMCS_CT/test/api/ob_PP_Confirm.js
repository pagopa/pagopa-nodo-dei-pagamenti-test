import http from 'k6/http';
import { check } from 'k6';
import { URL } from 'https://jslib.k6.io/url/1.0.0/index.js';

  

export function ob_PP_Confirm(baseUrlPM) {
 

 const url = new URL(baseUrlPM+'/paypalweb/management/success');

 url.searchParams.append('paypalEmail', 'thea.peslegrini@example.com');
 url.searchParams.append('paypalId', '31406');
//url.searchParams.append('paypalEmail', 'gavino.grassi@example.com');/
//url.searchParams.append('paypalId', 'S21EL');
 url.searchParams.append('selectRedirect', 'true');


 const res = http.get(
    url.toString(),
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
	redirects: 0,
	tags: { ob_PP_Confirm:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_PP_Confirm:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_Confirm: 'over_sla300' ,ALL: 'over_sla300'}
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_Confirm: 'over_sla400',ALL: 'over_sla400' }
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_Confirm: 'over_sla500',ALL: 'over_sla500' }
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_Confirm: 'over_sla600' ,ALL: 'over_sla600'}
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_Confirm: 'over_sla800',ALL: 'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_Confirm:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_Confirm: 'over_sla1000', ALL: 'over_sla1000' }
   );

   let result={};
   let RED_Path = "NA";
   let headers= '';
   let redirect = undefined;
   //console.log(res);
   try{
    headers= res.headers;
    redirect = headers['Location'];
    }catch(error){}

   //console.log("redirect in ppConfirm="+redirect);

  try{
     if(redirect !== undefined){
   	 result.RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));
   	 //result.RED_Path=redirect;
     }
   }catch(error){}

   //console.log(result.RED_Path);
   
   check(
    res,
    {
    
	 'ob_PP_Confirm:ok_rate': (r) => redirect !== undefined,
    },
    { ob_PP_Confirm: 'ok_rate', ALL: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_PP_Confirm:ko_rate': (r) => redirect === undefined,
    },
    { ob_PP_Confirm: 'ko_rate' , ALL: 'ko_rate'}
  );
  
  return result;
   
   
}

