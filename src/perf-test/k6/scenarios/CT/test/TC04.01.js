import http from 'k6/http';
import { sleep } from 'k6';
import { Trend } from "k6/metrics";
import { check } from 'k6';
import encoding from 'k6/encoding';
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { scenario } from 'k6/execution';
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { jUnit, textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';
import { ActivateIOPayment } from './api/ActivateIOPayment.js';
import { Verifica } from './api/Verifica.js';
import * as outputUtil from './util/output_util.js';
import * as inputDataUtil from './util/input_data_util.js';
import { parseHTML } from "k6/html";
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


export const getScalini = new SharedArray('scalini', function () {
	
  // here you can open files, and then do additional processing or generate the array with data dynamically
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.log(f);
  return f; // f must be an array[]
});

export const options = {
	
  scenarios: {
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
	
  },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'count'],
  discardResponseBodies: false,
  thresholds: {
    // we can set different thresholds for the different scenarios because
    // of the extra metric tags we set!
    'http_req_duration{ActivateIOPayment:http_req_duration}': [],
    // we can reference the scenario names as well
    'http_req_duration{Verifica:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	//'checks{webtest:ok_rate}': ['rate>0.85'],
	'checks{ActivateIOPayment:over_sla300}': ['rate<0.50'],
	'checks{ActivateIOPayment:over_sla400}': ['rate<0.45'],
	'checks{ActivateIOPayment:over_sla500}': ['rate<0.40'],
	'checks{ActivateIOPayment:over_sla600}': ['rate<0.30'],
	'checks{ActivateIOPayment:over_sla800}': ['rate<0.10'],
	'checks{ActivateIOPayment:over_sla1000}': ['rate<0.05'],
	'checks{ActivateIOPayment:ok_rate}': [],
	'checks{ActivateIOPayment:ko_rate}': [],
	'checks{Verifica:over_sla300}': [],
	'checks{Verifica:over_sla400}': [],
	'checks{Verifica:over_sla500}': [],
	'checks{Verifica:over_sla600}': [],
	'checks{Verifica:over_sla800}': [],
	'checks{Verifica:over_sla1000}': [],
	'checks{Verifica:ok_rate}': [],
	'checks{Verifica:ko_rate}': [],
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


export function genIuv(){
	
	let iuv = Math.random()*100000000000000000;
	iuv = iuv.toString().split('.')[0];
	let user ="";
	let returnValue=user+iuv;
    return returnValue;

}

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
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
    
  let iuv = genIuv();
   
  let res =  Verifica(baseUrl,rndAnagPsp,rndAnagPaNew,iuv, 3);
  
  let doc = parseHTML(res.body);
  let script = doc.find('esito');
  let outcome = script.text();
    
  checks(res, outcome, 'OK');
  
  res = ActivateIOPayment(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
	 
  doc = parseHTML(res.body);
  script = doc.find('faultCode');
  outcome = script.text();
     
  checks(res, outcome, "PPT_MULTI_BENEFICIARIO");
  
    
}


export default function(){
	total();
}


export function handleSummary(data) {
  console.log('Preparing the end-of-test summary...');
 
  var csv = outputUtil.extractData(data);
     
   return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true, expected_response: 'ALL' }), // Show the text summary to stdout...
	//'./junit.xml': jUnit(data), // but also transform it and save it as a JUnit XML...
    './scenarios/CT/test/output/TC04.01.summary.json': JSON.stringify(data), // and a JSON with all the details...
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	'./scenarios/CT/test/output/TC04.01.summary.csv': csv[0],
	'./scenarios/CT/test/output/TC04.01.trOverSla.csv': csv[1],
	'./scenarios/CT/test/output/TC04.01.resultCodeSummary.csv': csv[2],
	//'./xrayJunit.xml': generateXrayJUnitXML(data, 'summary.json', encoding.b64encode(JSON.stringify(data))),
 	
  };
  
}


export function checks(res, outcome, pattern) {
	
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
	
}