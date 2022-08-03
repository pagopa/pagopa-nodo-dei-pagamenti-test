import http from 'k6/http';
import { sleep } from 'k6';
import { Trend } from "k6/metrics";
import { check } from 'k6';
import encoding from 'k6/encoding';
import { scenario } from 'k6/execution';
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { jUnit, textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';
import { startSession } from './api/startSession.js';
import { pay_Check } from './api/pay_Check.js';
import { getWallet_v2 } from './api/getWallet_v2.js';
import { pay_CC_PayINternal } from './api/pay_CC_PayINternal.js';
import { pay_CC_Pay } from './api/pay_CC_Pay.js';
import { pay_CC_CheckOut } from './api/pay_CC_CheckOut.js';
import { ob_CC_Check_1 } from './api/ob_CC_Check_1.js';
import { ob_CC_Check_2 } from './api/ob_CC_Check_2.js';
import { ob_CC_Check_3 } from './api/ob_CC_Check_3.js';
import { ob_CC_continueToStep1 } from './api/ob_CC_continueToStep1.js';
import { ob_CC_Logout } from './api/ob_CC_Logout.js';
import { ob_CC_Challenge } from './api/ob_CC_Challenge.js';
import { ob_CC_Response} from './api/ob_CC_Response.js';
import { ob_CC_bye} from './api/ob_CC_bye.js';
import { ob_CC_resume3ds2} from './api/ob_CC_resume3ds2.js';
import { idpay_setup} from './idpay_setup_SIT.js';
import { parseHTML } from "k6/html";
import * as outputUtil from './util/output_util.js';
import * as inputDataUtil from './util/input_data_util.js';
//import * as db from './db/db.js';




const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_PM.csv'), { header: true }).data;
  
});



const myListAnno = ["24", "25", "25", "26", "27"];
const myListMese = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];

/*const csvTokens = new SharedArray('tokenIO_data', function () {
    
  return papaparse.parse(open('../../../data/tokenIOList.csv'), { header: true }).data;
});*/


 
export const getScalini = new SharedArray('scalini', function () {
	
 const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.log(f);
  return f; 
}); 



