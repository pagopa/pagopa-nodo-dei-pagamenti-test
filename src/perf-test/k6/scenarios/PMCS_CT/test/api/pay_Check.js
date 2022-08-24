import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';


export const pay_Check_Trend = new Trend('pay_Check');
export const All_Trend = new Trend('ALL');


export function pay_Check(baseUrl, idPay, token) {
 
 //console.log('payPpCheck='+baseUrl+'/pp-restapi-CD/v1/payments/'+idPay+'/actions/check');
 const res = http.get(
    baseUrl+'/pp-restapi-CD/v1/payments/'+idPay+'/actions/check',
	{ headers: { 'Content-Type': 'application/json', 'Authorization':'Bearer '+token} ,
	tags: { pay_Check: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );

  All_Trend.add(res.timings.duration);
  pay_Check_Trend.add(res.timings.duration);

  check(res, {
 	'pay_Check:over_sla300': (r) => r.timings.duration >300,
   },
   { pay_Check: 'over_sla300' , ALL: 'over_sla300' }
   );
   
   check(res, {
 	'pay_Check:over_sla400': (r) => r.timings.duration >400,
   },
   { pay_Check: 'over_sla400' , ALL: 'over_sla400' }
   );
   
   check(res, {
 	'pay_Check:over_sla500 ': (r) => r.timings.duration >500,
   },
   { pay_Check: 'over_sla500', ALL: 'over_sla500'  }
   );
   
   check(res, {
 	'pay_Check:over_sla600': (r) => r.timings.duration >600,
   },
   { pay_Check: 'over_sla600', ALL: 'over_sla600'  }
   );
   
   check(res, {
 	'pay_PP_Check:over_sla800': (r) => r.timings.duration >800,
   },
   { pay_Check: 'over_sla800', ALL: 'over_sla800'  }
   );
   
   check(res, {
 	'pay_Check:over_sla1000': (r) => r.timings.duration >1000,
   },
   { pay_Check: 'over_sla1000', ALL: 'over_sla1000' }
   );
  
   

   
   check(
    res,
    {
    
	 'pay_Check:ok_rate': (r) =>  res.status==200, //res.body.includes(`Esito="0000"`),
    },
    { pay_Check: 'ok_rate' , ALL: 'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'pay_Check:ko_rate': (r) => res.status!==200,//!res.body.includes(`Esito="0000"`),
    },
    { pay_Check: 'ko_rate', ALL: 'ko_rate' }
  );
    
  return res;
   
}

