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
import { chiediInformazioniPagamento } from './api/chiediInformazioniPagamento.js';
import { ActivateIOPayment } from './api/ActivateIOPayment.js';
import { nodoNotificaAnnullamento } from './api/nodoNotificaAnnullamento.js';
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


//const scalini= run.getScalini[0]; 

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
      //startTime: '2s', // the ramping API test starts a little later
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
    'http_req_duration{chiediInformazioniPagamento:http_req_duration}': [],
    // we can reference the scenario names as well
    'http_req_duration{ActivateIOPayment:http_req_duration}': [],
	'http_req_duration{nodoNotificaAnnullamento:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	//'checks{webtest:ok_rate}': ['rate>0.85'],
	'checks{chiediInformazioniPagamento:over_sla300}': [],
	'checks{chiediInformazioniPagamento:over_sla400}': [],
	'checks{chiediInformazioniPagamento:over_sla500}': [],
	'checks{chiediInformazioniPagamento:over_sla600}': [],
	'checks{chiediInformazioniPagamento:over_sla800}': [],
	'checks{chiediInformazioniPagamento:over_sla1000}': [],
	'checks{chiediInformazioniPagamento:ok_rate}': [],
	'checks{chiediInformazioniPagamento:ko_rate}': [],
	'checks{ActivateIOPayment:over_sla300}': [],
	'checks{ActivateIOPayment:over_sla400}': [],
	'checks{ActivateIOPayment:over_sla500}': [],
	'checks{ActivateIOPayment:over_sla600}': [],
	'checks{ActivateIOPayment:over_sla800}': [],
	'checks{ActivateIOPayment:over_sla1000}': [],
	'checks{ActivateIOPayment:ok_rate}': [],
	'checks{ActivateIOPayment:ko_rate}': [],
	'checks{nodoNotificaAnnullamento:over_sla300}': [],
	'checks{nodoNotificaAnnullamento:over_sla400}': [],
	'checks{nodoNotificaAnnullamento:over_sla500}': [],
	'checks{nodoNotificaAnnullamento:over_sla600}': [],
	'checks{nodoNotificaAnnullamento:over_sla800}': [],
	'checks{nodoNotificaAnnullamento:over_sla1000}': [],
	'checks{nodoNotificaAnnullamento:ok_rate}': [],
	'checks{nodoNotificaAnnullamento:ko_rate}': [],
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

  let baseSoapUrl = "";
  let baseRestUrl = "";
  
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseSoapUrl = urls[key].SOAP_BASEURL;
		baseRestUrl = urls[key].REST_BASEURL;
      }
  }
  
    let rndAnagPsp = inputDataUtil.getAnagPsp();
	let rndAnagPa = inputDataUtil.getAnagPa();
    let rndAnagPaNew = inputDataUtil.getAnagPaNew();
    let noticeNmbr = genNoticeNumber();
    let idempotencyKey = genIdempotencyKey();
    
   
   	let res = ActivateIOPayment(baseSoapUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
	
    var doc = parseHTML(res.body);
    var script = doc.find('outcome');
    var outcome = script.text();
    
    var scriptToken = doc.find('paymentToken');
    var paymentToken = scriptToken.text();
      
    checks(res, outcome, 'OK');
 
 
    res = chiediInformazioniPagamento(baseRestUrl,paymentToken, rndAnagPaNew);
	 
    const ragioneSocialeExtr= res["ragioneSociale"];
     
    checks(res, ragioneSocialeExtr, rndAnagPaNew.PA);
 
 
 
    res =  nodoNotificaAnnullamento(baseRestUrl,paymentToken);
  	
	const esito= res["esito"];
	
    checks(res, esito,'OK');
  
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
    './scenarios/CT/test/output/TC04.09.summary.json': JSON.stringify(data), // and a JSON with all the details...
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	'./scenarios/CT/test/output/TC04.09.summary.csv': csv[0],
	'./scenarios/CT/test/output/TC04.09.trOverSla.csv': csv[1],
	'./scenarios/CT/test/output/TC04.09.resultCodeSummary.csv': csv[2],
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
      //'ALL OK status': (r) => r.status == 200,
	  'ALL OK status': (r) => outcome == pattern,
    },
    { ALL: 'ok_rate' }
	);
	
	 check(
    res,
    {
      //'ALL KO status': (r) => r.status !== 200,
	  'ALL KO status': (r) => outcome !== pattern,
    },
    { ALL: 'ko_rate' }
  );
	
}



