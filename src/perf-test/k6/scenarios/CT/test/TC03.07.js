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
import { activatePaymentNotice } from './api/activatePaymentNotice.js';
import { activatePaymentNotice_IDMP } from './api/activatePaymentNotice_IDMP.js';
import { verifyPaymentNotice } from './api/verifyPaymentNotice.js';
import { Verifica } from './api/Verifica.js';
import { Attiva } from './api/Attiva.js';
import { RPT } from './api/RPT_Semplice.js';
import { RPT_Carrello_1 } from './api/RPT_Carrello_1.js';
import { RPT_Carrello_5 } from './api/RPT_Carrello_5.js';
import { RPT_Semplice_N3 } from './api/RPT_Semplice_N3.js';
import { sendPaymentOutput } from './api/sendPaymentOutput.js';
import { sendPaymentOutput_NN } from './api/sendPaymentOutput_NN.js';
import { activatePaymentNotice_NN } from './api/activatePaymentNotice_NN.js';
import { activatePaymentNoticeIdp_NN } from './api/activatePaymentNoticeIdp_NN.js';
import { verifyPaymentNotice_NN } from './api/verifyPaymentNotice_NN.js';
import * as outputUtil from './util/output_util.js';
import * as inputDataUtil from './util/input_data_util.js';
import * as iuvUtil from './util/iuv_util.js';
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
	'http_req_duration{activatePaymentNotice:http_req_duration}': [],
	'http_req_duration{activatePaymentNotice_IDMP:http_req_duration}': [],
	'http_req_duration{verifyPaymentNotice:http_req_duration}': [],
    'http_req_duration{sendPaymentOutcome_NN:http_req_duration}': [],
    'http_req_duration{activatePaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{activatePaymentNoticeIdp_NN:http_req_duration}': [],
	'http_req_duration{verifyPaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{sendPaymentOutcome:http_req_duration}': [],
	'http_req_duration{Verifica:http_req_duration}': [],
	'http_req_duration{Attiva:http_req_duration}': [],
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
	'checks{sendPaymentOutcome_NN:over_sla300}': ['rate<0.50'],
	'checks{sendPaymentOutcome_NN:over_sla400}': ['rate<0.45'],
	'checks{sendPaymentOutcome_NN:over_sla500}': ['rate<0.40'],
	'checks{sendPaymentOutcome_NN:over_sla600}': ['rate<0.30'],
	'checks{sendPaymentOutcome_NN:over_sla800}': ['rate<0.10'],
	'checks{sendPaymentOutcome_NN:over_sla1000}': ['rate<0.05'],
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
	'checks{activatePaymentNoticeIdp_NN:over_sla300}': [],
	'checks{activatePaymentNoticeIdp_NN:over_sla400}': [],
	'checks{activatePaymentNoticeIdp_NN:over_sla500}': [],
	'checks{activatePaymentNoticeIdp_NN:over_sla600}': [],
	'checks{activatePaymentNoticeIdp_NN:over_sla800}': [],
	'checks{activatePaymentNoticeIdp_NN:over_sla1000}': [],
	'checks{activatePaymentNoticeIdp_NN:ok_rate}': [],
	'checks{activatePaymentNoticeIdp_NN:ko_rate}': [],
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
	'checks{RPT_Carrello_5:over_sla300}': [],
	'checks{RPT_Carrello_5:over_sla400}': [],
	'checks{RPT_Carrello_5:over_sla500}': [],
	'checks{RPT_Carrello_5:over_sla600}': [],
	'checks{RPT_Carrello_5:over_sla800}': [],
	'checks{RPT_Carrello_5:over_sla1000}': [],
	'checks{RPT_Carrello_5:ok_rate}': [],
	'checks{RPT_Carrello_5:ko_rate}': [],
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
  var i = Math.floor(Math.random() * 11);
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



function randomIdp_NN(){
  var idx_NN  = Math.floor( Math.random() * 5 ); 
  
  if(idx_NN<=0) return randomIdp_NN();
  return idx_NN;
}

function executeIdp_NN(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
  var idx_NN = randomIdp();
  var args = "'"+rndAnagPsp+"','"+ rndAnagPaNew+"','"+ noticeNmbr+"','" +paymentNote +"'";
 
  return eval('idp_NN'+idx_NN+'('+args+')');
}


function randomOro(){
  var ido  = Math.floor( Math.random() * 3 );
  if(ido<=0) return randomOro();
  return ido;
}


function executeOro(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId){
  var ido = randomOro();
  var args = "'"+rndAnagPsp+"','"+ rndAnagPaNew+"','"+ paymentToken+"','" +creditorReferenceId +"'";
 
  eval('oro'+ido+'('+args+')');
}


