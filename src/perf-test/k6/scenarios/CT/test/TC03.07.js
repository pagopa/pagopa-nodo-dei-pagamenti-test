import { check } from 'k6';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
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
import { sendPaymentOutput } from './api/sendPaymentOutput.js';
import { sendPaymentOutput_NN } from './api/sendPaymentOutput_NN.js';
import { activatePaymentNotice_NN } from './api/activatePaymentNotice_NN.js';
import { activatePaymentNoticeIdp_NN } from './api/activatePaymentNoticeIdp_NN.js';
import { verifyPaymentNotice_NN } from './api/verifyPaymentNotice_NN.js';
import { demandPaymentNotice_NN } from './api/demandPaymentNotice_NN.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';
import * as iuvUtil from './util/iuv_util.js';
//import * as test_selector from '../../test_selector.js';



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
	
  // here you can open files, and then do additional processing or generate the array with data dynamically
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.debug(f);
  return f; // f must be an array[]
});

export const options = {
	
  scenarios: {
      	total: {
          timeUnit: '4s',  //56% 4 + 10% 5 + 30% 3 + 4% 8 --> media 3,96 --> 4
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
	'http_req_duration{activatePaymentNotice:http_req_duration}': [],
	'http_req_duration{activatePaymentNotice_IDMP:http_req_duration}': [],
	'http_req_duration{verifyPaymentNotice:http_req_duration}': [],
    'http_req_duration{sendPaymentOutcome_NN:http_req_duration}': [],
    'http_req_duration{activatePaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{activatePaymentNoticeIdp_NN:http_req_duration}': [],
	'http_req_duration{verifyPaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{demandPaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{sendPaymentOutcome:http_req_duration}': [],
	'http_req_duration{Verifica:http_req_duration}': [],
	'http_req_duration{Attiva:http_req_duration}': [],
	'http_req_duration{RPT_Semplice:http_req_duration}': [],
	'http_req_duration{RT_Semplice:http_req_duration}': [],
	'http_req_duration{RPT_Carrello_1:http_req_duration}': [],
	'http_req_duration{RPT_Carrello_5:http_req_duration}': [],
	'http_req_duration{RPT_Semplice_N3:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	'checks{sendPaymentOutcome:over_sla300}': [],
	'checks{sendPaymentOutcome:over_sla400}': [],
	'checks{sendPaymentOutcome:over_sla500}': [],
	'checks{sendPaymentOutcome:over_sla600}': [],
	'checks{sendPaymentOutcome:over_sla800}': [],
	'checks{sendPaymentOutcome:over_sla1000}': [],
	'checks{sendPaymentOutcome:ok_rate}': [],
	'checks{sendPaymentOutcome:ko_rate}': [],
	'checks{sendPaymentOutcome_NN:over_sla300}': [],
	'checks{sendPaymentOutcome_NN:over_sla400}': [],
	'checks{sendPaymentOutcome_NN:over_sla500}': [],
	'checks{sendPaymentOutcome_NN:over_sla600}': [],
	'checks{sendPaymentOutcome_NN:over_sla800}': [],
	'checks{sendPaymentOutcome_NN:over_sla1000}': [],
	'checks{sendPaymentOutcome_NN:ok_rate}': [],
	'checks{sendPaymentOutcome_NN:ko_rate}': [],
	'checks{demandPaymentNotice_NN:over_sla300}': [],
    'checks{demandPaymentNotice_NN:over_sla400}': [],
    'checks{demandPaymentNotice_NN:over_sla500}': [],
    'checks{demandPaymentNotice_NN:over_sla600}': [],
    'checks{demandPaymentNotice_NN:over_sla800}': [],
    'checks{demandPaymentNotice_NN:over_sla1000}': [],
    'checks{demandPaymentNotice_NN:ok_rate}': [],
    'checks{demandPaymentNotice_NN:ko_rate}': [],
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
	'checks{RT:over_sla300}': [],
    'checks{RT:over_sla400}': [],
    'checks{RT:over_sla500}': [],
    'checks{RT:over_sla600}': [],
    'checks{RT:over_sla800}': [],
    'checks{RT:over_sla1000}': [],
    'checks{RT:ok_rate}': [],
    'checks{RT:ko_rate}': [],
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
var rndAnagPspGlobal = undefined;
var rndAnagPaNewGlobal = undefined;
var noticeNmbrGlobal = undefined;
var paymentNoteGlobal = undefined;
var paymentTokenGlobal = undefined;
var creditorReferenceIdGlobal = undefined;
var amountGlobal = undefined;

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
  rndAnagPspGlobal = rndAnagPsp;
  rndAnagPaNewGlobal = rndAnagPaNew;
  noticeNmbrGlobal = noticeNmbr;
  paymentNoteGlobal = paymentNote;
  return eval('idp_NN'+idx_NN+'()');
}


function randomOro(){
  var ido  = Math.floor( Math.random() * 3 );
  if(ido<=0) return randomOro();
  return ido;
}


function executeOro(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId, amount){
	console.debug("executeOro creditorReferenceId "+ creditorReferenceId);
  var ido = randomOro();
  rndAnagPspGlobal = rndAnagPsp;
  rndAnagPaNewGlobal = rndAnagPaNew;
  paymentTokenGlobal = paymentToken;
  creditorReferenceIdGlobal = creditorReferenceId;
  amountGlobal = amount;
  eval('oro'+ido+'()');
}


function randomTransf(){
  var indice  = Math.floor( Math.random() * 6 );
  if(indice<=0) return randomTransf();
  return indice;
}


function randomMod(){
  var indice  = Math.floor( Math.random() * 6 );
  if(indice<=0) return randomMod();
  return indice;
}


function executeTransf(){  //MOD 3
  var indice = randomTransf();
  eval('transf'+indice+'()');
}

function executeTransfMod4(){  //MOD 4
  var indice = randomTransf();
  eval('transfMod4'+indice+'()');
}


function executeMod(){
  var indice = randomMod();
  eval('mod'+indice+'()');
}




function func1() {
   //console.debug("func1");
   verificaAttiva();
   executeRpts(); 
}
function func2() {
   //console.debug("func2");
   verificaAttiva();
   executeRpts(); 
}
function func3() {
    //console.debug("func3");
	executeIdp();
	//executeOro();
}
function func4() {
   //console.debug("func4");
   executeIdp();
  // executeOro();
}
function func5() {
  //console.debug("func5");
  executeIdp();
  //executeOro();
}
function func6() {
    //console.debug("func6");
   executeIdp();
   //executeOro();
}
function func7() {
    //console.debug("func7");
   executeMod();// executeTransf();
}
function func8() {
   //console.debug("func8");
   executeMod();//executeTransf();
}
function func9() {
   //console.debug("func9");
   executeMod();//executeTransf();
}
function func10() {
    //console.debug("func10");
	executeMod();//executeTransf();
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
    OR(rndAnagPspGlobal, rndAnagPaNewGlobal, paymentTokenGlobal, creditorReferenceIdGlobal);
}
function oro2(rndAnagPsp, rndAnagPaNew,paymentToken, creditorReferenceId) {
    RO(rndAnagPspGlobal, rndAnagPaNewGlobal, paymentTokenGlobal, creditorReferenceIdGlobal);
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



function transfMod41() {
   sd2TransfMod4();
}
function transfMod42() {
   sd2TransfMod4();
}
function transfMod43() {
   sd2TransfMod4();
}
function transfMod44() {
   sd2TransfMod4();
}
function transfMod45() {
   sd5TransfMod4();
}



function mod1() {
   modello3();
}
function mod2() {
   modello3();
}
function mod3() {
   modello3();
}
function mod4() {
   modello3();
}
function mod5() {
   modello4();
}





function modello3(){
executeTransf();
}

function modello4(){
executeTransfMod4();
}



function idp_NN1(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	return rndActivatePaymentNotice(rndAnagPspGlobal, rndAnagPaNewGlobal, noticeNmbrGlobal);
}
function idp_NN2(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	return rndActivatePaymentNotice(rndAnagPspGlobal, rndAnagPaNewGlobal, noticeNmbrGlobal);
}
function idp_NN3(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	return rndActivatePaymentNotice(rndAnagPspGlobal, rndAnagPaNewGlobal, noticeNmbrGlobal);
}
function idp_NN4(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	return rndActivatePaymentNoticeIdp(rndAnagPspGlobal, rndAnagPaNewGlobal, noticeNmbrGlobal);
}





function verifyAndActivate(){
	
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();


  let res = verifyPaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);


  res = activatePaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  let paymentToken=res.paymentToken;
  console.debug("verifyAndActivate paymentToken "+ paymentToken);
  let creditorReferenceId=res.creditorReferenceId;

	console.debug("verifyAndActivate calling executeOro with creditorReferenceId = "+ creditorReferenceId);
  executeOro(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId, res.amount);
}



function verifyAndActivateIdp(){
	
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = common.genIdempotencyKey();


  let res = verifyPaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);

	
  //res = activatePaymentNotice(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);


  res = activatePaymentNotice_IDMP(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  let paymentToken = res.paymentToken;
  console.debug("verifyAndActivateIdp paymentToken "+ paymentToken);
  paymentTokenGlobal = paymentToken;
  let creditorReferenceId=res.creditorReferenceId;

	console.debug("verifyAverifyAndActivateIdp calling executeOro with creditorReferenceId = "+ creditorReferenceId);
  executeOro(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId, res.amount);
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


    let res = RPT(baseUrl,rndAnagPsp,rndAnagPa,iuv);


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
	console.debug("###OR PSP " + JSON.stringify(rndAnagPsp));
	console.debug("###OR PA " + JSON.stringify(rndAnagPaNew));
	console.debug("##OR AMOUNT "+ amountGlobal);
   	console.debug("##OR paymentToken "+ paymentToken);
	console.debug("##OR AMOUNT "+ amountGlobal);
	console.debug("##OR creditorReferenceId "+ creditorReferenceId);
 	let res = sendPaymentOutput(baseUrl,rndAnagPsp,paymentToken);

	res =  RPT_Semplice_N3(baseUrl,rndAnagPaNew, paymentToken, creditorReferenceId, amountGlobal);

}


export function RO(rndAnagPsp, rndAnagPaNew, paymentToken, creditorReferenceId) {
	console.debug("###RO PSP " + JSON.stringify(rndAnagPsp));
	console.debug("###RO PA " + JSON.stringify(rndAnagPaNew));
   	console.debug("##RO AMOUNT "+ amountGlobal);
   	console.debug("##RO paymentToken "+ paymentToken);
   	console.debug("##RO creditorReferenceId "+ creditorReferenceId);
    let res =  RPT_Semplice_N3(baseUrl,rndAnagPaNew, paymentToken, creditorReferenceId, amountGlobal);

	res = sendPaymentOutput(baseUrl,rndAnagPsp,paymentToken);

}



function sd2Transf(){
	
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
    
   
  let res =  verifyPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);


  let paymentToken = executeIdp_NN(rndAnagPsp, rndAnagPaNew, noticeNmbr, 2);
  paymentTokenGlobal = paymentToken;
  console.debug("sd2Transf paymentToken "+ paymentToken);
  res = sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken);

}



