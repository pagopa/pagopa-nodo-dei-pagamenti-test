import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";

export const verifyPaymentNotice_NN_Trend = new Trend('verifyPaymentNotice_NN');
export const All_Trend = new Trend('ALL');

//<password>pwdpwdpwd</password>
export function verifyReqBody(psp, intpsp, chpsp, cfpa, noticeNmbr){
return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <nod:verifyPaymentNoticeReq>
         <idPSP>${psp}</idPSP>
         <idBrokerPSP>${intpsp}</idBrokerPSP>
         <idChannel>${chpsp}</idChannel>
         <password>pwdpwdpwd</password>
         <qrCode>
            <fiscalCode>${cfpa}</fiscalCode>
            <noticeNumber>${noticeNmbr}</noticeNumber>
         </qrCode>
      </nod:verifyPaymentNoticeReq>
   </soapenv:Body>
</soapenv:Envelope>
`
};

export function verifyPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey) {
 //console.debug("VERIFY="+noticeNmbr);
 
 const res = http.post(
		 getBasePath(baseUrl, "verifyPaymentNotice"),
    verifyReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr),
    { headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction':'verifyPaymentNotice', 'x-forwarded-for':'10.6.189.192' }) ,
	tags: { verifyPaymentNotice_NN: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  console.debug("verifyPaymentNotice_NN RES");
  console.debug(res);


  verifyPaymentNotice_NN_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);

   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla300': (r) => r.timings.duration >300,
   },
   { verifyPaymentNotice_NN: 'over_sla300' , ALL:'over_sla300'}
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla400': (r) => r.timings.duration >400,
   },
   { verifyPaymentNotice_NN: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla500 ': (r) => r.timings.duration >500,
   },
   { verifyPaymentNotice_NN: 'over_sla500' , ALL:'over_sla500'}
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla600': (r) => r.timings.duration >600,
   },
   { verifyPaymentNotice_NN: 'over_sla600' , ALL:'over_sla600'}
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla800': (r) => r.timings.duration >800,
   },
   { verifyPaymentNotice_NN: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla1000': (r) => r.timings.duration >1000,
   },
   { verifyPaymentNotice_NN: 'over_sla1000' , ALL:'over_sla1000'}
   );

  let outcome='';
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  outcome = script.text();
  }catch(error){}



  /*if(outcome=='KO'){
  console.debug("verifyNN REQuest----------------"+ verifyReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr)); 
  console.debug("verifyNN RESPONSE----------------"+res.body);
  }*/
    
   check(
    res,
    {
     
	  'verifyPaymentNotice_NN:ok_rate': (r) => outcome == 'OK',
    },
    { verifyPaymentNotice_NN: 'ok_rate' , ALL:'ok_rate'}
	);
 
  if(check(
    res,
    {
      'verifyPaymentNotice_NN:ko_rate': (r) => outcome !== 'OK',
    },
    { verifyPaymentNotice_NN: 'ko_rate' , ALL:'ko_rate'}
  )){
	fail("outcome != ok: "+outcome);
	}
  
  return res;
   
}