function randomTransf(){
  var indice  = Math.floor( Math.random() * 6 );
  if(indice<=0) return randomTransf();
  return indice;
}


function executeTransf(){
  var indice = randomTransf();
  eval('transf'+indice+'()');
}




function func1() {
   //console.log("func1");
   verificaAttiva();
   executeRpts(); 
}
function func2() {
   //console.log("func2");
   verificaAttiva();
   executeRpts(); 
}
function func3() {
    //console.log("func3");
	executeIdp();
	//executeOro();
}
function func4() {
   //console.log("func4");
   executeIdp();
  // executeOro();
}
function func5() {
  //console.log("func5");
  executeIdp();
  //executeOro();
}
function func6() {
    //console.log("func6");
   executeIdp();
   //executeOro();
}
function func7() {
    //console.log("func7");
   executeTransf();
}
function func8() {
   //console.log("func8");
   executeTransf();
}
function func9() {
   //console.log("func9");
   executeTransf();
}
function func10() {
    //console.log("func10");
	executeTransf();
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


function oro1(rndAnagPsp,rndAnagPaNew, paymentToken, creditorReferenceId) {
    OR(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId);
}
function oro2(rndAnagPsp, rndAnagPaNew,paymentToken, creditorReferenceId) {
    RO(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId);
}



function transf1() {
   sd2Transf();
}
function transf2() {
   sd2Transf();
}
function transf3() {
   sd2Transf();
}
function transf4() {
   sd2Transf();
}
function transf5() {
   sd5Transf();
}



function idp_NN1(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	
	return rndActivatePaymentNotice(rndAnagPsp, rndAnagPaNew, noticeNmbr);
}
function idp_NN2(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	return rndActivatePaymentNotice(rndAnagPsp, rndAnagPaNew, noticeNmbr);
}
function idp_NN3(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	return rndActivatePaymentNotice(rndAnagPsp, rndAnagPaNew, noticeNmbr);
}
function idp_NN4(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	return rndActivatePaymentNoticeIdp(rndAnagPsp, rndAnagPaNew, noticeNmbr);
}





function verifyAndActivate(){
	
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
	
  let res = verifyPaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
	 
	let doc = parseHTML(res.body);
    let script = doc.find('esito');
    let outcome = script.text(); 
	
	checks(res, outcome, 'OK');
	
  res = activatePaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  
	doc = parseHTML(res.body);
    script = doc.find('esito');
    outcome = script.text(); 
		
	checks(res, outcome, 'OK');
	
	script = doc.find('paymentToken');
    var paymentToken = script.text();
	script = doc.find('creditorReferenceId');
    var creditorReferenceId = script.text();
	
	executeOro(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId);
}



function verifyAndActivateIdp(){
	
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
	
  let res = verifyPaymentNotice(baseUrl,rndAnagPsp,csvAnagPaNew,noticeNmbr,idempotencyKey);
	 
	let doc = parseHTML(res.body);
    let script = doc.find('esito');
    let outcome = script.text(); 
	
	checks(res, outcome, 'OK');
	
	
  res = activatePaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  
	doc = parseHTML(res.body);
    script = doc.find('esito');
    outcome = script.text(); 
		
	checks(res, outcome, 'OK');
	
		
	
	res = activatePaymentNotice_IDMP(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  
	doc = parseHTML(res.body);
    script = doc.find('esito');
    outcome = script.text(); 
		
	checks(res, outcome, 'OK');
	
	
	script = doc.find('paymentToken');
    var paymentToken = script.text();
	script = doc.find('creditorReferenceId');
    var creditorReferenceId = script.text();
		
	
	executeOro(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId);
}
	







function verificaAttiva() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
    let iuv = iuvUtil.genIuv();
	
 	let res = Verifica(baseUrl,rndAnagPsp,rndAnagPa,iuv,1);
	
    let doc = parseHTML(res.body);
    let script = doc.find('esito');
    let outcome = script.text();
    
    checks(res, outcome, 'OK');
 
 
    res = Attiva(baseUrl,rndAnagPsp,rndAnagPa,iuv, "PERFORMANCE");
	
	script = doc.find('esito');
    outcome = script.text();
	
    checks(res, outcome, 'OK');

}



export function rptSemplice() {
	
	let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
	let iuv = iuvUtil.genIuvSemplice();

    let res = RPT(baseUrl,rndAnagPsp,rndAnagPa,iuv);
	
    let doc = parseHTML(res.body);
    let script = doc.find('esito');
    let outcome = script.text();
    
    checks(res, outcome, 'OK');
 
}

export function rpt1() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
 	let iuvArray = iuvUtil.genIuvArray(1);
		
	let res = RPT_Carrello_1(baseUrl,rndAnagPsp,rndAnagPa,iuvArray);
	
    let doc = parseHTML(res.body);
    let script = doc.find('esitoComplessivoOperazione');
    let outcome = script.text();
    
    checks(res, outcome, 'OK');
 
}

