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
import { verifyPaymentNotice } from './api/verifyPaymentNotice.js';
import { activatePaymentNotice } from './api/activatePaymentNotice.js';
import * as outputUtil from './util/output_util.js';
import { parseHTML } from "k6/html";
//import * as test_selector from '../../test_selector.js';


const csvAnagPsp = new SharedArray('PSP_data', function () {
    
  return papaparse.parse(open('../../../data/anagraficaPSP_ALL.csv'), { header: true }).data;
});

const csvAnagPa = new SharedArray('PA_data', function () {
  
  return papaparse.parse(open('../../../data/anagraficaPA.csv'), { header: true }).data;
});

const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL.csv'), { header: true }).data;
  
});


// NoticeNumber
export function genNoticeNumber(){
	//let noticeNumber = "1" + String.format("%3s",String.valueOf(vars.get("hostIP"))).replace(" ","0") + user +  RandomStringUtils.randomNumeric(10);
    let noticeNumber = Math.random()*1000000000000000;
	let returnValue = "311"+noticeNumber.toString().split('.')[0];
	//console.log("noticeNumber="+returnValue);
	return returnValue;
}

// Idempotency
export function genIdempotencyKey(){
	let key1 = Math.random()*10000000000;
	let key2 = Math.random().toString(36).slice(2);
	let returnValue=key2+"_"+key1.toString().split('.')[0];
	//console.log("IdempotencyKey="+returnValue);
	return returnValue;
}

//const scalini= run.getScalini[0]; 

export const getScalini = new SharedArray('scalini', function () {
	//console.log('Steps='+`${__ENV.steps}`);
	
  // here you can open files, and then do additional processing or generate the array with data dynamically
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.log(f);
  return f; // f must be an array[]
});

