import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";

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

export function Verifica(baseUrl,rndAnagPsp,rndAnagPa,iuv, auxDigit) {
 
 const res = http.post(
    baseUrl+'?soapAction=nodoVerificaRPT',
    verificaReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , iuv, auxDigit),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { Verifica: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   
   check(res, {
 	'Verifica:over_sla300': (r) => r.timings.duration >300,
   },
   { Verifica: 'over_sla300' }
   );
   
   check(res, {
 	'Verifica:over_sla400': (r) => r.timings.duration >400,
   },
   { Verifica: 'over_sla400' }
   );
   
   check(res, {
 	'Verifica:over_sla500 ': (r) => r.timings.duration >500,
   },
   { Verifica: 'over_sla500' }
   );
   
   check(res, {
 	'Verifica:over_sla600': (r) => r.timings.duration >600,
   },
   { Verifica: 'over_sla600' }
   );
   
   check(res, {
 	'Verifica:over_sla800': (r) => r.timings.duration >800,
   },
   { Verifica: 'over_sla800' }
   );
   
   check(res, {
 	'Verifica:over_sla1000': (r) => r.timings.duration >1000,
   },
   { Verifica: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('esito');
  const outcome = script.text();
  /*if(outcome=='KO'){
  console.log("VERIfica REQuest----------------"+verificaReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , iuv, auxDigit)); 
  console.log("VERIFICA RESPONSE----------------"+res.body);
  }*/
  
   check(
    res,
    {
      //'Verifica:ok_rate': (r) => r.status == 200,
	  'Verifica:ok_rate': (r) => outcome == 'OK',
    },
    { Verifica: 'ok_rate' }
	);
 
  check(
    res,
    {
      //'Verifica:ko_rate': (r) => r.status !== 200,
	  'Verifica:ko_rate': (r) => outcome !== 'OK',
    },
    { Verifica: 'ko_rate' }
  );
  
  return res;
   
}

