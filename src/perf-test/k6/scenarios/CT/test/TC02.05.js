import { check } from 'k6';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from './util/papaparse.js';
import { activatePaymentNotice } from './api/activatePaymentNotice.js';
import { activatePaymentNotice_IDMP } from './api/activatePaymentNotice_IDMP.js';
import { verifyPaymentNotice } from './api/verifyPaymentNotice.js';
import { Verifica } from './api/Verifica.js';
import { Attiva } from './api/Attiva.js';
import { RPT } from './api/RPT_Semplice.js';
import { RT } from './api/RT.js';
import { RPT_Carrello_1 } from './api/RPT_Carrello_1.js';
import { RPT_Carrello_5 } from './api/RPT_Carrello_5.js';
import { RPT_Semplice_N3 } from './api/RPT_Semplice_N3.js';
import { sendPaymentOutcome } from './api/sendPaymentOutcome.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';
import * as iuvUtil from './util/iuv_util.js';


var amountGlobal = undefined;

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

export const getScalini = new SharedArray('scalini', function () {
	
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  
  return f; 
});

export const options = {
	
  scenarios: {
      	total: {
          timeUnit: '4.5s', //la media è 4,5 --> 10% da 8, 12.5% da 5, 77.5% da 4
          preAllocatedVUs: 1, // how large the initial pool of VUs would be
          executor: 'ramping-arrival-rate',
          //executor: 'ramping-vus',
          maxVUs: 1500,
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
          tags: { test_type: 'ALL', scenarioName: 'TC02.05' },
          exec: 'total',
        }

      },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'p(99)', 'p(99.99)', 'p(100)', 'count'],
  discardResponseBodies: false,
  thresholds: {
	'http_req_duration{activatePaymentNotice:http_req_duration}': [],
	'http_req_duration{activatePaymentNotice_IDMP:http_req_duration}': [],
	'http_req_duration{verifyPaymentNotice:http_req_duration}': [],
	'http_req_duration{sendPaymentOutcome:http_req_duration}': [],
	'http_req_duration{Verifica:http_req_duration}': [],
	'http_req_duration{Attiva:http_req_duration}': [],
	'http_req_duration{RT:http_req_duration}': [],
	'http_req_duration{RPT_Semplice:http_req_duration}': [],
	'http_req_duration{RPT_Carrello_1:http_req_duration}': [],
	'http_req_duration{RPT_Carrello_5:http_req_duration}': [],
	'http_req_duration{RPT_Semplice_N3:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	'checks{sendPaymentOutcome:over_sla300}': ['rate<0.50'],
	'checks{sendPaymentOutcome:over_sla400}': ['rate<0.45'],
	'checks{sendPaymentOutcome:over_sla500}': ['rate<0.40'],
	'checks{sendPaymentOutcome:over_sla600}': ['rate<0.30'],
	'checks{sendPaymentOutcome:over_sla800}': ['rate<0.10'],
	'checks{sendPaymentOutcome:over_sla1000}': ['rate<0.05'],
	'checks{sendPaymentOutcome:ok_rate}': [],
	'checks{sendPaymentOutcome:ko_rate}': [],
	'checks{Verifica:over_sla300}': [],
	'checks{Verifica:over_sla400}': [],
	'checks{Verifica:over_sla500}': [],
	'checks{Verifica:over_sla600}': [],
	'checks{Verifica:over_sla800}': [],
	'checks{Verifica:over_sla1000}': [],
	'checks{Verifica:ok_rate}': [],
	'checks{Verifica:ko_rate}': [],
	'checks{Attiva:over_sla300}': [],
	'checks{Attiva:over_sla400}': [],
	'checks{Attiva:over_sla500}': [],
	'checks{Attiva:over_sla600}': [],
	'checks{Attiva:over_sla800}': [],
	'checks{Attiva:over_sla1000}': [],
	'checks{Attiva:ok_rate}': [],
	'checks{Attiva:ko_rate}': [],
	'checks{activatePaymentNotice_IDMP:over_sla300}': [],
	'checks{activatePaymentNotice_IDMP:over_sla400}': [],
	'checks{activatePaymentNotice_IDMP:over_sla500}': [],
	'checks{activatePaymentNotice_IDMP:over_sla600}': [],
	'checks{activatePaymentNotice_IDMP:over_sla800}': [],
	'checks{activatePaymentNotice_IDMP:over_sla1000}': [],
	'checks{activatePaymentNotice_IDMP:ok_rate}': [],
	'checks{activatePaymentNotice_IDMP:ko_rate}': [],
	'checks{activatePaymentNotice:over_sla300}': [],
	'checks{activatePaymentNotice:over_sla400}': [],
	'checks{activatePaymentNotice:over_sla500}': [],
	'checks{activatePaymentNotice:over_sla600}': [],
	'checks{activatePaymentNotice:over_sla800}': [],
	'checks{activatePaymentNotice:over_sla1000}': [],
	'checks{activatePaymentNotice:ok_rate}': [],
	'checks{activatePaymentNotice:ko_rate}': [],
	'checks{verifyPaymentNotice:over_sla300}': [],
	'checks{verifyPaymentNotice:over_sla400}': [],
	'checks{verifyPaymentNotice:over_sla500}': [],
	'checks{verifyPaymentNotice:over_sla600}': [],
	'checks{verifyPaymentNotice:over_sla800}': [],
	'checks{verifyPaymentNotice:over_sla1000}': [],
	'checks{verifyPaymentNotice:ok_rate}': [],
	'checks{verifyPaymentNotice:ko_rate}': [],
	'checks{RPT_Semplice:over_sla300}': [],
	'checks{RPT_Semplice:over_sla400}': [],
	'checks{RPT_Semplice:over_sla500}': [],
	'checks{RPT_Semplice:over_sla600}': [],
	'checks{RPT_Semplice:over_sla800}': [],
	'checks{RPT_Semplice:over_sla1000}': [],
	'checks{RPT_Semplice:ok_rate}': [],
	'checks{RPT_Semplice:ko_rate}': [],
	'checks{RPT_Carrello_1:over_sla300}': [],
	'checks{RPT_Carrello_1:over_sla400}': [],
	'checks{RPT_Carrello_1:over_sla500}': [],
	'checks{RPT_Carrello_1:over_sla600}': [],
	'checks{RPT_Carrello_1:over_sla800}': [],
	'checks{RPT_Carrello_1:over_sla1000}': [],
	'checks{RPT_Carrello_1:ok_rate}': [],
	'checks{RPT_Carrello_1:ko_rate}': [],
	'checks{RT:over_sla300}': [],
    'checks{RT:over_sla400}': [],
    'checks{RT:over_sla500}': [],
    'checks{RT:over_sla600}': [],
    'checks{RT:over_sla800}': [],
    'checks{RT:over_sla1000}': [],
    'checks{RT:ok_rate}': [],
    'checks{RT:ko_rate}': [],
	'checks{RPT_Carrello_5:over_sla300}': [],
	'checks{RPT_Carrello_5:over_sla400}': [],
	'checks{RPT_Carrello_5:over_sla500}': [],
	'checks{RPT_Carrello_5:over_sla600}': [],
	'checks{RPT_Carrello_5:over_sla800}': [],
	'checks{RPT_Carrello_5:over_sla1000}': [],
	'checks{RPT_Carrello_5:ok_rate}': [],
	'checks{RPT_Carrello_5:ko_rate}': [],
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


var baseUrl = "";

export function total() {

  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseUrl = urls[key].SOAP_BASEURL;
      }
  }
 
     
  execute();
  
  
}


