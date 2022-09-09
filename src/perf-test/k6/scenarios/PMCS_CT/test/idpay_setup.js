import http from 'k6/http';
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';




 
export const getScalini = new SharedArray('scalini', function () {
	
 const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.log(f);
  return f; 
}); 



export const options = {
	
  /*  scenarios: {
  	total: {
      executor: 'ramping-vus',
      stages: [
        { target: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_1+'s' }, 
        { target: getScalini[0].Scalino_CT_2, duration: getScalini[0].Scalino_CT_TIME_2+'s' }, 
        { target: getScalini[0].Scalino_CT_3, duration: getScalini[0].Scalino_CT_TIME_3+'s' }, 
		{ target: getScalini[0].Scalino_CT_4, duration: getScalini[0].Scalino_CT_TIME_4+'s' }, 
        { target: getScalini[0].Scalino_CT_5, duration: getScalini[0].Scalino_CT_TIME_5+'s' }, 
        { target: getScalini[0].Scalino_CT_6, duration: getScalini[0].Scalino_CT_TIME_6+'s' },
		{ target: getScalini[0].Scalino_CT_7, duration: getScalini[0].Scalino_CT_TIME_7+'s' }, 
		{ target: getScalini[0].Scalino_CT_8, duration: getScalini[0].Scalino_CT_TIME_8+'s' }, 
        { target: getScalini[0].Scalino_CT_9, duration: getScalini[0].Scalino_CT_TIME_9+'s' }, 
        { target: getScalini[0].Scalino_CT_10, duration: getScalini[0].Scalino_CT_TIME_10+'s' },
       ],
      tags: { test_type: 'ALL' }, 
      exec: 'total', 
    }
	
  },*/

  discardResponseBodies: false,
   
  
}; 


const csvBaseUrl = new SharedArray('baseUrl', function () {

  return papaparse.parse(open('../../../cfg/baseURL_PM.csv'), { header: true }).data;

});

export function total() {

  let baseUrl = "";
  let baseUrlPM = "";
  let urls = csvBaseUrl;

  /*export const get_idPay_Trend = new Trend('get_idPay');
  export const All_Trend = new Trend('ALL');*/

  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseUrl = urls[key].BASEURL;
		baseUrlPM = urls[key].MOCK_PM_BASEURL;
      }
  }

  let users = ["aPPantani@nft.it", "gPPgironi@nft.it", "pPPpalisti@nft.it", "zPPzabalai@nft.it","sPPsacs@nft.it"];

  let numbs = '123456789';
  let chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  let amount='';
  let iuv='idD_';
  let ccp='ccp_';
  for (var i = 4; i > 0; --i) amount += numbs[Math.floor(Math.random() * numbs.length)];
  amount=amount+'.16';
  for (var i = 15; i > 0; --i) iuv += chars[Math.floor(Math.random() * chars.length)];
  for (var i = 15; i > 0; --i) ccp += chars[Math.floor(Math.random() * chars.length)];
  //console.log("tokenIO="+tokenIO);
  let mail = users[Math.floor(Math.random() * users.length)];

  let body={
           "importoTotale": "99856.16",
            "email": mail,
            "ragioneSociale": "PagoPa",
            "oggettoPagamento": "Pagamento",
            "bolloDigitale": "false",
            "codiceFiscale": "DJKGYU39H63J175R",
            "idCarrello": "svKVGLP9cYoJuux",
            "iban": "IT87D70538542951YOM1FTHP8XU",
            "language": "",
            "idLogo": "",
            "dettagli":
            [        {
            "iuv": iuv,
            "ccp": ccp,  //ccp_DXAxGiWYKSJPjjX
            "idDominio": "idD_bdRpFKTIzLSEdFx",  //idD_bdRpFKTIzLSEdFx
            "enteBeneficiario": "Ostbarrow TAFE",
            "importo": amount,
            "tipoPagatore": "G",
            "codicePagatore": "WIRDDD73M36D576C",
            "nomePagatore": mail
            }]
            };


    const res = http.put(
    baseUrl+'/pmmockserviceapi/pa/send/rpt',
    JSON.stringify(body),
    { headers: { 'Content-Type': 'application/json'}
	//, tags: { get_idPay: 'http_req_duration', ALL: 'http_req_duration'}
	}
  ); 

  /*All_Trend.add(res.timings.duration);
  get_idPay_Trend.add(res.timings.duration); */
  //let idPay=res.json()[0].idPayment;

  //console.log(";"+res.status+";"+idPay);

  /*check(res, {
   	'get_idPay:over_sla300': (r) => r.timings.duration >300,
     },
     { get_idPay: 'over_sla300' , ALL: 'over_sla300' }
     );

     check(res, {
   	'get_idPay:over_sla400': (r) => r.timings.duration >400,
     },
     { get_idPay: 'over_sla400' , ALL: 'over_sla400' }
     );

     check(res, {
   	'get_idPay:over_sla500 ': (r) => r.timings.duration >500,
     },
     { get_idPay: 'over_sla500' , ALL: 'over_sla500' }
     );

     check(res, {
   	'get_idPay:over_sla600': (r) => r.timings.duration >600,
     },
     { get_idPay: 'over_sla600' , ALL: 'over_sla600' }
     );

     check(res, {
   	'get_idPay:over_sla800': (r) => r.timings.duration >800,
     },
     { get_idPay: 'over_sla800', ALL: 'over_sla800'  }
     );

     check(res, {
   	'get_idPay:over_sla1000': (r) => r.timings.duration >1000,
     },
     { get_idPay: 'over_sla1000', ALL: 'over_sla1000' }
     );


     check(
      res,
      {

  	 'get_idPay:ok_rate': (r) =>  statusTr !== undefined,
      },
      { get_idPay: 'ok_rate', ALL: 'ok_rate' }
  	);

    check(
      res,
      {

  	 'get_idPay:ko_rate': (r) => statusTr == undefined,
      },
      { get_idPay: 'ko_rate', ALL: 'ko_rate' }
    );  */

    return res;
	
}


export default function(){
	total();
}

