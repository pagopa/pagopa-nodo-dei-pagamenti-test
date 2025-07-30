import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";


export const inoltraEsitoPagamentoPaypal_Trend = new Trend('inoltraEsitoPagamentoPaypal');
export const All_Trend = new Trend('ALL');


export function rptReqBody(psp, intpsp, chpsp_c, paymentToken){

var dt = new Date();
let ms = dt.getMilliseconds();

//console.debug(dt.getTimezoneOffset());
var timezone_offset_min = dt.getTimezoneOffset()-120,
	offset_hrs = parseInt(Math.abs(timezone_offset_min/60)),
	offset_min = Math.abs(timezone_offset_min%60),
	timezone_standard;

if(offset_hrs < 10)
	offset_hrs = '0' + offset_hrs;

if(offset_min < 10)
	offset_min = '0' + offset_min;

// Add an opposite sign to the offset
// If offset is 0, it means timezone is UTC
if(timezone_offset_min < 0)
	timezone_standard = '+' + offset_hrs + ':' + offset_min;
else if(timezone_offset_min > 0)
	timezone_standard = '-' + offset_hrs + ':' + offset_min;
else if(timezone_offset_min == 0)
	timezone_standard = 'Z';

//console.debug(timezone_standard); 

dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" +  ("0" + dt.getDate()).slice(-2) + "T" + 
("0" + dt.getHours() ).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2)+ "." + ms + timezone_standard;

//console.debug("dt-----"+dt);

return `
{"idPagamento":"${paymentToken}",
"idTransazione":"194111124612",
"idTransazionePsp":"0000000000142559120608",
"identificativoPsp": "${psp}",
"identificativoIntermediario": "${intpsp}",
"identificativoCanale": "${chpsp_c}",
"importoTotalePagato":1.00,
"timestampOperazione":"${dt}"}
`
};

export function inoltraEsitoPagamentoPaypal(baseUrl,rndAnagPsp,paymentToken,valueToAssert, transactionId) {

 var dt = new Date();
 let ms = dt.getMilliseconds();

 //console.debug(dt.getTimezoneOffset());
 var timezone_offset_min = dt.getTimezoneOffset()-120,
 	offset_hrs = parseInt(Math.abs(timezone_offset_min/60)),
 	offset_min = Math.abs(timezone_offset_min%60),
 	timezone_standard;

 if(offset_hrs < 10)
 	offset_hrs = '0' + offset_hrs;

 if(offset_min < 10)
 	offset_min = '0' + offset_min;

 // Add an opposite sign to the offset
 // If offset is 0, it means timezone is UTC
 if(timezone_offset_min < 0)
 	timezone_standard = '+' + offset_hrs + ':' + offset_min;
 else if(timezone_offset_min > 0)
 	timezone_standard = '-' + offset_hrs + ':' + offset_min;
 else if(timezone_offset_min == 0)
 	timezone_standard = 'Z';

 //console.debug(timezone_standard);

 dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" +  ("0" + dt.getDate()).slice(-2) + "T" +
 ("0" + dt.getHours() ).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2)+ "." + ms + timezone_standard;


 let body={"idPagamento":paymentToken,
          "idTransazione":transactionId,
          "idTransazionePsp":"0000000000142559120608",
          "identificativoPsp": rndAnagPsp.PSP,
          "identificativoIntermediario": rndAnagPsp.INTPSP,
          "identificativoCanale": rndAnagPsp.CHPSP_C,
          "importoTotalePagato":1.00,
          "timestampOperazione":dt};

 const res = http.post(
	 getBasePath(baseUrl, "nodoPerPMv1")+'/inoltroEsito/paypal',
    JSON.stringify(body),
    //JSON.stringify(rptReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken)),
    { headers: getHeaders({ 'Content-Type': 'application/json' }) ,
	tags: { inoltraEsitoPagamentoPaypal: 'http_req_duration', ALL: 'http_req_duration', primitiva: "inoltroEsito/paypal"}
	}
  );
  
  console.debug("inoltraEsitoPagamentoPaypal RES");
  console.debug(JSON.stringify(res));


  inoltraEsitoPagamentoPaypal_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

   check(res, {
 	'inoltraEsitoPagamentoPaypal:over_sla300': (r) => r.timings.duration >300,
   },
   { inoltraEsitoPagamentoPaypal: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoPaypal:over_sla400': (r) => r.timings.duration >400,
   },
   { inoltraEsitoPagamentoPaypal: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoPaypal:over_sla500 ': (r) => r.timings.duration >500,
   },
   { inoltraEsitoPagamentoPaypal: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoPaypal:over_sla600': (r) => r.timings.duration >600,
   },
   { inoltraEsitoPagamentoPaypal: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoPaypal:over_sla800': (r) => r.timings.duration >800,
   },
   { inoltraEsitoPagamentoPaypal: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'inoltraEsitoPagamentoPaypal:over_sla1000': (r) => r.timings.duration >1000,
   },
   { inoltraEsitoPagamentoPaypal: 'over_sla1000', ALL:'over_sla1000' }
   );
   
   //const outcome= res.json().form.esito;
	let jsonBody = JSON.parse(res.body);
   let outcome='';
   if(valueToAssert!== '408'){
   try{
	
   outcome=jsonBody["esito"];
   }catch(error){}
   }else{
   outcome=res.status;
   }
	console.debug("OUTCOME: "+ outcome + " valueToAssert "+ valueToAssert);

   check(
    res,
    {
    
	  'inoltraEsitoPagamentoPaypal:ok_rate': (r) => outcome == valueToAssert,
    },
    { inoltraEsitoPagamentoPaypal: 'ok_rate', ALL:'ok_rate' }
	);
 
  if(check(
    res,
    {
     
	  'inoltraEsitoPagamentoPaypal:ko_rate': (r) => outcome != valueToAssert,
    },
    { inoltraEsitoPagamentoPaypal: 'ko_rate', ALL:'ko_rate'}
  )){
	fail("outcome != ok: "+outcome);
	}
  
  return res;
   
}

