import http from 'k6/http';
import { check } from 'k6';
import encoding from 'k6/encoding';

 
export function pay_PP_Logout(baseUrl, idTr) {
 
 
 
 //idTr='aGVsbG8gd29ybGQ='; //to comment
 let idTrDec = encoding.b64decode(idTr, 'std', 's');
 //console.log("idTrDec==="+idTrDec);
 
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v3/webview/logout?id='+idTrDec,
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Sec-Fetch-Dest': 'document', 
	'Sec-Fetch-Mode': 'navigate', 'Sec-Fetch-Site': 'same-origin' } ,
	redirects: 0,
	tags: {pay_PP_Logout: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  
  check(res, {
 	'pay_PP_Logout:over_sla300': (r) => r.timings.duration >300,
   },
   { pay_PP_Logout: 'over_sla300', ALL: 'over_sla300' }
   );
   
   check(res, {
 	'pay_PP_Logout:over_sla400': (r) => r.timings.duration >400,
   },
   { pay_PP_Logout: 'over_sla400', ALL: 'over_sla400' }
   );
   
   check(res, {
 	'pay_PP_Logout:over_sla500 ': (r) => r.timings.duration >500,
   },
   { pay_PP_Logout: 'over_sla500' , ALL: 'over_sla500'}
   );
   
   check(res, {
 	'pay_PP_Logout:over_sla600': (r) => r.timings.duration >600,
   },
   { pay_PP_Logout: 'over_sla600' , ALL: 'over_sla600'}
   );
   
   check(res, {
 	'pay_PP_Logout:over_sla800': (r) => r.timings.duration >800,
   },
   { pay_PP_Logout: 'over_sla800', ALL: 'over_sla800'  }
   );
   
   check(res, {
 	'pay_PP_Logout:over_sla1000': (r) => r.timings.duration >1000,
   },
   { pay_PP_Logout: 'over_sla1000', ALL: 'over_sla1000' }
   );


   //console.log(res);
   let redirect=undefined;
   try{
   const headers= res.headers;
   redirect = headers['Location'];
   }catch(error){}

   let RED_Path='NA';
   idTr='NA';
   let result={};
   result.RED_Path=RED_Path;
   result.idTr=idTr;
   if(redirect !== undefined){
   try{
   		RED_Path = redirect.substr(redirect.indexOf("/pp-restapi-CD"));
   		result.RED_Path=RED_Path;
   		idTr = redirect.substr(redirect.indexOf("id=")+3);
   		result.idTr=idTr;
   }catch(err){}
   }

   	 
   check(
    res,
    {
    
	 'pay_PP_Logout:ok_rate': (r) =>  redirect !== undefined,
    },
    { pay_PP_Logout: 'ok_rate' , ALL: 'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'pay_PP_Logout:ko_rate': (r) => redirect == undefined,
    },
    { pay_PP_Logout: 'ko_rate', ALL: 'ko_rate' }
  );
    
  return result;
   
}