export const options = {
	
  scenarios: {
    /*verifyPaymentNotice: {
      executor: 'ramping-vus',
      startTime: '2s', // the ramping API test starts a little later
      //startRate: 0,
      //timeUnit: '1s', // we start at 50 iterations per second
      stages: [
        { target: 1, duration: '1s' }, // go from 50 to 200 iters/s in the first 30 seconds
        { target: 1, duration: '1s' }, // hold at 200 iters/s for 3.5 minutes
        { target: 0, duration: '1s' }, // ramp down back to 0 iters/s over the last 30 second
      ],
      //preAllocatedVUs: 10, // the size of the VU (i.e. worker) pool for this scenario
      tags: { test_type: 'api' }, // different extra metric tags for this scenario
      env: { MY_CROC_ID: '1' }, // and we can specify extra environment variables as well!
	  exec: 'total', // this scenario is executing different code than the one above!
    },
    activatePaymentNotice: {
      executor: 'ramping-vus',
      startTime: '2s', // the ramping API test starts a little later
      //startRate: 0,
      //timeUnit: '1s', // we start at 50 iterations per second
      stages: [
        { target: 1, duration: '1s' }, // go from 50 to 200 iters/s in the first 30 seconds
        { target: 1, duration: '1s' }, // hold at 200 iters/s for 3.5 minutes
        { target: 0, duration: '1s' }, // ramp down back to 0 iters/s over the last 30 second
      ],
      //preAllocatedVUs: 20, // how large the initial pool of VUs would be
      //maxVUs: 20, // if the preAllocatedVUs are not enough, we can initialize more
      tags: { test_type: 'verifyPaymentNotice' }, // different extra metric tags for this scenario
      env: { MY_CROC_ID: '2' }, // same function, different environment variables
      exec: 'total', // same function as the scenario above, but with different env vars
	 
    },*/
	total: {
      executor: 'ramping-vus',
      //startTime: '2s', // the ramping API test starts a little later
      stages: [
	  { target: 1, duration: '5s' },
       /* { target: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_1+'s' }, // go from 50 to 200 iters/s in the first 30 seconds
        { target: getScalini[0].Scalino_CT_2, duration: getScalini[0].Scalino_CT_TIME_2+'s' }, // hold at 200 iters/s for 3.5 minutes
        { target: getScalini[0].Scalino_CT_3, duration: getScalini[0].Scalino_CT_TIME_3+'s' }, 
		{ target: getScalini[0].Scalino_CT_4, duration: getScalini[0].Scalino_CT_TIME_4+'s' }, 
        { target: getScalini[0].Scalino_CT_5, duration: getScalini[0].Scalino_CT_TIME_5+'s' }, 
        { target: getScalini[0].Scalino_CT_6, duration: getScalini[0].Scalino_CT_TIME_6+'s' },
		{ target: getScalini[0].Scalino_CT_7, duration: getScalini[0].Scalino_CT_TIME_7+'s' }, 
		{ target: getScalini[0].Scalino_CT_8, duration: getScalini[0].Scalino_CT_TIME_8+'s' }, 
        { target: getScalini[0].Scalino_CT_9, duration: getScalini[0].Scalino_CT_TIME_9+'s' }, 
        { target: getScalini[0].Scalino_CT_10, duration: getScalini[0].Scalino_CT_TIME_10+'s' },*/
       ],
      tags: { test_type: 'ALL' }, // different extra metric tags for this scenario
      exec: 'total', // this scenario is executing different code than the one above!
    }
	
  },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'count'],
  discardResponseBodies: false,
  thresholds: {
    // we can set different thresholds for the different scenarios because
    // of the extra metric tags we set!
    'http_req_duration{verifyPaymentNotice:http_req_duration}': [],
    // we can reference the scenario names as well
    'http_req_duration{activatePaymentNotice:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	//'checks{webtest:ok_rate}': ['rate>0.85'],
	'checks{verifyPaymentNotice:over_sla300}': ['rate<0.50'],
	'checks{verifyPaymentNotice:over_sla400}': ['rate<0.45'],
	'checks{verifyPaymentNotice:over_sla500}': ['rate<0.40'],
	'checks{verifyPaymentNotice:over_sla600}': ['rate<0.30'],
	'checks{verifyPaymentNotice:over_sla800}': ['rate<0.10'],
	'checks{verifyPaymentNotice:over_sla1000}': ['rate<0.05'],
	'checks{verifyPaymentNotice:ok_rate}': [],
	'checks{verifyPaymentNotice:ko_rate}': [],
	'checks{activatePaymentNotice:over_sla300}': [],
	'checks{activatePaymentNotice:over_sla400}': [],
	'checks{activatePaymentNotice:over_sla500}': [],
	'checks{activatePaymentNotice:over_sla600}': [],
	'checks{activatePaymentNotice:over_sla800}': [],
	'checks{activatePaymentNotice:over_sla1000}': [],
	'checks{activatePaymentNotice:ok_rate}': [],
	'checks{activatePaymentNotice:ko_rate}': [],
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


/*export function verifyReqBody(psp, intpsp, chpsp, chpsp_c, cfpa, noticeNmbr){
return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
<soapenv:Header/>
<soapenv:Body>
<nod:verifyPaymentNoticeReq>
<idPSP>${psp}</idPSP>
<idBrokerPSP>${intpsp}</idBrokerPSP>
<idChannel>${chpsp}</idChannel>
<password>pwdpwdpwd</password>
<qrCode>
<fiscalCode>${cfpa}</fiscalCode>
<noticeNumber>${noticeNmbr}</noticeNumber>
</qrCode>
</nod:verifyPaymentNoticeReq>
</soapenv:Body>
</soapenv:Envelope>
`
};

export function verifyPaymentNotice(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey) {
 //console.log("VERIFY="+noticeNmbr);
 
 const res = http.post(
    baseUrl+'/nodo/node-for-psp/v1?soapAction=verifyPaymentNotice',
    verifyReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPsp.CHPSP_C, rndAnagPa.CF , noticeNmbr),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { verifyPaymentNotice: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
   check(res, {
 	'verifyPaymentNotice:sla300': (r) => r.timings.duration <300,
   },
   { verifyPaymentNotice: 'sla300' }
   );
   
   check(res, {
 	'verifyPaymentNotice:sla500 ': (r) => r.timings.duration <500,
   },
   { verifyPaymentNotice: 'sla500' }
   );
   
   
   check(
    res,
    {
      'verifyPaymentNotice:ok_rate': (r) => r.status == 200,
    },
    { verifyPaymentNotice: 'ok_rate' }
	);
  // no need for sleep() here, the iteration pacing will be controlled by the
  // arrival-rate executors above!
  check(
    res,
    {
      'verifyPaymentNotice:ko_rate': (r) => r.status !== 200,
    },
    { verifyPaymentNotice: 'ko_rate' }
  );
  
  return res;
   
} 

export function activateReqBody (psp, pspint, chpsp, chpsp_c, cfpa, noticeNmbr, idempotencyKey) {
  //console.log("noticeNmbr="+noticeNmbr+" |psp="+psp+" |pspint="+pspint+" |chpsp="+chpsp+" |idempotencyKey="+idempotencyKey+" |cfpa="+cfpa);
	return `
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
<soapenv:Header/>
<soapenv:Body>
<nod:activatePaymentNoticeReq>
<idPSP>${psp}</idPSP>
<idBrokerPSP>${pspint}</idBrokerPSP>
<idChannel>${pspint}</idChannel>
<password>pwdpwdpwd</password>
<idempotencyKey>${idempotencyKey}</idempotencyKey>
<qrCode>
<fiscalCode>${cfpa}</fiscalCode>
<noticeNumber>${noticeNmbr}</noticeNumber>
</qrCode>
<expirationTime>60000</expirationTime>
<amount>10.00</amount>
<paymentNote>responseFull</paymentNote>
</nod:activatePaymentNoticeReq>
</soapenv:Body>
</soapenv:Envelope>`};

export function activatePaymentNotice(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey) {
 
 let res=http.post(baseUrl+'/nodo/node-for-psp/v1?soapAction=activatePaymentNotice',
    activateReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPsp.CHPSP_C, rndAnagPa.CF , noticeNmbr, idempotencyKey),
    { headers: { 'Content-Type': 'text/xml' } ,
	tags: { activatePaymentNotice: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  //console.log(res);
   check(res, {
 	'activatePaymentNotice:sla300': (r) => r.timings.duration <300,
   },
   { activatePaymentNotice: 'sla300' }
   );
      
   check(res, {
 	'activatePaymentNotice:sla500': (r) => r.timings.duration <500,
   },
   { activatePaymentNotice: 'sla500' }
   );
   
   
   check(
    res,
    {
      'activatePaymentNotice:ok_rate': (r) => r.status == 200,
    },
    { activatePaymentNotice: 'ok_rate' }
	);
	
	 check(
    res,
    {
      'activatePaymentNotice:ko_rate': (r) => r.status !== 200,
    },
    { activatePaymentNotice: 'ko_rate' }
  );
  // no need for sleep() here, the iteration pacing will be controlled by the
  // arrival-rate executors above!
  
     return res;
}

*/

export function total() {

  let baseUrl = "";
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
      
        // console.log(urls[key].BASEURL);
		baseUrl = urls[key].BASEURL;
      }
  }
  
  //console.log("stages="+getScalini[0].Scalino_CT_1);
  let rndAnagPsp = csvAnagPsp[Math.floor(Math.random() * csvAnagPsp.length)];
  let rndAnagPa = csvAnagPa[Math.floor(Math.random() * csvAnagPa.length)];
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
  
  let res = verifyPaymentNotice(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey);
 /*if(id=='1'){
	res=verifyPaymentNotice(rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey);
 }else if(id=='2'){
	res=activatePaymentNotice(rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey);
 }*/
 //let res=http.get(${__ENV.URL});
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
   
  var doc = parseHTML(res.body);
  var script = doc.find('outcome');
  var outcome = script.text();
  
   check(
    res,
    {
     // 'ALL OK status': (r) => r.status == 200,
	  'ALL OK status': (r) => outcome == 'OK',
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
  
   	 res = activatePaymentNotice(baseUrl,rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey);
	 
 /*if(id=='1'){
	res=verifyPaymentNotice(rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey);
 }else if(id=='2'){
	res=activatePaymentNotice(rndAnagPsp,rndAnagPa,noticeNmbr,idempotencyKey);
 }*/
 //let res=http.get(${__ENV.URL});
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
   
   doc = parseHTML(res.body);
   script = doc.find('outcome');
   outcome = script.text();
   
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
    './scenarios/CT/test/output/summary.json': JSON.stringify(data), // and a JSON with all the details...
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	'./scenarios/CT/test/output/summary.csv': csv[0],
	'./scenarios/CT/test/output/trOverSla.csv': csv[1],
	'./scenarios/CT/test/output/resultCodeSummary.csv': csv[2],
	//'./xrayJunit.xml': generateXrayJUnitXML(data, 'summary.json', encoding.b64encode(JSON.stringify(data))),
    // And any other JS transformation of the data you can think of,
    // you can write your own JS helpers to transform the summary data however you like!
	
  };
  
}
