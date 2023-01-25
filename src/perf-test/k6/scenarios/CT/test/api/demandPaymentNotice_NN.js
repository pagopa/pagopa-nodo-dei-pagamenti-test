import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath } from "../util/base_path_util.js";

export const demandPaymentNotice_NN_Trend = new Trend('demandPaymentNotice_NN');
export const All_Trend = new Trend('ALL');

export function demandReqBody(psp, intpsp, chpsp, idSevizio){
return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
  <soapenv:Body>
    <nod:demandPaymentNoticeRequest>
      <idPSP>${psp}</idPSP>
      <idBrokerPSP>${intpsp}</idBrokerPSP>
      <idChannel>${chpsp}</idChannel>
      <password>pwdpwdpwd</password>
      <idSoggettoServizio>${idSevizio}</idSoggettoServizio>
      <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgo8dGE6dmVpY29sb0NvblRhcmdhPgo8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPgo8dGE6dmVpY29sb1RhcmdhPkFCMzQ1Q0Q8L3RhOnZlaWNvbG9UYXJnYT4KPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
    </nod:demandPaymentNoticeRequest>
  </soapenv:Body>
</soapenv:Envelope>
`
};

export function demandPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey) {

 let pa='';
 let idServizio='';
 try{
 pa = rndAnagPa.PA;
 //console.debug("pa="+pa);
 idServizio = pa.substring(pa.length - 5, pa.length);
 //console.debug("idServizio="+idServizio);
 }catch(error){}
 
 const res = http.post(
    getBasePath(baseUrl, "demandPaymentNotice"),
    demandReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, idServizio),
    { headers: { 'Content-Type': 'text/xml', 'SOAPAction': 'demandPaymentNotice' } ,
	tags: { demandPaymentNotice_NN: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  console.debug("demandPaymentNotice_NN RES");
  console.debug(res);
  
   demandPaymentNotice_NN_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);


   check(res, {
 	'demandPaymentNotice_NN:over_sla300': (r) => r.timings.duration >300,
   },
   { demandPaymentNotice_NN: 'over_sla300', ALL: 'over_sla300' }
   );
   
   check(res, {
 	'demandPaymentNotice_NN:over_sla400': (r) => r.timings.duration >400,
   },
   { demandPaymentNotice_NN: 'over_sla400', ALL: 'over_sla400' }
   );
   
   check(res, {
 	'demandPaymentNotice_NN:over_sla500 ': (r) => r.timings.duration >500,
   },
   { demandPaymentNotice_NN: 'over_sla500', ALL: 'over_sla500' }
   );
   
   check(res, {
 	'demandPaymentNotice_NN:over_sla600': (r) => r.timings.duration >600,
   },
   { demandPaymentNotice_NN: 'over_sla600', ALL: 'over_sla600' }
   );
   
   check(res, {
 	'demandPaymentNotice_NN:over_sla800': (r) => r.timings.duration >800,
   },
   { demandPaymentNotice_NN: 'over_sla800', ALL: 'over_sla800' }
   );
   
   check(res, {
 	'demandPaymentNotice_NN:over_sla1000': (r) => r.timings.duration >1000,
   },
   { demandPaymentNotice_NN: 'over_sla1000' , ALL: 'over_sla1000' }
   );

  let outcome='';
  noticeNmbr='';
  let result={};
  result.noticeNmbr=noticeNmbr;
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  outcome = script.text();
  script = doc.find('noticeNumber');
  noticeNmbr = script.text();
  result.noticeNmbr=noticeNmbr;
  }catch(error){}
    
   check(
    res,
    {
     
	 'demandPaymentNotice_NN:ok_rate': (r) => outcome == 'OK' && result.noticeNmbr != undefined && result.noticeNmbr !== '',
    },
    { demandPaymentNotice_NN: 'ok_rate', ALL: 'ok_rate' }
	);
  
  if(check(
    res,
    {
     'demandPaymentNotice_NN:ko_rate': (r) => result.noticeNmbr == undefined || result.noticeNmbr === '' || outcome !== 'OK',
    },
    { demandPaymentNotice_NN: 'ko_rate', ALL: 'ko_rate' }
  )){
	fail("result.noticeNmbr undefined or empty: "+result.noticeNmbr + " or outcome  != ok "+  outcome);
	}
  
  return result;
   
}