export const options = {
	
  scenarios: {
      	total: {
          timeUnit: '1s',
          preAllocatedVUs: 1, // how large the initial pool of VUs would be
          executor: 'ramping-arrival-rate',
          //executor: 'ramping-vus',
          maxVUs: 500,
          stages: [
            { target: getScalini[0].Scalino_CT_1, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_1+'s' },
            { target: getScalini[0].Scalino_CT_2, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_2, duration: getScalini[0].Scalino_CT_TIME_2+'s' },
            { target: getScalini[0].Scalino_CT_3, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_3, duration: getScalini[0].Scalino_CT_TIME_3+'s' },
            { target: getScalini[0].Scalino_CT_4, duration: 0+'s' },
    		{ target: getScalini[0].Scalino_CT_4, duration: getScalini[0].Scalino_CT_TIME_4+'s' },
    		{ target: getScalini[0].Scalino_CT_5, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_5, duration: getScalini[0].Scalino_CT_TIME_5+'s' },
            { target: getScalini[0].Scalino_CT_6, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_6, duration: getScalini[0].Scalino_CT_TIME_6+'s' },
            { target: getScalini[0].Scalino_CT_7, duration: 0+'s' },
    		{ target: getScalini[0].Scalino_CT_7, duration: getScalini[0].Scalino_CT_TIME_7+'s' },
    		{ target: getScalini[0].Scalino_CT_8, duration: 0+'s' },
    		{ target: getScalini[0].Scalino_CT_8, duration: getScalini[0].Scalino_CT_TIME_8+'s' },
    		{ target: getScalini[0].Scalino_CT_9, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_9, duration: getScalini[0].Scalino_CT_TIME_9+'s' },
            { target: getScalini[0].Scalino_CT_10, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_10, duration: getScalini[0].Scalino_CT_TIME_10+'s' }, //to uncomment
           ],
          tags: { test_type: 'ALL' },
          exec: 'total',
        }

      },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'count'],
  discardResponseBodies: false,
  thresholds: {
    // we can set different thresholds for the different scenarios because
    // of the extra metric tags we set!
    'http_req_duration{pay_Check:http_req_duration}': [],
	'http_req_duration{getWallet_v2:http_req_duration}': [],
	'http_req_duration{pay_CC_PayINternal:http_req_duration}': [],
	'http_req_duration{pay_CC_Pay:http_req_duration}': [],
	'http_req_duration{pay_CC_CheckOut:http_req_duration}': [],
	'http_req_duration{ob_CC_Check_1:http_req_duration}': [],
	'http_req_duration{ob_CC_Check_2:http_req_duration}': [],
	'http_req_duration{ob_CC_Check_3:http_req_duration}': [],
	'http_req_duration{ob_CC_continueToStep1:http_req_duration}': [],
	'http_req_duration{ob_CC_Logout:http_req_duration}': [],
	'http_req_duration{ob_CC_bye:http_req_duration}': [],

	'http_req_duration{ob_CC_Challenge:http_req_duration}': [],
	'http_req_duration{ob_CC_Response:http_req_duration}': [],
	'http_req_duration{ob_CC_resume3ds2:http_req_duration}': [],
	'http_req_duration{startSession:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': ['p(95)<200'], //95% of requests should be below 200ms
	'checks{pay_Check:over_sla300}': ['rate<0.9'], //90% of requests of this api should be below 300ms
	'checks{pay_Check:over_sla400}': [],
	'checks{pay_Check:over_sla500}': [],
	'checks{pay_Check:over_sla600}': [],
	'checks{pay_Check:over_sla800}': [],
	'checks{pay_Check:over_sla1000}': [],
	'checks{pay_Check:ok_rate}': [],
	'checks{pay_Check:ko_rate}': [],
	'checks{getWallet_v2:over_sla300}': [],
	'checks{getWallet_v2:over_sla400}': [],
	'checks{getWallet_v2:over_sla500}': [],
	'checks{getWallet_v2:over_sla600}': [],
	'checks{getWallet_v2:over_sla800}': [],
	'checks{getWallet_v2:over_sla1000}': [],
	'checks{getWallet_v2:ok_rate}': [],
	'checks{getWallet_v2:ko_rate}': [],
	'checks{pay_CC_PayINternal:over_sla300}': [],
	'checks{pay_CC_PayINternal:over_sla400}': [],
	'checks{pay_CC_PayINternal:over_sla500}': [],
	'checks{pay_CC_PayINternal:over_sla600}': [],
	'checks{pay_CC_PayINternal:over_sla800}': [],
	'checks{pay_CC_PayINternal:over_sla1000}': [],
	'checks{pay_CC_PayINternal:ok_rate}': [],
	'checks{pay_CC_PayINternal:ko_rate}': [],
	'checks{pay_CC_Pay:over_sla300}': [],
	'checks{pay_CC_Pay:over_sla400}': [],
	'checks{pay_CC_Pay:over_sla500}': [],
	'checks{pay_CC_Pay:over_sla600}': [],
	'checks{pay_CC_Pay:over_sla800}': [],
	'checks{pay_CC_Pay:over_sla1000}': [],
	'checks{pay_CC_Pay:ok_rate}': [],
	'checks{pay_CC_Pay:ko_rate}': [],
	'checks{pay_CC_CheckOut:over_sla300}': [],
	'checks{pay_CC_CheckOut:over_sla400}': [],
	'checks{pay_CC_CheckOut:over_sla500}': [],
	'checks{pay_CC_CheckOut:over_sla600}': [],
	'checks{pay_CC_CheckOut:over_sla800}': [],
	'checks{pay_CC_CheckOut:over_sla1000}': [],
	'checks{pay_CC_CheckOut:ok_rate}': [],
	'checks{pay_CC_CheckOut:ko_rate}': [],
	'checks{ob_CC_Check_1:over_sla300}': [],
	'checks{ob_CC_Check_1:over_sla400}': [],
	'checks{ob_CC_Check_1:over_sla500}': [],
	'checks{ob_CC_Check_1:over_sla600}': [],
	'checks{ob_CC_Check_1:over_sla800}': [],
	'checks{ob_CC_Check_1:over_sla1000}': [],
	'checks{ob_CC_Check_1:ok_rate}': [],
	'checks{ob_CC_Check_1:ko_rate}': [],
	'checks{ob_CC_Check_2:over_sla300}': [],
	'checks{ob_CC_Check_2:over_sla400}': [],
	'checks{ob_CC_Check_2:over_sla500}': [],
	'checks{ob_CC_Check_2:over_sla600}': [],
	'checks{ob_CC_Check_2:over_sla800}': [],
	'checks{ob_CC_Check_2:over_sla1000}': [],
	'checks{ob_CC_Check_2:ok_rate}': [],
	'checks{ob_CC_Check_2:ko_rate}': [],
	'checks{ob_CC_Check_3:over_sla300}': [],
	'checks{ob_CC_Check_3:over_sla400}': [],
	'checks{ob_CC_Check_3:over_sla500}': [],
	'checks{ob_CC_Check_3:over_sla600}': [],
	'checks{ob_CC_Check_3:over_sla800}': [],
	'checks{ob_CC_Check_3:over_sla1000}': [],
	'checks{ob_CC_Check_3:ok_rate}': [],
	'checks{ob_CC_Check_3:ko_rate}': [],
	'checks{ob_CC_continueToStep1:over_sla300}': [],
	'checks{ob_CC_continueToStep1:over_sla400}': [],
	'checks{ob_CC_continueToStep1:over_sla500}': [],
	'checks{ob_CC_continueToStep1:over_sla600}': [],
	'checks{ob_CC_continueToStep1:over_sla800}': [],
	'checks{ob_CC_continueToStep1:over_sla1000}': [],
	'checks{ob_CC_continueToStep1:ok_rate}': [],
	'checks{ob_CC_continueToStep1:ko_rate}': [],
	'checks{ob_CC_Logout:over_sla300}': [],
	'checks{ob_CC_Logout:over_sla400}': [],
	'checks{ob_CC_Logout:over_sla500}': [],
	'checks{ob_CC_Logout:over_sla600}': [],
	'checks{ob_CC_Logout:over_sla800}': [],
	'checks{ob_CC_Logout:over_sla1000}': [],
	'checks{ob_CC_Logout:ok_rate}': [],
	'checks{ob_CC_Logout:ko_rate}': [],
	'checks{ob_CC_bye:over_sla300}': [],
	'checks{ob_CC_bye:over_sla400}': [],
	'checks{ob_CC_bye:over_sla500}': [],
	'checks{ob_CC_bye:over_sla600}': [],
	'checks{ob_CC_bye:over_sla800}': [],
	'checks{ob_CC_bye:over_sla1000}': [],
	'checks{ob_CC_bye:ok_rate}': [],
	'checks{ob_CC_bye:ko_rate}': [],
	'checks{startSession:over_sla300}': [],
	'checks{startSession:over_sla400}': [],
	'checks{startSession:over_sla500}': [],
	'checks{startSession:over_sla600}': [],
	'checks{startSession:over_sla800}': [],
	'checks{startSession:over_sla1000}': [],
	'checks{startSession:ok_rate}': [],
	'checks{startSession:ko_rate}': [],
	'checks{ob_CC_Challenge:over_sla300}': [],
	'checks{ob_CC_Challenge:over_sla400}': [],
	'checks{ob_CC_Challenge:over_sla500}': [],
	'checks{ob_CC_Challenge:over_sla600}': [],
	'checks{ob_CC_Challenge:over_sla800}': [],
	'checks{ob_CC_Challenge:over_sla1000}': [],
	'checks{ob_CC_Challenge:ok_rate}': [],
	'checks{ob_CC_Challenge:ko_rate}': [],
	'checks{ob_CC_Response:over_sla300}': [],
	'checks{ob_CC_Response:over_sla400}': [],
	'checks{ob_CC_Response:over_sla500}': [],
	'checks{ob_CC_Response:over_sla600}': [],
	'checks{ob_CC_Response:over_sla800}': [],
	'checks{ob_CC_Response:over_sla1000}': [],
	'checks{ob_CC_Response:ok_rate}': [],
	'checks{ob_CC_Response:ko_rate}': [],
	'checks{ob_CC_resume3ds2:over_sla300}': [],
	'checks{ob_CC_resume3ds2:over_sla400}': [],
	'checks{ob_CC_resume3ds2:over_sla500}': [],
	'checks{ob_CC_resume3ds2:over_sla600}': [],
	'checks{ob_CC_resume3ds2:over_sla800}': [],
	'checks{ob_CC_resume3ds2:over_sla1000}': [],
	'checks{ob_CC_resume3ds2:ok_rate}': [],
	'checks{ob_CC_resume3ds2:ko_rate}': [],
	'checks{ALL:over_sla300}': [],
	'checks{ALL:over_sla400}': [],
	'checks{ALL:over_sla500}': [],
	'checks{ALL:over_sla600}': [],
	'checks{ALL:over_sla800}': [],
	'checks{ALL:over_sla1000}': [],
	'checks{ALL:ok_rate}': [],
	'checks{ALL:ko_rate}': ['rate<0.01'], //http errors should be less than 0.01%
	},
   
  
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
 
   
  let anagPayCC = inputDataUtil.getAnagPay_CC();
  let idWallet = anagPayCC.IdWallet;
  let tokenIO = anagPayCC.TokenIO;
  


  let res = startSession(baseUrl, tokenIO);
  //console.log(res);
  /*let out = '';
    try{
    out= res.body.toString();
    }catch(error){ out='NA' }
  commonChecks(res);
  standardChecks(res, out, 'substring', `"status":"REGISTERED_SPID"`);
  //let token = res["data.sessionToken"];
  let token = 'NA';
     try{
     token=res.json().data.sessionToken;
     }catch(error){}
   */
   let token = res.token;


  //to comment in perf
  res=idpay_setup();
  let idPay=res.json()[0].idPayment;
  console.log("idPay="+idPay);
  //-- fine comment in perf
  //let idPay = inputDataUtil.getPay().idPay; //to uncomment in perf



  res = getWallet_v2(baseUrl,token);


  
  res = pay_Check(baseUrl, idPay, token);
  //console.log(res);

  
  
  res = pay_CC_Pay(baseUrl, token, idWallet, idPay);
  //console.log(res);

  
  
  const chars = '0123456789';
  let rndSecCode='';
  for (var i = 3; i > 0; --i) rndSecCode += chars[Math.floor(Math.random() * chars.length)];
  res = pay_CC_PayINternal(baseUrl, rndSecCode);
  let idTr=res.idTr;
  let RED_Path=res.RED_Path;

  
 
  //RED_Path='/fgfgggg?op=1'
  res=pay_CC_CheckOut(baseUrl, RED_Path);
  idTr=res.idTr;

  

  let resCheck1 = '';
  let statusTr = undefined;
  do {
    resCheck1 = ob_CC_Check_1(baseUrl, idTr);
    statusTr=resCheck1.statusTr;
    }
  while (!(statusTr == 'Confermato' || statusTr == 'In attesa del metodo 3ds2'))
  //console.log("dopo while");



 if(statusTr === 'In attesa del metodo 3ds2'){
    //if(statusTr === 'Confermato'){ //to comment

	 let threeDSMethodData = 'threeDSMethodData';
     res = ob_CC_continueToStep1(baseUrl, idTr, threeDSMethodData);


       let resCheck2 = '';
       let creq = '';
       do {
             resCheck2 = ob_CC_Check_2(baseUrl, idTr);
             statusTr = resCheck2.statusTr;
             creq=resCheck2.creq;
           }
       while (statusTr !== 'In attesa della challenge 3ds2');



       res= ob_CC_Challenge(baseUrl, creq); //baseUrlPM
       let threedstransId = res.threedstransId;



       res= ob_CC_Response(baseUrl, threedstransId, token); //baseUrlPM



       let rndCres ='';
       let chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
       for (var i = 12; i > 0; --i) rndCres += chars[Math.floor(Math.random() * chars.length)];
       res= ob_CC_resume3ds2(baseUrl, idTr, rndCres);



       let resCheck3 = '';
       	  do {
              resCheck3 = ob_CC_Check_3(baseUrl, idTr);
              statusTr = resCheck3.statusTr;
              }
          while (statusTr !== 'Confermato');

 }



 res= ob_CC_Logout(baseUrl, idTr);
 RED_Path=res.RED_Path;
 idTr=res.idTr;



 RED_Path="/hfhfhfhfh?tyty=1"; //to comment
 res= ob_CC_bye(baseUrl, RED_Path);


}