function sd2TransfMod4(){

  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();


  let res =  demandPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  noticeNmbr = res.noticeNmbr;


  let paymentToken = executeIdp_NN(rndAnagPsp, rndAnagPaNew, noticeNmbr, 2);
	console.debug("sd2TransfMod4 paymentToken "+ paymentToken);
	paymentTokenGlobal = paymentToken;
  res = sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken);

}





function sd5Transf(){
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();
    
   
  let res =  verifyPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);

  
  let paymentToken = executeIdp_NN(rndAnagPsp, rndAnagPaNew, noticeNmbr, 5);
  console.debug("sd5Transf paymentToken"+ paymentToken);
  paymentTokenGlobal = paymentToken;
  res = sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken);

}


function sd5TransfMod4(){
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let noticeNmbr = genNoticeNumber();
  let idempotencyKey = genIdempotencyKey();


  let res =  demandPaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
  noticeNmbr = res.noticeNmbr;


  let paymentToken = executeIdp_NN(rndAnagPsp, rndAnagPaNew, noticeNmbr, 5);
	console.debug("sd5TransfMod4 paymentToken"+ paymentToken);
	paymentTokenGlobal = paymentToken;
  res = sendPaymentOutput_NN(baseUrl,rndAnagPsp,paymentToken);

}




function rndActivatePaymentNotice(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	
  let idempotencyKey = genIdempotencyKey();
  
  let res = activatePaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey, paymentNote);
  let paymentToken=res.paymentToken;
	console.debug("rndActivatePaymentNotice paymentToken "+ paymentToken);
	paymentTokenGlobal = paymentToken;
  return paymentToken;
}



function rndActivatePaymentNoticeIdp(rndAnagPsp, rndAnagPaNew, noticeNmbr, paymentNote){
	
  let idempotencyKey = genIdempotencyKey();
  if(rndAnagPaNew == undefined){
	rndAnagPaNew = inputDataUtil.getAnagPaNew();
  }
  
  let res = activatePaymentNotice_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey, paymentNote);


  res = activatePaymentNoticeIdp_NN(baseUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey, paymentNote);
  let paymentToken=res.paymentToken;
	console.debug("rndActivatePaymentNoticeIdp paymentToken "+ paymentToken);
	paymentTokenGlobal = paymentToken;
  return paymentToken;
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
