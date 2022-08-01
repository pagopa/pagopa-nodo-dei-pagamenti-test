import http from 'k6/http';
import { scenario } from 'k6/execution';
import { SharedArray } from 'k6/data';
import * as inputDataUtil from './util/input_data_util.js';
import { startSession } from './api/startSession.js';
import { ob_CC_Onboard } from './api/ob_CC_Onboard.js';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';



const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_PM.csv'), { header: true }).data;
  
});




 
export const getScalini = new SharedArray('scalini', function () {
	
 const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.log(f);
  return f; 
}); 



export const options = {
	
   /* scenarios: {
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
	
  }, */

  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'count'],
  discardResponseBodies: false,
   
  
}; 



export function reqBody(tokenIO, mail) {
return `
{
"name": "Mecren",
"familyName": "Valentini",
"spidEmail": "${mail}",
"noticeEmail": "${mail}",
"fiscalCode": "TBTNIZ20C79Y859O",
"sessionToken": "${tokenIO}"
}
`
};

 



export function total() {

  let baseUrl = "";
  let baseUrlPM = "";
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseUrl = urls[key].BASEURL;
		baseUrlPM = urls[key].MOCK_PM_BASEURL;
      }
  }
  
 /*
  let resGetUser = http.get(
    'https://portal.test.pagopa.gov.it/pmmockserviceapi/cd/user/get',
    { headers: { 'Content-Type': 'application/json'}
	}
  ); 

   let obj = resGetUser.body;
   let tokenIO= obj.sessionToken;*/
 //  console.log('tokenIO='+tokenIO);
  
  let users = ["aPPantani@nft.it", "gPPgiuggiole@nft.it", "pPPpagliaccio@nft.it", "zPPzabalai@nft.it","sPPsacs@nft.it"];
  let mail='';
  let tokenIO='';
  var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  var charactersLength = characters.length;
  for ( var i = 0; i < 22; i++ ) {
      tokenIO += characters.charAt(Math.floor(Math.random() *  charactersLength));
  }
  mail= users[Math.floor(Math.random() * users.length)];

  let body = {"name": "Mecren",
             "familyName": "Valentini",
             "spidEmail": mail,
             "noticeEmail": mail,
             "fiscalCode": "TBTNIZ20C79Y859O",
             "sessionToken": tokenIO
             };

   let res = http.put(
    'https://api.dev.platform.pagopa.it/pmmockserviceapi/cd/user/save',
    JSON.stringify(body),
    { headers: { 'Accept':'*/*', 'Content-Type': 'application/json'} ,
	tags: { userInjection: 'http_req_duration'}
	}
  );

    //console.log(';'+res.status+';'+tokenIO);
		
	 res = startSession(baseUrl, tokenIO);
     let token = res.token;



      const myListAnno = ["24", "25", "25", "26", "27"];
      const myListMese = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
      let rndCard = inputDataUtil.getCards().cardNumber;
      let rndM = Math.floor(Math.random() * myListMese.length);
      let scdMese = myListMese[rndM];
      let rndY = Math.floor(Math.random() * myListAnno.length);
      let scdAnno = myListAnno[rndY];

      res = ob_CC_Onboard(baseUrl,token, rndCard, scdMese, scdAnno);

      console.log(";"+res.status+";"+tokenIO+";"+res.outcome+";"+rndCard)

}


export default function(){
	total();
}



