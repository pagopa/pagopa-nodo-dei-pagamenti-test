import http from 'k6/http';
import { check } from 'k6';

  

export function ob_PP_pspInternal(baseUrl, token) {
 

 
 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/paypal/onboarding/pspInternal',
	'',
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
	tags: { ob_PP_pspInternal:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_PP_pspInternal:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_pspInternal: 'over_sla300',ALL: 'over_sla300' }
   );
   
   check(res, {
 	'ob_PP_pspInternal:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_pspInternal: 'over_sla400',ALL: 'over_sla400' }
   );
   
   check(res, {
 	'ob_PP_pspInternal:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_pspInternal: 'over_sla500',ALL: 'over_sla500' }
   );
   
   check(res, {
 	'ob_PP_pspInternal:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_pspInternal: 'over_sla600',ALL: 'over_sla600' }
   );
   
   check(res, {
 	'ob_PP_pspInternal:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_pspInternal: 'over_sla800',ALL: 'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_pspInternal:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_pspInternal: 'over_sla1000',ALL: 'over_sla1000' }
   );
   
  //console.log(res);
  let redUrlPP='NA';
  let pp_id_back='NA';
  let result={};
  try{
  redUrlPP= res.json().data.redirectUrl;
  }catch(error){
  redUrlPP='NA';
  }
  //let redUrlPP= res["data.redirectUrl"];
  try{
   if(redUrlPP!=='NA'){
 	  pp_id_back=redUrlPP.substr(redUrlPP.indexOf("id_back=")+8);
 	  result.redUrlPP=pp_id_back;
   }
   }catch(error){result.redUrlPP='NA';}

   console.log(res.body);
    //redUrlPP='htpp:/jfjfjffj.com/jgj?ere=1'; //to comment

   check(
    res,
    {
    
	 'ob_PP_pspInternal:ok_rate': (r) => redUrlPP.includes(baseUrl), //'10.6.189.28'
    },
    { ob_PP_pspInternal: 'ok_rate' ,ALL: 'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'ob_PP_pspInternal:ko_rate': (r) => !redUrlPP.includes(baseUrl),
    },
    { ob_PP_pspInternal: 'ko_rate',ALL: 'ko_rate' }
  );
  
  return result;
   
   
}

