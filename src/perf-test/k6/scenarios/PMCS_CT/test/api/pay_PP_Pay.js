import http from 'k6/http';
import { check } from 'k6';


export function reqBody( token, idWallet, idPay){


return `
idWallet=${idWallet}&idPayment=${idPay}&sessionToken=${token}&language=&Request-Id=
`
};


export function pay_PP_Pay(baseUrl, token, idWallet, idPay) {
 
 
 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/transactions/pay',
	reqBody( token, idWallet, idPay),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Sec-Fetch-Dest':'document', 'Sec-Fetch-Mode':'navigate',
	'Sec-Fetch-Site':'same-origin', 'Upgrade-Insecure-Requests':'1', 'Sec-Fetch-User':'?1', 'sec-ch-ua-mobile':'?0','sec-ch-ua':';Not A Brand";v="99", "Chromium";v="88'} ,
	tags: { pay_PP_Pay: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  check(res, {
 	'pay_PP_Pay:over_sla300': (r) => r.timings.duration >300,
   },
   { pay_PP_Pay: 'over_sla300' }
   );
   
   check(res, {
 	'pay_PP_Pay:over_sla400': (r) => r.timings.duration >400,
   },
   { pay_PP_Pay: 'over_sla400' }
   );
   
   check(res, {
 	'pay_PP_Pay:over_sla500 ': (r) => r.timings.duration >500,
   },
   { pay_PP_Pay: 'over_sla500' }
   );
   
   check(res, {
 	'pay_PP_Pay:over_sla600': (r) => r.timings.duration >600,
   },
   { pay_PP_Pay: 'over_sla600' }
   );
   
   check(res, {
 	'pay_PP_Pay:over_sla800': (r) => r.timings.duration >800,
   },
   { pay_PP_Pay: 'over_sla800' }
   );
   
   check(res, {
 	'pay_PP_Pay:over_sla1000': (r) => r.timings.duration >1000,
   },
   { pay_PP_Pay: 'over_sla1000' }
   );
  
   //res=(`id="transactionId" value="1"; pos="dddd" value="2"`);//to comment
   let idTr='NA';
   let regexTransId =  new RegExp(`id="transactionId" value=".*?"`);
   try{
   let idTr1 = regexTransId.exec(res);
   let sl = idTr1.split('="');
   idTr = sl[1].replace('"','');
   }catch(err){idTr='NA';}
   
   /*if(idTr!='NA'){
	idTr=idTr.substr(idTr.indexOf("value=\"")+7,idTr.length-1);  
   }*/
   	 
   check(
    res,
    {
    
	 'pay_PP_Pay:ok_rate': (r) =>  idTr !== 'NA',
    },
    { pay_PP_Pay: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'pay_PP_Pay:ko_rate': (r) => idTr == 'NA',
    },
    { pay_PP_Pay: 'ko_rate' }
  );
    
  return res;
   
}