export default function(){
	total();
}


export function handleSummary(data) {
  console.log('Preparing the end-of-test summary...');
 
  var csv = outputUtil.extractData(data);
	 
   return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true, expected_response: 'ALL' }), // Show the text summary to stdout...
	'./scenarios/PMCS_CT/test/output/TC01.03.summary.json': JSON.stringify(data), // and a JSON with all the details...
	'./scenarios/PMCS_CT/test/output/TC01.03.summary.xml': jUnit(data),
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	'./scenarios/PMCS_CT/test/output/TC01.03.summary.csv': csv[0],
	'./scenarios/PMCS_CT/test/output/TC01.03.trOverSla.csv': csv[1],
	'./scenarios/PMCS_CT/test/output/TC01.03.resultCodeSummary.csv': csv[2],
	 	
  };
  
}


export function commonChecks(res){
	
	check(res, {
 	'ALL over_sla300': (r) => r.timings.duration >300,
   },
   { ALL: 'over_sla300' }
   );
   
   check(res, {
 	'ALL over_sla400': (r) => r.timings.duration >400,
   },
   { ALL: 'over_sla400' }
   );
   
   check(res, {
 	'ALL over_sla500': (r) => r.timings.duration >500,
   },
   { ALL: 'over_sla500' }
   );
   
   check(res, {
 	'ALL over_sla600': (r) => r.timings.duration >600,
   },
   { ALL: 'over_sla600' }
   );
   
   check(res, {
 	'ALL over_sla800': (r) => r.timings.duration >800,
   },
   { ALL: 'over_sla800' }
   );
   
   check(res, {
 	'ALL over_sla1000': (r) => r.timings.duration >1000,
   },
   { ALL: 'over_sla1000' }
   );
}



