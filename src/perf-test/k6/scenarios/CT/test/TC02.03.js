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
import { sendPaymentOutput } from './api/sendPaymentOutput.js';
import { activatePaymentNotice } from './api/activatePaymentNotice.js';
import { RPT_Semplice_N3 } from './api/RPT_Semplice_N3.js';
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
	//let noticeNumber = "1" + String.format("%3s",String.valueOf(vars.get("hostIP"))).replace(" ","0") + user +  RandomStringUtils.randomNumeric(10);
    /*let noticeNumber = Math.random()*1000000000000000;
	noticeNumber=noticeNumber.toString().split('.')[0];
	if(noticeNumber.length==14){
		noticeNumber="0"+noticeNumber;
	}*/
	let noticeNumber='311';
	for (var i = 15; i > 0; --i) noticeNumber += chars[Math.floor(Math.random() * chars.length)];
	//let returnValue = "311"+noticeNumber.toString().split('.')[0];
	//console.log("noticeNumber="+returnValue);
	return noticeNumber;
}

// Idempotency
export function genIdempotencyKey(){
	//let key1 = Math.random()*100000000000;
	let key1='';
	let key2 = Math.round((Math.pow(36, 10 + 1) - Math.random() * Math.pow(36, 10))).toString(36).slice(1);
	//Math.random().toString(36).slice(2);
	
	/*key1 = key1.toString().split('.')[0];
	if(key1.length==10){
		key1 = "0"+key1;
	}*/
	//let returnValue=key1.toString().split('.')[0]+"_"+key2;
	for (var i = 11; i > 0; --i) key1 += chars[Math.floor(Math.random() * chars.length)];
	let returnValue=key1+"_"+key2;
	//console.log("IdempotencyKey="+returnValue);
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
          timeUnit: '3s',
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
    'http_req_duration{sendPaymentOutcome:http_req_duration}': [],
    // we can reference the scenario names as well
    'http_req_duration{activatePaymentNotice:http_req_duration}': [],
	'http_req_duration{RPT_Semplice_N3:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	//'checks{webtest:ok_rate}': ['rate>0.85'],
	'checks{sendPaymentOutcome:over_sla300}': [],
	'checks{sendPaymentOutcome:over_sla400}': [],
	'checks{sendPaymentOutcome:over_sla500}': [],
	'checks{sendPaymentOutcome:over_sla600}': [],
	'checks{sendPaymentOutcome:over_sla800}': [],
	'checks{sendPaymentOutcome:over_sla1000}': [],
	'checks{sendPaymentOutcome:ok_rate}': [],
	'checks{sendPaymentOutcome:ko_rate}': [],
	'checks{activatePaymentNotice:over_sla300}': [],
	'checks{activatePaymentNotice:over_sla400}': [],
	'checks{activatePaymentNotice:over_sla500}': [],
	'checks{activatePaymentNotice:over_sla600}': [],
	'checks{activatePaymentNotice:over_sla800}': [],
	'checks{activatePaymentNotice:over_sla1000}': [],
	'checks{activatePaymentNotice:ok_rate}': [],
	'checks{activatePaymentNotice:ko_rate}': [],
	'checks{RPT_Semplice_N3:over_sla300}': [],
	'checks{RPT_Semplice_N3:over_sla400}': [],
	'checks{RPT_Semplice_N3:over_sla500}': [],
	'checks{RPT_Semplice_N3:over_sla600}': [],
	'checks{RPT_Semplice_N3:over_sla800}': [],
	'checks{RPT_Semplice_N3:over_sla1000}': [],
	'checks{RPT_Semplice_N3:ok_rate}': [],
	'checks{RPT_Semplice_N3:ko_rate}': [],
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
  console.log(`${__ITER}`);
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPa = inputDataUtil.getAnagPa();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
    
   
   	let res = activatePaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);

   /*let outcome='';
   let paymentToken='';
   let creditorReferenceId='';
   try{
   let doc = parseHTML(res.body);
   let script = doc.find('outcome');
   outcome = script.text();
   script = doc.find('paymentToken');
   paymentToken = script.text();
   script = doc.find('creditorReferenceId');
   creditorReferenceId = script.text();
   }catch(error){}*/
     
    let paymentToken=res.paymentToken;
    let creditorReferenceId=res.creditorReferenceId;


 
  res = sendPaymentOutput(baseUrl,rndAnagPsp,paymentToken);



  console.log('prima di rpt='+paymentToken);
  res =  RPT_Semplice_N3(baseUrl,rndAnagPaNew,paymentToken, creditorReferenceId);

  
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
	//'./junit.xml': jUnit(data), // but also transform it and save it as a JUnit XML...
    [`./scenarios/CT/test/output/${d}_TC02.03.summary.json`]: JSON.stringify(data), // and a JSON with all the details...
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	[`./scenarios/CT/test/output/${d}_TC02.03.summary.csv`]: csv[0],
	[`./scenarios/CT/test/output/${d}_TC02.03.trOverSla.csv`]: csv[1],
	[`./scenarios/CT/test/output/${d}_TC02.03.resultCodeSummary.csv`]: csv[2],
	//'./xrayJunit.xml': generateXrayJUnitXML(data, 'summary.json', encoding.b64encode(JSON.stringify(data))),
 	
  };
  
}
