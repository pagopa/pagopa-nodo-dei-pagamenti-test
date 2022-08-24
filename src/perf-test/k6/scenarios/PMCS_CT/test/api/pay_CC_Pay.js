import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';


export const pay_CC_Pay_Trend = new Trend('pay_CC_Pay');
export const All_Trend = new Trend('ALL');


export function reqBody( token, idWallet, idPay){

return 'idWallet='+idWallet+'&idPayment='+idPay+'&sessionToken='+token+'&language=&Request-Id='
};


export function pay_CC_Pay(baseUrl, token, idWallet, idPay) {
 

 const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/transactions/pay',
	reqBody( token, idWallet, idPay),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: { pay_CC_Pay: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );

  All_Trend.add(res.timings.duration);
  pay_CC_Pay_Trend.add(res.timings.duration);

  check(res, {
 	'pay_CC_Pay:over_sla300': (r) => r.timings.duration >300,
   },
   { pay_CC_Pay: 'over_sla300' , ALL:'over_sla300'}
   );
   
   check(res, {
 	'pay_CC_Pay:over_sla400': (r) => r.timings.duration >400,
   },
   { pay_CC_Pay: 'over_sla400' , ALL:'over_sla400'}
   );
   
   check(res, {
 	'pay_CC_Pay:over_sla500 ': (r) => r.timings.duration >500,
   },
   { pay_CC_Pay: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'pay_CC_Pay:over_sla600': (r) => r.timings.duration >600,
   },
   { pay_CC_Pay: 'over_sla600' , ALL:'over_sla600'}
   );
   
   check(res, {
 	'pay_CC_Pay:over_sla800': (r) => r.timings.duration >800,
   },
   { pay_CC_Pay: 'over_sla800' , ALL:'over_sla800'}
   );
   
   check(res, {
 	'pay_CC_Pay:over_sla1000': (r) => r.timings.duration >1000,
   },
   { pay_CC_Pay: 'over_sla1000', ALL:'over_sla1000' }
   );
  
   
   check(
    res,
    {
    
	 'pay_CC_Pay:ok_rate': (r) =>  res.status == 200,
    },
    { pay_CC_Pay: 'ok_rate', ALL:'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'pay_CC_Pay:ko_rate': (r) => res.status !== 200,
    },
    { pay_CC_Pay: 'ko_rate', ALL:'ko_rate' }
  );
    
  return res;
   
}