export default function(){
	total();
}





function random(){
  //var i  = Math.floor(Math.random()*20)%11;
  var i = Math.floor(Math.random() * 3);
  if(i<=0) return random();
  return i;
}

function execute(){
  var i = random();
  eval('func'+i+'()');
}



function randomRpts(){
  var ind = Math.floor(Math.random() * 11);
  if(ind<=0) return random();
  return ind;
}

function executeRpts(){
  var ind = randomRpts();
  eval('rpt'+ind+'()');
}

function randomIdp(){
  var idx  = Math.floor( Math.random() * 5 );
    if(idx<=0) return randomIdp();
  return idx;
}

function executeIdp(){
  var idx = randomIdp();
  eval('idp'+idx+'()');
}



function randomOro(){
  var ido  = Math.floor( Math.random() * 3 );
  if(ido<=0) return randomOro();
  return ido;
}


function executeOro(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId){
  var ido = randomOro();
  var args = "'"+rndAnagPsp.PSP+"','"+ rndAnagPsp.INTPSP+"','"+ rndAnagPsp.CHPSP+"','"
  + rndAnagPaNew.PA+"','"+ rndAnagPaNew.INTPA+"','"+ rndAnagPaNew.STAZPA+"','" +paymentToken+"','" +creditorReferenceId +"'"; //
  //console.debug("executeOro+=oro"+ido+"("+args+")");
  console.debug("@@@@@EXECUTE ORO ARGS "+ args);
  console.debug("@@@@@EXECUTE ORO creditorReferenceId "+ creditorReferenceId);
  console.debug("@@@@@EXECUTE ORO paymentToken "+ paymentToken);
  eval("oro"+ido+"("+args+")");
}





