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
import { getWallet_v3 } from './api/getWallet_v3.js';
import { pay_PP_Check } from './api/pay_PP_Check.js';
import { pay_PP_Pay } from './api/pay_PP_Pay.js';
import { B_Check } from './api/B_Check.js';
import { pay_PP_Logout } from './api/pay_PP_Logout.js';
import { pay_PP_bye } from './api/pay_PP_bye.js';
import { parseHTML } from "k6/html";
import { idpay_setup} from './idpay_setup_SIT.js';
import * as outputUtil from './util/output_util.js';
import * as inputDataUtil from './util/input_data_util.js';
//import exec from 'k6/execution';
//import { getCurrentStageIndex } from 'https://jslib.k6.io/k6-utils/1.3.0/index.js';
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
    //rps: 10,
     /* stages: [
                   { target: getScalini[0].Scalino_CT_1, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
                   { target: getScalini[0].Scalino_CT_1, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_1+'s' },
                   { target: getScalini[0].Scalino_CT_2, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
                   { target: getScalini[0].Scalino_CT_2, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_2+'s' },
                   { target: getScalini[0].Scalino_CT_3, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
                   { target: getScalini[0].Scalino_CT_3, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_3+'s' },
                   { target: getScalini[0].Scalino_CT_4, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
           		  { target: getScalini[0].Scalino_CT_4, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_4+'s' },
           		  { target: getScalini[0].Scalino_CT_5, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
                   { target: getScalini[0].Scalino_CT_5, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_5+'s' },
                   { target: getScalini[0].Scalino_CT_6, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
                   { target: getScalini[0].Scalino_CT_6, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_6+'s' },
                   { target: getScalini[0].Scalino_CT_7, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
           		  { target: getScalini[0].Scalino_CT_7, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_7+'s' },
           		  { target: getScalini[0].Scalino_CT_8, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
           		  { target: getScalini[0].Scalino_CT_8, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_8+'s' },
           		  { target: getScalini[0].Scalino_CT_9, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
                   { target: getScalini[0].Scalino_CT_9, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_9+'s' },
                   { target: getScalini[0].Scalino_CT_10, rps: getScalini[0].Scalino_CT_1, duration: 0+'s' },
                   { target: getScalini[0].Scalino_CT_10, rps: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_10+'s' }, //to uncomment
                  ],
*/
  //  gracefulStop: '0s',
    scenarios: {

        	total: {
            timeUnit: '9s', //7s dev'essere uguale al n°di richieste per ogni iterazione --> n°di primitive (inclusa getIdPay) + stima check ripetute 2/3
            preAllocatedVUs: 1, // how large the initial pool of VUs would be
            executor: 'ramping-arrival-rate',
            //executor: 'ramping-vus',
            //gracefulStop: '0s',
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
    'http_req_duration{getWallet_v3:http_req_duration}': [],
    'http_req_duration{startSession:http_req_duration}': [],
	'http_req_duration{pay_PP_Check:http_req_duration}': [],
	'http_req_duration{pay_PP_Pay:http_req_duration}': [],
	//'http_req_duration{get_idPay:http_req_duration}': [],
	'http_req_duration{B_Check:http_req_duration}': [],
	'http_req_duration{pay_PP_Logout:http_req_duration}': [],
	'http_req_duration{pay_PP_bye:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	'checks{getWallet_v3:over_sla300}': [],
	'checks{getWallet_v3:over_sla400}': [],
	'checks{getWallet_v3:over_sla500}': [],
	'checks{getWallet_v3:over_sla600}': [],
	'checks{getWallet_v3:over_sla800}': [],
	'checks{getWallet_v3:over_sla1000}': [],
	'checks{getWallet_v3:ok_rate}': [],
	'checks{getWallet_v3:ko_rate}': [],
	/*'checks{get_idPay:over_sla300}': [],
    'checks{get_idPay:over_sla400}': [],
    'checks{get_idPay:over_sla500}': [],
    'checks{get_idPay:over_sla600}': [],
    'checks{get_idPay:over_sla800}': [],
    'checks{get_idPay:over_sla1000}': [],
    'checks{get_idPay:ok_rate}': [],
    'checks{get_idPay:ko_rate}': [], */
	'checks{startSession:over_sla300}': [],
	'checks{startSession:over_sla400}': [],
	'checks{startSession:over_sla500}': [],
	'checks{startSession:over_sla600}': [],
	'checks{startSession:over_sla800}': [],
	'checks{startSession:over_sla1000}': [],
	'checks{startSession:ok_rate}': [],
	'checks{startSession:ko_rate}': [],
	'checks{pay_PP_Check:over_sla300}': [],
	'checks{pay_PP_Check:over_sla400}': [],
	'checks{pay_PP_Check:over_sla500}': [],
	'checks{pay_PP_Check:over_sla600}': [],
	'checks{pay_PP_Check:over_sla800}': [],
	'checks{pay_PP_Check:over_sla1000}': [],
	'checks{pay_PP_Check:ok_rate}': [],
	'checks{pay_PP_Check:ko_rate}': [],
	'checks{pay_PP_Pay:over_sla300}': [],
	'checks{pay_PP_Pay:over_sla400}': [],
	'checks{pay_PP_Pay:over_sla500}': [],
	'checks{pay_PP_Pay:over_sla600}': [],
	'checks{pay_PP_Pay:over_sla800}': [],
	'checks{pay_PP_Pay:over_sla1000}': [],
	'checks{pay_PP_Pay:ok_rate}': [],
	'checks{pay_PP_Pay:ko_rate}': [],
	'checks{B_Check:over_sla300}': [],
	'checks{B_Check:over_sla400}': [],
	'checks{B_Check:over_sla500}': [],
	'checks{B_Check:over_sla600}': [],
	'checks{B_Check:over_sla800}': [],
	'checks{B_Check:over_sla1000}': [],
	'checks{B_Check:ok_rate}': [],
	'checks{B_Check:ko_rate}': [],
	'checks{pay_PP_Logout:over_sla300}': [],
	'checks{pay_PP_Logout:over_sla400}': [],
	'checks{pay_PP_Logout:over_sla500}': [],
	'checks{pay_PP_Logout:over_sla600}': [],
	'checks{pay_PP_Logout:over_sla800}': [],
	'checks{pay_PP_Logout:over_sla1000}': [],
	'checks{pay_PP_Logout:ok_rate}': [],
	'checks{pay_PP_Logout:ko_rate}': [],
	'checks{pay_PP_bye:over_sla300}': [],
	'checks{pay_PP_bye:over_sla400}': [],
	'checks{pay_PP_bye:over_sla500}': [],
	'checks{pay_PP_bye:over_sla600}': [],
	'checks{pay_PP_bye:over_sla800}': [],
	'checks{pay_PP_bye:over_sla1000}': [],
	'checks{pay_PP_bye:ok_rate}': [],
	'checks{pay_PP_bye:ko_rate}': [],
	'checks{ALL:over_sla300}': [],
	'checks{ALL:over_sla400}': [],
	'checks{ALL:over_sla500}': [],
	'checks{ALL:over_sla600}': [],
	'checks{ALL:over_sla800}': [],
	'checks{ALL:over_sla1000}': [],
	'checks{ALL:ok_rate}': [],
	'checks{ALL:ko_rate}': [],
	},
   
  
}; 





