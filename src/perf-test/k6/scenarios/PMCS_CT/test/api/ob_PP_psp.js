import http from 'k6/http';
import { check } from 'k6';
import { Trend } from 'k6/metrics';


export const ob_PP_psp_Trend = new Trend('ob_PP_psp');
export const All_Trend = new Trend('ALL');



export function ob_PP_psp(baseUrl, token) {
  
  //in perf da controllare valore di idPsp --> SELECT d.ID_PSP FROM PP_PAYPAL_PSP_DETAILS d JOIN PP_PSP p ON d.ID_PSP = p.ID_PSP WHERE d.PSP_URL LIKE '%mock-psp%'
  //PAYPAL_PSP_MOCK_AZURE
  const res = http.post(
    baseUrl+'/pp-restapi-CD/v3/webview/paypal/onboarding/psp?idPsp=PAYTITM1&sessionToken='+token,
	'',
	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	tags: { ob_PP_psp: 'http_req_duration', ALL:'http_req_duration'}
	}
  );

  All_Trend.add(res.timings.duration);
  ob_PP_psp_Trend.add(res.timings.duration);

   check(res, {
 	'ob_PP_psp:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_PP_psp: 'over_sla300', ALL: 'over_sla300'}
   );
   
   check(res, {
 	'ob_PP_psp:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_PP_psp: 'over_sla400' , ALL: 'over_sla400'}
   );
   
   check(res, {
 	'ob_PP_psp:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_PP_psp: 'over_sla500', ALL: 'over_sla500' }
   );
   
   check(res, {
 	'ob_PP_psp:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_PP_psp: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'ob_PP_psp:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_PP_psp: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'ob_PP_psp:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_PP_psp: 'over_sla1000', ALL: 'over_sla1000' }
   );


   
   check(
    res,
    {
    
	 'ob_PP_psp:ok_rate': (r) =>  r.status === 200,
    },
    { ob_PP_psp: 'ok_rate' , ALL: 'ok_rate'}
	);
 
  check(
    res,
    {
     
	 'ob_PP_psp:ko_rate': (r) =>  r.status !== 200,
    },
    { ob_PP_psp: 'ko_rate', ALL: 'ko_rate' }
  );
  
  return res;
   
   
}

