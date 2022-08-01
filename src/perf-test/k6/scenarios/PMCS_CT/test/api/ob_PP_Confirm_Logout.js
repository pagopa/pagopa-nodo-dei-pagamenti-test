import http from 'k6/http';
import { check } from 'k6';

  

export function ob_PP_Confirm_Logout(baseUrl, RED_Path) {
 

 //console.log('ob_PP_Confirm_Logout='+baseUrl+RED_Path);
 const res = http.get(
    baseUrl+RED_Path,
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'},
	tags: { ob_PP_Confirm_Logout:'http_req_duration', ALL:'http_req_duration'}
	}
  );
  
   check(res, {
 	'ob_PP_Confirm_Logout:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_Confirm_Logout: 'over_sla300' , ALL:'over_sla300' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Logout:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_Confirm_Logout: 'over_sla400' , ALL:'over_sla400' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Logout:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_Confirm_Logout: 'over_sla500'  , ALL:'over_sla500'}
   );
   
   check(res, {
 	'ob_PP_Confirm_Logout:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_Confirm_Logout: 'over_sla600' , ALL:'over_sla600' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Logout:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_Confirm_Logout: 'over_sla800' , ALL:'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_Confirm_Logout:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_Confirm_Logout: 'over_sla1000' , ALL:'over_sla1000'}
   );
   

   let redirect=undefined;
   RED_Path = "NA";
   let result={};
   try{
   const headers= res.headers;
   redirect = headers['Location'];
   }catch(error){}

   result.RED_Path=RED_Path;
   if(redirect !== undefined){
   try{
   	 RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));
   	 result.RED_Path=RED_Path;
   }catch(err){}
   }


   
   check(
    res,
    {
    
	 'ob_PP_Confirm_Logout:ok_rate': (r) => redirect !== undefined,
    },
    { ob_PP_Confirm_Logout: 'ok_rate', ALL:'ok_rate'  }
	);
 
  check(
    res,
    {
     
	 'ob_PP_Confirm_Logout:ko_rate': (r) => redirect === undefined,
    },
    { ob_PP_Confirm_Logout: 'ko_rate', ALL:'ko_rate' }
  );
  
  return result;
   
   
}

