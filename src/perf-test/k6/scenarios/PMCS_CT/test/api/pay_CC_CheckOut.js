import http from 'k6/http';
import { check } from 'k6';

export function pay_CC_CheckOut(baseUrl, RED_Path) {
 
   
 const res = http.get(
    baseUrl+RED_Path,
   	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
   	redirects: 0,
	tags: { pay_CC_CheckOut: 'http_req_duration', ALL: 'http_req_duration'}
	}
	);
	
	
	check(res, {
 	'pay_CC_CheckOut:over_sla300': (r) => r.timings.duration >300,
   },
   { pay_CC_CheckOut: 'over_sla300', ALL: 'over_sla300' }
   );
   
   check(res, {
 	'pay_CC_CheckOut:over_sla400': (r) => r.timings.duration >400,
   },
   { pay_CC_CheckOut: 'over_sla400' , ALL: 'over_sla400'}
   );
   
   check(res, {
 	'pay_CC_CheckOut:over_sla500 ': (r) => r.timings.duration >500,
   },
   { pay_CC_CheckOut: 'over_sla500' , ALL: 'over_sla500'}
   );
   
   check(res, {
 	'pay_CC_CheckOut:over_sla600': (r) => r.timings.duration >600,
   },
   { pay_CC_CheckOut: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'pay_CC_CheckOut:over_sla800': (r) => r.timings.duration >800,
   },
   { pay_CC_CheckOut: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'pay_CC_CheckOut:over_sla1000': (r) => r.timings.duration >1000,
   },
   { pay_CC_CheckOut: 'over_sla1000', ALL: 'over_sla1000' }
   );
  
     
   let idTr='NA';
   let result={};
   result.idTr=idTr;
   console.log(res);
   try{
   let regexTransId =  new RegExp(`id="transactionId" value=".*?"`);
   let idTr1 = regexTransId.exec(res);
   //console.log(idTr1);
   let sl = idTr1.split('="');
   idTr = sl[1].replace('"','');
   result.idTr=idTr;
   }catch(err){}
   //console.log('dopo try-catch='+idTr);
   //console.log(idTr);
	 
   check(
    res,
    {
    
	 'pay_CC_CheckOut:ok_rate': (r) =>  idTr !== 'NA',
    },
    { pay_CC_CheckOut: 'ok_rate' , ALL: 'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'pay_CC_CheckOut:ko_rate': (r) => idTr == 'NA',
    },
    { pay_CC_CheckOut: 'ko_rate', ALL: 'ko_rate'}
  );
  
  
  
  return result;
   
}

