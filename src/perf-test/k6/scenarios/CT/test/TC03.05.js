//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { sendPaymentOutput_NN } from './api/sendPaymentOutput_NN.js';
import { activatePaymentNotice_NN } from './api/activatePaymentNotice_NN.js';
import { verifyPaymentNotice_NN } from './api/verifyPaymentNotice_NN.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';
//import exec from 'k6/execution';
//import { getCurrentStageIndex } from 'https://jslib.k6.io/k6-utils/1.3.0/index.js';
//import * as test_selector from '../../test_selector.js';



const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;
  
});


const chars = '0123456789';
// NoticeNumber
export function genNoticeNumber(){
	let noticeNumber='311';
	for (var i = 15; i > 0; --i) noticeNumber += chars[Math.floor(Math.random() * chars.length)];
	return noticeNumber;
}

// Idempotency
export function genIdempotencyKey(){
	let key1='';
	let key2 = Math.round((Math.pow(36, 10 + 1) - Math.random() * Math.pow(36, 10))).toString(36).slice(1);
	for (var i = 11; i > 0; --i) key1 += chars[Math.floor(Math.random() * chars.length)];
	let returnValue=key1+"_"+key2;
	return returnValue;
}



//const scalini= run.getScalini[0]; 

export const getScalini = new SharedArray('scalini', function () {
	
  // here you can open files, and then do additional processing or generate the array with data dynamically
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.debug(f);
  return f; // f must be an array[]
});

export const options = {
  //rps: 5,
  scenarios: {
      	total: {
          timeUnit: '3000ms',
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
    'http_req_duration{sendPaymentOutcome_NN:http_req_duration}': [],
    // we can reference the scenario names as well
    'http_req_duration{activatePaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{verifyPaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	//'checks{webtest:ok_rate}': ['rate>0.85'],
	'checks{sendPaymentOutcome_NN:over_sla300}': [],
	'checks{sendPaymentOutcome_NN:over_sla400}': [],
	'checks{sendPaymentOutcome_NN:over_sla500}': [],
	'checks{sendPaymentOutcome_NN:over_sla600}': [],
	'checks{sendPaymentOutcome_NN:over_sla800}': [],
	'checks{sendPaymentOutcome_NN:over_sla1000}': [],
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
	'checks{verifyPaymentNotice_NN:over_sla300}': [],
	'checks{verifyPaymentNotice_NN:over_sla400}': [],
	'checks{verifyPaymentNotice_NN:over_sla500}': [],
	'checks{verifyPaymentNotice_NN:over_sla600}': [],
	'checks{verifyPaymentNotice_NN:over_sla800}': [],
	'checks{verifyPaymentNotice_NN:over_sla1000}': [],
	'checks{verifyPaymentNotice_NN:ok_rate}': [],
	'checks{verifyPaymentNotice_NN:ko_rate}': [],
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

  /*console.debug("current stage index="+getCurrentStageIndex());
  console.debug(exec.test.options.scenarios.total.stages[getCurrentStageIndex()].target);
  options.rps = exec.test.options.scenarios.total.stages[getCurrentStageIndex()].target;
  console.debug(options.rps);*/

  let baseUrl = "";
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseUrl = urls[key].SOAP_BASEURL;
      }
  }
 
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
    
   
  let res =  verifyPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);



 res = activatePaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey,2);
 let paymentToken=res.paymentToken;



  res = sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken);


}


export default function(){
	total();
}


export function handleSummary(data) {
  console.debug('Preparing the end-of-test summary...');
 
  return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)
  
}

/*
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
      //'ALL OK status': (r) => r.status == 200,
	  'ALL OK status': (r) => outcome == 'OK'
    },
    { ALL: 'ok_rate' }
	);
	
	 check(
    res,
    {
      //'ALL KO status': (r) => r.status !== 200,
	  'ALL KO status': (r) => outcome !== 'OK',
    },
    { ALL: 'ko_rate' }
  );
	
} */
