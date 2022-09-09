import http from 'k6/http';
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';



const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_PM.csv'), { header: true }).data;
  
});


export function reqBody() {
return `
{
  "identificativoIntermediarioPA": "90000000001",
  "identificativoStazioneIntermediarioPA": "90000000001_01",
  "identificativoDominio": "90000000001",
  "importoTotaleDaVersare": "8.15",
  "responseEnum": "OK"
}
`
};


export function idpay_setup() {

  let baseUrl = "";
  let baseUrlPM = "";
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseUrl = urls[key].BASEURL;
		baseUrlPM = urls[key].MOCK_PM_BASEURL;
      }
  }
  
  let body= { "identificativoIntermediarioPA": "90000000001",
              "identificativoStazioneIntermediarioPA": "90000000001_01",
              "identificativoDominio": "90000000001",
              "importoTotaleDaVersare": "8.15",
              "responseEnum": "OK"
            };
 
   const res = http.patch(
    'https://api.dev.platform.pagopa.it/payment-manager/mock-services/v1/nodo/sit/send/rpt',
    JSON.stringify(body),
    { headers: { 'Ocp-Apim-Subscription-Key':'38be466128d341cdb47400a1a14cedfe' , 'Content-Type': 'application/json',
    'Num-Payments':'1'} ,
	tags: { idPaySetup: 'http_req_duration'}
	}
  );
    //console.log(res);
    let idPay=res.json()[0].idPayment;
    console.log(';'+res.status+';'+idPay+';');
	
	return res;
}


export default function(){
	idpay_setup();
}




