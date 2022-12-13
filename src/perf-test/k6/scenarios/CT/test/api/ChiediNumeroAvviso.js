import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';


export const ChiediNumeroAvviso_Trend = new Trend('ChiediNumeroAvviso');
export const All_Trend = new Trend('ALL');

export function numAvvisoReqBody(psp, intpsp, chpsp, pa){
//<password>pwdpwdpwd</password>
return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
<soapenv:Header/>
<soapenv:Body>
<ws:nodoChiediNumeroAvviso>
<identificativoPSP>${psp}</identificativoPSP>
<identificativoIntermediarioPSP>${intpsp}</identificativoIntermediarioPSP>
<identificativoCanale>${chpsp}</identificativoCanale>
<password>pwdpwdpwd</password>
<idServizio>00001</idServizio>
<idDominioErogatoreServizio>${pa}</idDominioErogatoreServizio>
<datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjx0YTp0YXNzYUF1dG8geG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byBUYXNzYUF1dG9tb2JpbGlzdGljYV8xXzBfMC54c2QgIj4NCiAgPHRhOnZlaWNvbG9Db25UYXJnYT4NCiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPg0KICAgIDx0YTp2ZWljb2xvVGFyZ2E+QUIzNDVDRDwvdGE6dmVpY29sb1RhcmdhPg0KICA8L3RhOnZlaWNvbG9Db25UYXJnYT4NCjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
</ws:nodoChiediNumeroAvviso>
</soapenv:Body>
</soapenv:Envelope>
`
};

export function ChiediNumeroAvviso(baseUrl,rndAnagPsp,rndAnagPa) {
 
 const res = http.post(
    baseUrl,
    numAvvisoReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.PA),
    { headers: { 'Content-Type': 'text/xml', 'SOAPAction': 'nodoChiediNumeroAvviso' } ,
	tags: { ChiediNumeroAvviso: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  console.debug("ChiediNumeroAvviso RES");
  console.debug(res);

  ChiediNumeroAvviso_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);
   
   check(res, {
 	'ChiediNumeroAvviso:over_sla300': (r) => r.timings.duration >300,
   },
   { ChiediNumeroAvviso: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'ChiediNumeroAvviso:over_sla400': (r) => r.timings.duration >400,
   },
   { ChiediNumeroAvviso: 'over_sla400', ALL:'over_sla400'  }
   );
   
   check(res, {
 	'ChiediNumeroAvviso:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ChiediNumeroAvviso: 'over_sla500', ALL:'over_sla500'  }
   );
   
   check(res, {
 	'ChiediNumeroAvviso:over_sla600': (r) => r.timings.duration >600,
   },
   { ChiediNumeroAvviso: 'over_sla600', ALL:'over_sla600'  }
   );
   
   check(res, {
 	'ChiediNumeroAvviso:over_sla800': (r) => r.timings.duration >800,
   },
   { ChiediNumeroAvviso: 'over_sla800', ALL:'over_sla800'  }
   );
   
   check(res, {
 	'ChiediNumeroAvviso:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ChiediNumeroAvviso: 'over_sla1000', ALL:'over_sla1000' }
   );

  let outcome='';
  try{
  let doc = parseHTML(res.body);
  let script = doc.find('esito');
  outcome = script.text();
  }catch(error){}
  /*if(outcome=='KO'){
  console.debug("ChiediNumAvviso REQuest----------------"+numAvvisoReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.PA)); 
  console.debug("ChiediNumAvviso RESPONSE----------------"+res.body);
  }*/
  
   check(
    res,
    {
      //'ChiediNumeroAvviso:ok_rate': (r) => r.status == 200,
	  'ChiediNumeroAvviso:ok_rate': (r) => outcome == 'OK',
    },
    { ChiediNumeroAvviso: 'ok_rate', ALL:'ok_rate' }
	);
 
  if(check(
    res,
    {
      //'ChiediNumeroAvviso:ko_rate': (r) => r.status !== 200,
	  'ChiediNumeroAvviso:ko_rate': (r) => outcome !== 'OK',
    },
    { ChiediNumeroAvviso: 'ko_rate', ALL:'ko_rate' }
  )){
	fail("outcome != ok: "+outcome);
	}
  
  return res;
   
}