export function total() {

  /*const targetRps = exec.instance.vusActive;
  const before = new Date().getTime();
  console.log('currentStageIndex='+getCurrentStageIndex());
  options.rps = exec.test.options.scenarios.total.stages[getCurrentStageIndex()].target; */


  let baseUrl = "";
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
           baseUrl = urls[key].BASEURL;
	   }
  }
 
   
  let anagPayPP = inputDataUtil.getAnagPay_PP();
  let idWallet = anagPayPP.IdWallet;
  let tokenIO = anagPayPP.TokenIO;

  
  
  let res = startSession(baseUrl, tokenIO);

  let token = res.token;

    
  //token='dhry56rhfyr'; //to comment
  res = getWallet_v3(baseUrl,token);



  res=idpay_setup();
  let idPay=res.json()[0].idPayment;
  //console.log("idPay="+idPay);

  //let idPay = inputDataUtil.getPay().idPay; //to uncomment in perf --> in realtà riccardi consiglia la generazione dinamica
  
  
  res = pay_PP_Check(baseUrl, idPay, token);

  

  console.log('token='+token+'idWallet='+idWallet+'idPay'+idPay);
  res = pay_PP_Pay(baseUrl, token, idWallet, idPay);
  let idTr=res.idTr;

  
  
  
  let resBCheck = '';
  let statusTr = '';
  do {
  //console.log("dentro while");
  resBCheck = B_Check(baseUrl, idTr);
  statusTr=resBCheck.statusTr;
  }
  while (statusTr !== 'Confermato');
  
  
  
  res= pay_PP_Logout(baseUrl, idTr);
  let RED_Path = res.RED_Path;
  idTr = res.idTr;

  
  
  //RED_Path="/hfhfhfhfh?tyty=1"; //to comment
  res= pay_PP_bye(baseUrl, RED_Path);

}


export default function(){
	total();

}


export function handleSummary(data) {
  console.log('Preparing the end-of-test summary...');
 
  var csv = outputUtil.extractData(data);
  let d = (new Date).toISOString().substr(0,10);
   return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true, expected_response: 'ALL' }), // Show the text summary to stdout...
	 [`./scenarios/PMCS_CT/test/output/${d}_TC01.04.summary.json`]: JSON.stringify(data), // and a JSON with all the details...
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	 [`./scenarios/PMCS_CT/test/output/${d}_TC01.04.summary.csv`]: csv[0],
	 [`./scenarios/PMCS_CT/test/output/${d}_TC01.04.trOverSla.csv`]: csv[1],
	 [`./scenarios/PMCS_CT/test/output/${d}_TC01.04.resultCodeSummary.csv`]: csv[2],
	 	
  };
  
}




