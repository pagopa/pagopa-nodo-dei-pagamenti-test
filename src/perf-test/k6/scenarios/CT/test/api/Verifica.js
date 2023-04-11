import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";

export const Verifica_Trend = new Trend('Verifica');
export const All_Trend = new Trend('ALL');


export function verificaReqBody(psp, intpsp, chpsp, cfpa, iuv, auxDigit){
return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
	<soapenv:Header/>
	<soapenv:Body>
		<ws:nodoVerificaRPT>
			<identificativoPSP>${psp}</identificativoPSP>
			<identificativoIntermediarioPSP>${intpsp}</identificativoIntermediarioPSP>
			<identificativoCanale>${chpsp}</identificativoCanale>
			<password>pwdpwdpwd</password>
			<codiceContestoPagamento>PERFORMANCE</codiceContestoPagamento>
			<codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
			<codiceIdRPT>
				<qrc:QrCode>
					<qrc:CF>${cfpa}</qrc:CF>
					<qrc:AuxDigit>${auxDigit}</qrc:AuxDigit>
					<qrc:CodIUV>${iuv}</qrc:CodIUV>
				</qrc:QrCode>
			</codiceIdRPT>
		</ws:nodoVerificaRPT>
	</soapenv:Body>
</soapenv:Envelope>
`
};

export function Verifica(baseUrl,rndAnagPsp,rndAnagPa,iuv, auxDigit, valueToAssert) {
console.log(verificaReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , iuv, auxDigit));
 const res = http.post(
		 getBasePath(baseUrl, "nodoVerificaRPT"),
    verificaReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , iuv, auxDigit),
    { headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction':'nodoVerificaRPT', 'x-forwarded-for':'10.6.189.192'}) ,
	tags: { Verifica: 'http_req_duration', ALL: 'http_req_duration',primitiva:"nodoVerificaRPT"}
	}
  );
  
  console.debug("Verifica RES");
  console.debug(JSON.stringify(res.timings));
  

   Verifica_Trend.add(res.timings.duration);
   All_Trend.add(res.timings.duration);


   check(res, {
 	'Verifica:over_sla300': (r) => r.timings.duration >300,
   },
   { Verifica: 'over_sla300', ALL:'over_sla300' }
   );
   
   check(res, {
 	'Verifica:over_sla400': (r) => r.timings.duration >400,
   },
   { Verifica: 'over_sla400', ALL:'over_sla400' }
   );
   
   check(res, {
 	'Verifica:over_sla500 ': (r) => r.timings.duration >500,
   },
   { Verifica: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'Verifica:over_sla600': (r) => r.timings.duration >600,
   },
   { Verifica: 'over_sla600', ALL:'over_sla600' }
   );
   
   check(res, {
 	'Verifica:over_sla800': (r) => r.timings.duration >800,
   },
   { Verifica: 'over_sla800', ALL:'over_sla800' }
   );
   
   check(res, {
 	'Verifica:over_sla1000': (r) => r.timings.duration >1000,
   },
   { Verifica: 'over_sla1000', ALL:'over_sla1000' }
   );

  let outcome='';
  let faultCode='';
  try{
  const doc = parseHTML(res.body);
  const script = doc.find('esito');
  const scriptFaultCode = doc.find('faultCode');
  outcome = script.text();
  faultCode = scriptFaultCode.text();
  }catch(error){}
  /*if(outcome=='KO'){
  console.debug("VERIfica REQuest----------------"+verificaReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , iuv, auxDigit)); 
  console.debug("VERIFICA RESPONSE----------------"+res.body);
  }*/
  
   check(
    res,
    {
      //'Verifica:ok_rate': (r) => r.status == 200,
	  'Verifica:ok_rate': (r) => outcome == valueToAssert || faultCode == valueToAssert,
    },
    { Verifica: 'ok_rate', ALL:'ok_rate' }
	);
 
  if(check(
    res,
    {
      //'Verifica:ko_rate': (r) => r.status !== 200,
	  'Verifica:ko_rate': (r) => outcome !== valueToAssert && faultCode !== valueToAssert,
    },
    { Verifica: 'ko_rate', ALL:'ko_rate' }
  )){
	fail("outcome != "+valueToAssert + " : "+outcome + " faultCode: "+faultCode);
}
  
  return res;
   
}