export function rpt5() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
    let iuvArray = iuvUtil.genIuvArray(5);
	//console.log("iuvArray=="+iuvArray);

 	let res = RPT_Carrello_5(baseUrl,rndAnagPsp,rndAnagPa,iuvArray);
	
    let doc = parseHTML(res.body);
    let script = doc.find('esitoComplessivoOperazione');
    let outcome = script.text();
    
    checks(res, outcome, 'OK');
 
}


export function OR(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId) {

   
 	let res = sendPaymentOutput(baseUrl,rndAnagPsp,paymentToken);
	
    let doc = parseHTML(res.body);
    let script = doc.find('outcome');
    let outcome = script.text();
    
    checks(res, outcome, 'OK');
	
	res =  RPT_Semplice_N3(baseUrl,rndAnagPaNew,paymentToken, creditorReferenceId);
  
    doc = parseHTML(res.body);
    script = doc.find('esito');
    outcome = script.text();
    
    checks(res, outcome, 'OK'); 
 
}


export function RO(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId) {

   	
    let res =  RPT_Semplice_N3(baseUrl,rndAnagPaNew,paymentToken, creditorReferenceId);
  
    let doc = parseHTML(res.body);
    let script = doc.find('esito');
    let outcome = script.text();
    
    checks(res, outcome, 'OK'); 
	
	
	
	res = sendPaymentOutput(baseUrl,rndAnagPsp,paymentToken);
	
    doc = parseHTML(res.body);
    script = doc.find('outcome');
    outcome = script.text();
    
    checks(res, outcome, 'OK');
 
}



function sd2Transf(){
	
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
    
   
  let res =  verifyPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);

  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  let outcome = script.text();
    
  checks(res, outcome, 'OK');
  
  
  let paymentToken = executeIdp_NN(rndAnagPsp, rndAnagPaNew, noticeNmbr, 2);
  
    
  res = sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken);

  doc = parseHTML(res.body);
  script = doc.find('outcome');
  outcome = script.text();
    
  checks(res, outcome);
  
}


function sd5Transf(){
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
    
   
  let res =  verifyPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);

  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  let outcome = script.text();
    
  checks(res, outcome, 'OK');
  
  
  let paymentToken = executeIdp_NN(rndAnagPsp, rndAnagPaNew, noticeNmbr, 5);
  
  
  res = sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken);

  doc = parseHTML(res.body);
  script = doc.find('outcome');
  outcome = script.text();
    
  checks(res, outcome);
	
}


function rndActivatePaymentNotice(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	
  let idempotencyKey = genIdempotencyKey();
  
  let res = activatePaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey, paymentNote);
  	 
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  let outcome = script.text();
     
  checks(res, outcome);
  
  script = doc.find('paymentToken');
  var paymentToken = script.text();
  
  return paymentToken;
}



function rndActivatePaymentNoticeIdp(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	
  let idempotencyKey = genIdempotencyKey();
  
  let res = activatePaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey, paymentNote);
  	 
  let doc = parseHTML(res.body);
  let script = doc.find('outcome');
  let outcome = script.text();
     
  checks(res, outcome);
 
 
  res = activatePaymentNoticeIdp_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey, paymentNote);
  	 
  doc = parseHTML(res.body);
  script = doc.find('outcome');
  outcome = script.text();
     
  checks(res, outcome);
  
  script = doc.find('paymentToken');
  var paymentToken = script.text();
  
  return paymentToken;
}









export function handleSummary(data) {
  console.log('Preparing the end-of-test summary...');
 
  var csv = outputUtil.extractData(data);
     
   return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true, expected_response: 'ALL' }), // Show the text summary to stdout...
	//'./junit.xml': jUnit(data), // but also transform it and save it as a JUnit XML...
    './scenarios/CT/test/output/TC03.07.summary.json': JSON.stringify(data), // and a JSON with all the details...
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	'./scenarios/CT/test/output/TC03.07.summary.csv': csv[0],
	'./scenarios/CT/test/output/TC03.07.trOverSla.csv': csv[1],
	'./scenarios/CT/test/output/TC03.07.resultCodeSummary.csv': csv[2],
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
