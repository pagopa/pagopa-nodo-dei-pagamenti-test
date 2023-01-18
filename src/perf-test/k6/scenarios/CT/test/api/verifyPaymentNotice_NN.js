import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";

//<password>password</password>
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
 //console.log("VERIFY="+noticeNmbr);
 
 const res = http.post(
    baseUrl+'?soapAction=verifyPaymentNotice',
    verifyReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { verifyPaymentNotice_NN: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla300': (r) => r.timings.duration >300,
   },
   { verifyPaymentNotice_NN: 'over_sla300' }
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla400': (r) => r.timings.duration >400,
   },
   { verifyPaymentNotice_NN: 'over_sla400' }
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla500 ': (r) => r.timings.duration >500,
   },
   { verifyPaymentNotice_NN: 'over_sla500' }
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla600': (r) => r.timings.duration >600,
   },
   { verifyPaymentNotice_NN: 'over_sla600' }
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla800': (r) => r.timings.duration >800,
   },
   { verifyPaymentNotice_NN: 'over_sla800' }
   );
   
   check(res, {
 	'verifyPaymentNotice_NN:over_sla1000': (r) => r.timings.duration >1000,
   },
   { verifyPaymentNotice_NN: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('outcome');
  const outcome = script.text();
  
  /*if(outcome=='KO'){
  console.log("verifyNN REQuest----------------"+ verifyReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , noticeNmbr)); 
  console.log("verifyNN RESPONSE----------------"+res.body);
  }*/
    
   check(
    res,
    {
     
	  'verifyPaymentNotice_NN:ok_rate': (r) => outcome == 'OK',
    },
    { verifyPaymentNotice_NN: 'ok_rate' }
	);
 
  check(
    res,
    {
      'verifyPaymentNotice_NN:ko_rate': (r) => outcome !== 'OK',
    },
    { verifyPaymentNotice_NN: 'ko_rate' }
  );
  
  return res;
   
}