function func1() {
   //console.debug("func1");
   verificaAttiva();
   executeRpts(); 
}

function func2() {
   //console.debug("func2");
   executeIdp();
  
}




function rpt1() {
    rpt5();
}
function rpt2() {
    rpt5();
}
function rpt3() {
    rpt1();
}
function rpt4() {
    rpt1();
}
function rpt5() {
    rpt1();
}
function rpt6() {
    rptSemplice();
}
function rpt7() {
    rptSemplice();
}
function rpt8() {
    rptSemplice();
}
function rpt9() {
    rptSemplice();
}
function rpt10() {
    rptSemplice();
}


function idp1() {
    verifyAndActivate();
}
function idp2() {
    verifyAndActivate();
}
function idp3() {
    verifyAndActivate();
}
function idp4() {
    verifyAndActivateIdp();
}


function oro1(psp, intpsp, chpsp, pa, intpa, stazpa, paymentToken, creditorReferenceId) {
	
	let rndAnagPsp = new Object();
	let rndAnagPaNew = new Object();
	rndAnagPsp.PSP=psp;
	rndAnagPsp.INTPSP=intpsp;
	rndAnagPsp.CHPSP=chpsp;
	rndAnagPaNew.PA=pa;
	rndAnagPaNew.INTPA=intpa;
	rndAnagPaNew.STAZPA=stazpa;
    OR(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId);
}
function oro2(psp, intpsp, chpsp, pa, intpa, stazpa,paymentToken, creditorReferenceId) {
	let rndAnagPsp = new Object();
	let rndAnagPaNew = new Object();
	rndAnagPsp.PSP=psp;
	rndAnagPsp.INTPSP=intpsp;
	rndAnagPsp.CHPSP=chpsp;
	rndAnagPaNew.PA=pa;
	rndAnagPaNew.INTPA=intpa;
	rndAnagPaNew.STAZPA=stazpa;
    RO(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId);
}







function verifyAndActivate(){
	
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = common.genIdempotencyKey();


  let res = verifyPaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);

	
  res = activatePaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  let paymentToken=res.paymentToken;
  let creditorReferenceId=res.creditorReferenceId;
	amountGlobal = res.amount;
	
  executeOro(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId);
}



function verifyAndActivateIdp(){
	
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = common.genIdempotencyKey();


  let res = verifyPaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);

  let paymentToken=res.paymentToken;
  let creditorReferenceId=res.creditorReferenceId;


  res = activatePaymentNotice_IDMP(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  amountGlobal = res.amount;
  creditorReferenceId=res.creditorReferenceId;
	console.debug("### verifyAndActivateIdp "+ creditorReferenceId);		

  executeOro(rndAnagPsp, rndAnagPaNew, res.paymentToken, creditorReferenceId);
}
	







function verificaAttiva() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
    let iuv = iuvUtil.genIuv();


 	let res = Verifica(baseUrl,rndAnagPsp,rndAnagPa,iuv,1,'OK');

 
    res = Attiva(baseUrl,rndAnagPsp,rndAnagPa,iuv, "PERFORMANCE");

}



export function rptSemplice() {
	
	let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
	let iuv = iuvUtil.genIuvSemplice();


	let importoSingoloVersamento = "10.00";
    let res = RPT(baseUrl,rndAnagPsp,rndAnagPa,iuv, importoSingoloVersamento);

	res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuv);
 
}

export function rpt1() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
 	let iuvArray = iuvUtil.genIuvArray(1);



	let res = RPT_Carrello_1(baseUrl,rndAnagPsp,rndAnagPa,iuvArray);

    res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[0]);
 
}

export function rpt5() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
    let iuvArray = iuvUtil.genIuvArray(5);
	//console.debug("iuvArray=="+iuvArray);


 	let res = RPT_Carrello_5(baseUrl,rndAnagPsp,rndAnagPa,iuvArray);


     res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[0]);
     res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[1]);
     res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[2]);
     res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[3]);
     res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[4]);
 
}



export function OR(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId) {

   //console.debug("OR+"+rndAnagPsp.PSP);
 	let res = sendPaymentOutcome(baseUrl,rndAnagPsp,paymentToken);


	res =  RPT_Semplice_N3(baseUrl,rndAnagPaNew,paymentToken, creditorReferenceId, amountGlobal);

}



export function RO(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId) {

   	
    let res =  RPT_Semplice_N3(baseUrl,rndAnagPaNew,paymentToken, creditorReferenceId, amountGlobal);


	res = sendPaymentOutcome(baseUrl,rndAnagPsp,paymentToken);

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
