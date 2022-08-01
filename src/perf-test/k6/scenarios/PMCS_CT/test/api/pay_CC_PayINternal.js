import http from 'k6/http';
import { check } from 'k6';


export function reqBody( rndSecCode){

return 'securityCode='+rndSecCode+'&browserJavaEnabled=false&browserLanguage=en-US&browserColorDepth=24&browserScreenHeight=1080&browserScreenWidth=1920&browserTZ=-60'

};


export function pay_CC_PayINternal(baseUrl, rndSecCode) {
 
 
 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/transactions/payInternal',
	reqBody( rndSecCode),
	{ headers: {  'Content-Type': 'application/x-www-form-urlencoded', 'Accept': '*/*'} ,
	redirects: 0,
	tags: { pay_CC_PayINternal: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  check(res, {
 	'pay_CC_PayINternal:over_sla300': (r) => r.timings.duration >300,
   },
   { pay_CC_PayINternal: 'over_sla300' , ALL:'over_sla300' }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla400': (r) => r.timings.duration >400,
   },
   { pay_CC_PayINternal: 'over_sla400' , ALL:'over_sla400' }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla500 ': (r) => r.timings.duration >500,
   },
   { pay_CC_PayINternal: 'over_sla500', ALL:'over_sla500'  }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla600': (r) => r.timings.duration >600,
   },
   { pay_CC_PayINternal: 'over_sla600', ALL:'over_sla600'  }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla800': (r) => r.timings.duration >800,
   },
   { pay_CC_PayINternal: 'over_sla800', ALL:'over_sla800'  }
   );
   
   check(res, {
 	'pay_CC_PayINternal:over_sla1000': (r) => r.timings.duration >1000,
   },
   { pay_CC_PayINternal: 'over_sla1000', ALL:'over_sla1000' }
   );


   let redirect = undefined;
   let idTr='NA';
   let RED_Path='NA';
   try{
   let headers= res.headers;
   let redirect = headers['Location'];
   }catch(error){}

   let result={};
   result.idTr=idTr;
   result.RED_Path=RED_Path;
   if (redirect!=undefined){
   try{
   RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));
   result.RED_Path=RED_Path;
   idTr=redirect.substr(redirect.indexOf("id=")+3);
   result.idTr=idTr;
   }catch(err){}
   }
   console.log("red_path="+RED_Path);


   
   check(
    res,
    {
    
	 'pay_CC_PayINternal:ok_rate': (r) =>  idTr !== 'NA',
    },
    { pay_CC_PayINternal: 'ok_rate' , ALL:'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'pay_CC_PayINternal:ko_rate': (r) => idTr == 'NA',
    },
    { pay_CC_PayINternal: 'ko_rate', ALL:'ko_rate' }
  );
    
  return result;
   
}

