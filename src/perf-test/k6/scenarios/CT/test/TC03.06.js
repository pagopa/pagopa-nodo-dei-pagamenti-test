import http from 'k6/http';
import { sleep } from 'k6';
import { Trend } from "k6/metrics";
import { check } from 'k6';
import encoding from 'k6/encoding';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { scenario } from 'k6/execution';
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { jUnit, textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';
import { sendPaymentOutput_NN } from './api/sendPaymentOutput_NN.js';
import { activatePaymentNotice_NN } from './api/activatePaymentNotice_NN.js';
import { demandPaymentNotice_NN } from './api/demandPaymentNotice_NN.js';
import * as outputUtil from './util/output_util.js';
import * as inputDataUtil from './util/input_data_util.js';
import { parseHTML } from "k6/html";



const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;
  
});


const chars = '0123456789';
// Idempotency
export function genIdempotencyKey(){
	let key1='';
	let key2 = Math.round((Math.pow(36, 10 + 1) - Math.random() * Math.pow(36, 10))).toString(36).slice(1);
	for (var i = 11; i > 0; --i) key1 += chars[Math.floor(Math.random() * chars.length)];
	let returnValue=key1+"_"+key2;
	return returnValue;
}



export const getScalini = new SharedArray('scalini', function () {

  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  return f; 
});

export const options = {
	
  scenarios: {
      	total: {
          timeUnit: '1s',
          preAllocatedVUs: 1, // how large the initial pool of VUs would be
          executor: 'ramping-arrival-rate',
          //executor: 'ramping-vus',
          maxVUs: 300,
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
    'http_req_duration{sendPaymentOutcome_NN:http_req_duration}': [],
    'http_req_duration{activatePaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{demandPaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	'checks{sendPaymentOutcome_NN:over_sla300}': [],//['rate<0.50'],
	'checks{sendPaymentOutcome_NN:over_sla400}': [],//['rate<0.45'],
	'checks{sendPaymentOutcome_NN:over_sla500}': [],//['rate<0.40'],
	'checks{sendPaymentOutcome_NN:over_sla600}': [],//['rate<0.30'],
	'checks{sendPaymentOutcome_NN:over_sla800}': [],//['rate<0.10'],
	'checks{sendPaymentOutcome_NN:over_sla1000}': [],//['rate<0.05'],
	'checks{sendPaymentOutcome_NN:ok_rate}': [],
	'checks{sendPaymentOutcome_NN:ko_rate}': [],
	'checks{activatePaymentNotice_NN:over_sla300}': [],
	'checks{activatePaymentNotice_NN:over_sla400}': [],
	'checks{activatePaymentNotice_NN:over_sla500}': [],
	'checks{activatePaymentNotice_NN:over_sla600}': [],
	'checks{activatePaymentNotice_NN:over_sla800}': [],
	'checks{activatePaymentNotice_NN:over_sla1000}': [],
	'checks{activatePaymentNotice_NN:ok_rate}': [],
	'checks{activatePaymentNotice_NN:ko_rate}': [],
	'checks{demandPaymentNotice_NN:over_sla300}': [],
	'checks{demandPaymentNotice_NN:over_sla400}': [],
	'checks{demandPaymentNotice_NN:over_sla500}': [],
	'checks{demandPaymentNotice_NN:over_sla600}': [],
	'checks{demandPaymentNotice_NN:over_sla800}': [],
	'checks{demandPaymentNotice_NN:over_sla1000}': [],
	'checks{demandPaymentNotice_NN:ok_rate}': [],
	'checks{demandPaymentNotice_NN:ko_rate}': [],
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

  let baseUrl = "";
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseUrl = urls[key].SOAP_BASEURL;
      }
  }
 
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let idempotencyKey = genIdempotencyKey();
    
	
   
  let res =  demandPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew);
  let noticeNmbr = res.noticeNmbr;
  
  
  
  res = activatePaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey,2);
  let paymentToken = res.paymentToken;
   
  
 
  res = sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken);

}


export default function(){
	total();
}


export function handleSummary(data) {
  console.log('Preparing the end-of-test summary...');
 
  var csv = outputUtil.extractData(data);
     
   return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true, expected_response: 'ALL' }), // Show the text summary to stdout...
	'./scenarios/CT/test/output/TC03.06.summary.json': JSON.stringify(data), // and a JSON with all the details...
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	'./scenarios/CT/test/output/TC03.06.summary.csv': csv[0],
	'./scenarios/CT/test/output/TC03.06.trOverSla.csv': csv[1],
	'./scenarios/CT/test/output/TC03.06.resultCodeSummary.csv': csv[2],
	
  };
  
}


export function checks(res, outcome) {
	
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
   
   check(
    res,
    {
     'ALL OK status': (r) => outcome == 'OK'
    },
    { ALL: 'ok_rate' }
	);
	
	 check(
    res,
    {
     'ALL KO status': (r) => outcome !== 'OK',
    },
    { ALL: 'ko_rate' }
  );
	
}
