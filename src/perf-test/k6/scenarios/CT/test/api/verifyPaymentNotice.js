import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";

export function verifyReqBody(psp, intpsp, chpsp, chpsp_c, cfpa, noticeNmbr){
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

export function verifyPaymentNotice(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey) {
 //console.log("VERIFY="+noticeNmbr);
 
 const res = http.post(
    baseUrl+'?soapAction=verifyPaymentNotice',
    verifyReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPsp.CHPSP_C, rndAnagPa.CF , noticeNmbr),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { verifyPaymentNotice: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   
   check(res, {
 	'verifyPaymentNotice:over_sla300': (r) => r.timings.duration >300,
   },
   { verifyPaymentNotice: 'over_sla300' }
   );
   
   check(res, {
 	'verifyPaymentNotice:over_sla400': (r) => r.timings.duration >400,
   },
   { verifyPaymentNotice: 'over_sla400' }
   );
   
   check(res, {
 	'verifyPaymentNotice:over_sla500 ': (r) => r.timings.duration >500,
   },
   { verifyPaymentNotice: 'over_sla500' }
   );
   
   check(res, {
 	'verifyPaymentNotice:over_sla600': (r) => r.timings.duration >600,
   },
   { verifyPaymentNotice: 'over_sla600' }
   );
   
   check(res, {
 	'verifyPaymentNotice:over_sla800': (r) => r.timings.duration >800,
   },
   { verifyPaymentNotice: 'over_sla800' }
   );
   
   check(res, {
 	'verifyPaymentNotice:over_sla1000': (r) => r.timings.duration >1000,
   },
   { verifyPaymentNotice: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('outcome');
  const outcome = script.text();
  //console.log("VERIFY RESPONSE----------------"+outcome);
  
   check(
    res,
    {
      //'verifyPaymentNotice:ok_rate': (r) => r.status == 200,
	  'verifyPaymentNotice:ok_rate': (r) => outcome == 'OK',
    },
    { verifyPaymentNotice: 'ok_rate' }
	);
 
  check(
    res,
    {
      //'verifyPaymentNotice:ko_rate': (r) => r.status !== 200,
	  'verifyPaymentNotice:ko_rate': (r) => outcome !== 'OK',
    },
    { verifyPaymentNotice: 'ko_rate' }
  );
  
  return res;
   
}

