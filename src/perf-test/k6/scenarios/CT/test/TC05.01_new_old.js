import { check } from 'k6';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { chiediInformazioniPagamento } from './api/chiediInformazioniPagamento.js';
import { closePayment } from './api/closePaymentV2.js';
import { Attiva } from './api/Attiva.js';
import { RPT } from './api/RPT.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';
import * as iuvUtil from './util/iuv_util.js';



const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;
  
});


const chars = '0123456789';
// NoticeNumber
export function genNoticeNumber(){
	let noticeNumber='111';
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
	
 
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));

  return f; 
});

export const options = {
	
  scenarios: {
      	total: {
          timeUnit: '4s',
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
    
    'http_req_duration{chiediInformazioniPagamento:http_req_duration}': [],
	'http_req_duration{closePayment:http_req_duration}': [],
	'http_req_duration{sendPaymentOutcome:http_req_duration}': [],
    'http_req_duration{Attiva:http_req_duration}': [],
	'http_req_duration{RPT:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	'checks{chiediInformazioniPagamento:over_sla300}': [],
	'checks{chiediInformazioniPagamento:over_sla400}': [],
	'checks{chiediInformazioniPagamento:over_sla500}': [],
	'checks{chiediInformazioniPagamento:over_sla600}': [],
	'checks{chiediInformazioniPagamento:over_sla800}': [],
	'checks{chiediInformazioniPagamento:over_sla1000}': [],
	'checks{chiediInformazioniPagamento:ok_rate}': [],
	'checks{chiediInformazioniPagamento:ko_rate}': [],
	'checks{closePayment:over_sla300}': [],
	'checks{closePayment:over_sla400}': [],
	'checks{closePayment:over_sla500}': [],
	'checks{closePayment:over_sla600}': [],
	'checks{closePayment:over_sla800}': [],
	'checks{closePayment:over_sla1000}': [],
	'checks{closePayment:ok_rate}': [],
	'checks{closePayment:ko_rate}': [],
	'checks{sendPaymentOutcome:over_sla300}': [],
	'checks{sendPaymentOutcome:over_sla400}': [],
	'checks{sendPaymentOutcome:over_sla500}': [],
	'checks{sendPaymentOutcome:over_sla600}': [],
	'checks{sendPaymentOutcome:over_sla800}': [],
	'checks{sendPaymentOutcome:over_sla1000}': [],
	'checks{sendPaymentOutcome:ok_rate}': [],
	'checks{sendPaymentOutcome:ko_rate}': [],
	'checks{Attiva:over_sla300}': [],
	'checks{Attiva:over_sla400}': [],
	'checks{Attiva:over_sla500}': [],
	'checks{Attiva:over_sla600}': [],
	'checks{Attiva:over_sla800}': [],
	'checks{Attiva:over_sla1000}': [],
	'checks{Attiva:ok_rate}': [],
	'checks{Attiva:ko_rate}': [],
	'checks{RPT:over_sla300}': [],
	'checks{RPT:over_sla400}': [],
	'checks{RPT:over_sla500}': [],
	'checks{RPT:over_sla600}': [],
	'checks{RPT:over_sla800}': [],
	'checks{RPT:over_sla1000}': [],
	'checks{RPT:ok_rate}': [],
	'checks{RPT:ko_rate}': [],
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




function create_UUID(){
    var dt = new Date().getTime();
    var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = (dt + Math.random()*16)%16 | 0;
        dt = Math.floor(dt/16);
        return (c=='x' ? r :(r&0x3|0x8)).toString(16);
    });
    return uuid;
}


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
 
  let rndAnagPsp = inputDataUtil.getAnagPspV1();
  let rndAnagPaNew = inputDataUtil.getAnagPa();

  let iuv = iuvUtil.genIuv();
  let ccp = create_UUID().replace("-", "");
  
  
  const fixedRndAnagPsp = {
	  PSP: 'AGID_01',
	  CHPSP: '97735020584_03',
	  INTPSP: '97735020584'
  };
  /*
  const fixedRndAnagPsp = {
  PSP: '97735020584',
  INTPSP: '97735020584_03',
  CHPSP: '97735020584',
  };*/
  
   
  let res = Attiva(baseSoapUrl,fixedRndAnagPsp,rndAnagPaNew,iuv,ccp);



  res = RPT(baseSoapUrl,rndAnagPaNew,iuv,ccp);
  let paymentToken = res.paymentToken;
  
  
  
  res = chiediInformazioniPagamento(baseRestUrl,paymentToken, rndAnagPaNew);

  
    
  let outcome = 'OK';
  res =  closePayment(baseRestUrl,rndAnagPsp,paymentToken,outcome,"09910087308786","09910087308786",res.importoTotale);

  
  
  // res = sendPaymentOutput(baseSoapUrl,rndAnagPsp,paymentToken);

}


export default function(){
	total();
}


export function handleSummary(data) {
  console.debug('Preparing the end-of-test summary...');
 
  return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)
  
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