export function standardChecks(res, outcome, rule, pattern) {
	
	
   
   if (rule !=='substring'){
   check(
    res,
    {
     'ALL OK status': (r) => outcome == pattern,
    },
    { ALL: 'ok_rate' }
	);
	
	 check(
    res,
    {
      'ALL KO status': (r) => outcome !== pattern,
    },
    { ALL: 'ko_rate' }
  );
   }else{
  
    check(
    res,
    {
    
	 'ALL:ok_rate': (r) => outcome.toString().includes(pattern),
    },
    { ALL: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ALL:ko_rate': (r) => !outcome.toString().includes(pattern),
    },
    { ALL: 'ko_rate' }
  );
   }

}




export function invertedChecks(res, outcome, rule, pattern) {
	
	
   
   if (rule !=='substring'){
   check(
    res,
    {
     'ALL OK status': (r) => outcome !== pattern,
    },
    { ALL: 'ok_rate' }
	);
	
	 check(
    res,
    {
      'ALL KO status': (r) => outcome == pattern,
    },
    { ALL: 'ko_rate' }
  );
   }else{
  
    check(
    res,
    {
    
	 'ALL:ok_rate': (r) => !outcome.toString().includes(pattern),
    },
    { ALL: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ALL:ko_rate': (r) => outcome.toString().includes(pattern),
    },
    { ALL: 'ko_rate' }
  );
   }

}