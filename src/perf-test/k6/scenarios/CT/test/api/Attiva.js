import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";

export function AttivaReqBody(psp, intpsp, chpsp, cfpa, iuv,ccp){
//<password>password</password>
return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
	<soapenv:Header/>
	<soapenv:Body>
		<ws:nodoAttivaRPT>
			<identificativoPSP>${psp}</identificativoPSP>
			<identificativoIntermediarioPSP>${intpsp}</identificativoIntermediarioPSP>
			<identificativoCanale>${chpsp}</identificativoCanale>
			<password>pwdpwdpwd</password>
			<codiceContestoPagamento>${ccp}</codiceContestoPagamento>
			<identificativoIntermediarioPSPPagamento>${intpsp}</identificativoIntermediarioPSPPagamento>
			<identificativoCanalePagamento>${chpsp}</identificativoCanalePagamento>
			<codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
			<codiceIdRPT>
				<qrc:QrCode>
					<qrc:CF>${cfpa}</qrc:CF>
					<qrc:AuxDigit>1</qrc:AuxDigit>
					<qrc:CodIUV>${iuv}</qrc:CodIUV>
				</qrc:QrCode>
			</codiceIdRPT>
			<datiPagamentoPSP>
				<importoSingoloVersamento>10.00</importoSingoloVersamento>
				<ibanAppoggio>IT00R0000000000000000000000</ibanAppoggio>
				<bicAppoggio>CCRTIT5TXXX</bicAppoggio>
				<soggettoVersante>
					<pag:identificativoUnivocoVersante>
						<pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
						<pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
					</pag:identificativoUnivocoVersante>
					<pag:anagraficaVersante>Franco Rossi</pag:anagraficaVersante>
					<pag:indirizzoVersante>viale Monza</pag:indirizzoVersante>
					<pag:civicoVersante>1</pag:civicoVersante>
					<pag:capVersante>20125</pag:capVersante>
					<pag:localitaVersante>Milano</pag:localitaVersante>
					<pag:provinciaVersante>MI</pag:provinciaVersante>
					<pag:nazioneVersante>IT</pag:nazioneVersante>
					<pag:e-mailVersante>mail@mail.it</pag:e-mailVersante>
				</soggettoVersante>
				<ibanAddebito>IT00R0000000000000000000000</ibanAddebito>
				<bicAddebito>CCRTIT2TXXX</bicAddebito>
				<soggettoPagatore>
					<pag:identificativoUnivocoPagatore>
						<pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
						<pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
					</pag:identificativoUnivocoPagatore>
					<pag:anagraficaPagatore>Franco Rossi</pag:anagraficaPagatore>
					<pag:indirizzoPagatore>viale Monza</pag:indirizzoPagatore>
					<pag:civicoPagatore>1</pag:civicoPagatore>
					<pag:capPagatore>20125</pag:capPagatore>
					<pag:localitaPagatore>Milano</pag:localitaPagatore>
					<pag:provinciaPagatore>MI</pag:provinciaPagatore>
					<pag:nazionePagatore>IT</pag:nazionePagatore>
					<pag:e-mailPagatore>mail@mail.it</pag:e-mailPagatore>
				</soggettoPagatore>
			</datiPagamentoPSP>
		</ws:nodoAttivaRPT>
	</soapenv:Body>
</soapenv:Envelope>
`
};

export function Attiva(baseUrl,rndAnagPsp,rndAnagPa,iuv, ccp) {
 
  
 const res = http.post(
    baseUrl+'?soapAction=Attiva',
    AttivaReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , iuv, ccp),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { Attiva: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   
   check(res, {
 	'Attiva:over_sla300': (r) => r.timings.duration >300,
   },
   { Attiva: 'over_sla300' }
   );
   
   check(res, {
 	'Attiva:over_sla400': (r) => r.timings.duration >400,
   },
   { Attiva: 'over_sla400' }
   );
   
   check(res, {
 	'Attiva:over_sla500 ': (r) => r.timings.duration >500,
   },
   { Attiva: 'over_sla500' }
   );
   
   check(res, {
 	'Attiva:over_sla600': (r) => r.timings.duration >600,
   },
   { Attiva: 'over_sla600' }
   );
   
   check(res, {
 	'Attiva:over_sla800': (r) => r.timings.duration >800,
   },
   { Attiva: 'over_sla800' }
   );
   
   check(res, {
 	'Attiva:over_sla1000': (r) => r.timings.duration >1000,
   },
   { Attiva: 'over_sla1000' }
   );
   
  const doc = parseHTML(res.body);
  const script = doc.find('esito');
  const outcome = script.text();
  /*if(outcome=='KO'){
	   console.log("ATTIVA REQuest----------------"+AttivaReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF , iuv, ccp)); 
  console.log("ATTIVA RESPONSE----------------"+res.body);
  }*/
    
   check(
    res,
    {
      //'Attiva:ok_rate': (r) => r.status == 200,
	  'Attiva:ok_rate': (r) => outcome == 'OK',
    },
    { Attiva: 'ok_rate' }
	);
 
  check(
    res,
    {
      //'Attiva:ko_rate': (r) => r.status !== 200,
	  'Attiva:ko_rate': (r) => outcome !== 'OK',
    },
    { Attiva: 'ko_rate' }
  );
  
  return res;
   
}

