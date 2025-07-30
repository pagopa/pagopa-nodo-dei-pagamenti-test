import { check } from 'k6';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from './util/papaparse.js';
import { Verifica } from './api/Verifica.js';
import { Attiva } from './api/Attiva.js';
import { ChiediNumeroAvviso } from './api/ChiediNumeroAvviso.js';
import { RPT } from './api/RPT_Semplice.js';
import { RT } from './api/RT.js';
import { RPT_Carrello_5 } from './api/RPT_Carrello_5.js';
import { RPT_Carrello_1 } from './api/RPT_Carrello_1.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';
//import * as test_selector from '../../test_selector.js';



const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;
  
});


const chars = '0123456789';

export function genIuv(){
	
	/*let iuv = Math.random()*100000000000000000;
	iuv = iuv.toString().split('.')[0];*/
	let iuv='';
	for (var i = 17; i > 0; --i) iuv += chars[Math.floor(Math.random() * chars.length)];
	let user ="";
	let returnValue=user+iuv;
    return returnValue;

}

export function genIuvSemplice(){
    let iuv ="P_";
	/*let user = Math.random()*10000;
	user = user.toString().split('.')[0];*/
	let user='';
	for (var i = 4; i > 0; --i) user += chars[Math.floor(Math.random() * chars.length)];
	iuv += user; 
	iuv += makeid(3);
	iuv += "_";
	var dt = new Date();
	let ms = dt.getMilliseconds();
	
	dt = dt.getFullYear() + ("0" + (dt.getMonth() + 1)).slice(-2) + ("0" + dt.getDate()).slice(-2) + 
	("0" + dt.getHours() ).slice(-2) + ("0" + dt.getMinutes()).slice(-2) + ("0" + dt.getSeconds()).slice(-2)+ ms;
		
	iuv += dt;
	
   
    return iuv;

}

function makeid(length) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * 
 charactersLength));
   }
   return result;
}


export function genIuvArray(l){
	
var iuvArray = [];
    /*let user = Math.random()*10000;
	user = user.toString().split('.')[0];*/
	let user='';
	for (var i = 4; i > 0; --i) user += chars[Math.floor(Math.random() * chars.length)];
	var dt = new Date();
	let ms = dt.getMilliseconds();
	
	dt = dt.getFullYear() + ("0" + (dt.getMonth() + 1)).slice(-2) + ("0" + dt.getDate()).slice(-2) + 
	("0" + dt.getHours() ).slice(-2) + ("0" + dt.getMinutes()).slice(-2) + ("0" + dt.getSeconds()).slice(-2)+ ms;

let iuv = "";	
//console.debug(dt+"------"+user);
for(let i = 0; i < l; i++){
  iuv = "P" + i;
  iuv += user; 
  iuv += makeid(3);
  iuv += "_";
  iuv += dt;
  iuvArray.push(iuv);

}
//console.debug("genIuvArray="+iuvArray);
//console.debug("genIuvArray1="+iuvArray[0]);
return iuvArray;

}



//const scalini= run.getScalini[0]; 

export const getScalini = new SharedArray('scalini', function () {
	
  // here you can open files, and then do additional processing or generate the array with data dynamically
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.debug(f);
  return f; // f must be an array[]
});

export const options = {
	
  scenarios: {
    	total: {
        timeUnit: '4.8s', //80% 4 + 20% 8 --> media 4,8 --> 5
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
    'http_req_duration{ChiediNumeroAvviso:http_req_duration}': [],
    // we can reference the scenario names as well
    'http_req_duration{Verifica:http_req_duration}': [],
	'http_req_duration{Attiva:http_req_duration}': [],
	'http_req_duration{RPT_Semplice:http_req_duration}': [],
	'http_req_duration{RT:http_req_duration}': [],
	'http_req_duration{RPT_Carrello_5:http_req_duration}': [],
	'http_req_duration{RPT_Carrello_1:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	//'checks{webtest:ok_rate}': ['rate>0.85'],
	'checks{ChiediNumeroAvviso:over_sla300}': [],
	'checks{ChiediNumeroAvviso:over_sla400}': [],
	'checks{ChiediNumeroAvviso:over_sla500}': [],
	'checks{ChiediNumeroAvviso:over_sla600}': [],
	'checks{ChiediNumeroAvviso:over_sla800}': [],
	'checks{ChiediNumeroAvviso:over_sla1000}': [],
	'checks{ChiediNumeroAvviso:ok_rate}': [],
	'checks{ChiediNumeroAvviso:ko_rate}': ['rate<0.01'],
	'checks{Attiva:over_sla300}': [],
	'checks{Attiva:over_sla400}': [],
	'checks{Attiva:over_sla500}': [],
	'checks{Attiva:over_sla600}': [],
	'checks{Attiva:over_sla800}': [],
	'checks{Attiva:over_sla1000}': [],
	'checks{Attiva:ok_rate}': [],
	'checks{Attiva:ko_rate}': ['rate<0.01'],
	'checks{Verifica:over_sla300}': [],
	'checks{Verifica:over_sla400}': [],
	'checks{Verifica:over_sla500}': [],
	'checks{Verifica:over_sla600}': [],
	'checks{Verifica:over_sla800}': [],
	'checks{Verifica:over_sla1000}': [],
	'checks{Verifica:ok_rate}': [],
	'checks{Verifica:ko_rate}': ['rate<0.01'],
	'checks{RPT_Semplice:over_sla300}': [],
	'checks{RPT_Semplice:over_sla400}': [],
	'checks{RPT_Semplice:over_sla500}': [],
	'checks{RPT_Semplice:over_sla600}': [],
	'checks{RPT_Semplice:over_sla800}': [],
	'checks{RPT_Semplice:over_sla1000}': [],
	'checks{RPT_Semplice:ok_rate}': [],
	'checks{RPT_Semplice:ko_rate}': ['rate<0.01'],
	'checks{RT:over_sla300}': [],
    'checks{RT:over_sla400}': [],
    'checks{RT:over_sla500}': [],
    'checks{RT:over_sla600}': [],
    'checks{RT:over_sla800}': [],
    'checks{RT:over_sla1000}': [],
    'checks{RT:ok_rate}': [],
    'checks{RT:ko_rate}': ['rate<0.01'],
	'checks{RPT_Carrello_5:over_sla300}': [],
	'checks{RPT_Carrello_5:over_sla400}': [],
	'checks{RPT_Carrello_5:over_sla500}': [],
	'checks{RPT_Carrello_5:over_sla600}': [],
	'checks{RPT_Carrello_5:over_sla800}': [],
	'checks{RPT_Carrello_5:over_sla1000}': [],
	'checks{RPT_Carrello_5:ok_rate}': [],
	'checks{RPT_Carrello_5:ko_rate}': ['rate<0.01'],
	'checks{RPT_Carrello_1:over_sla300}': [],
	'checks{RPT_Carrello_1:over_sla400}': [],
	'checks{RPT_Carrello_1:over_sla500}': [],
	'checks{RPT_Carrello_1:over_sla600}': [],
	'checks{RPT_Carrello_1:over_sla800}': [],
	'checks{RPT_Carrello_1:over_sla1000}': [],
	'checks{RPT_Carrello_1:ok_rate}': [],
	'checks{RPT_Carrello_1:ko_rate}': ['rate<0.01'],
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


function random(){
  //var i  = Math.floor(Math.random()*20)%6;
  var i = Math.floor(Math.random() * 6);
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


var baseUrl = "";

export function total() {
  let urls = csvBaseUrl;

  for (var key in urls){
	
	   if (urls[key].ENV == `${__ENV.env}`){
     	
		baseUrl = urls[key].SOAP_BASEURL;
		break;
      }
  }
  console.debug('BASE URL: ');
  console.debug(baseUrl);
	
    execute();
	
	executeRpts();
 
    
}


function func1() {
    verificaAttiva();
}

function func2() {
    verificaAttiva();
}

function func3() {
     verificaAttiva();
}

function func4() {
   verificaAttiva();
}

function func5() {
 chiediNumAvvisoAttiva();
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



export function verificaAttiva() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
    let iuv = genIuv();
	

 	let res = Verifica(baseUrl,rndAnagPsp,rndAnagPa,iuv,1,'OK');

    res = Attiva(baseUrl,rndAnagPsp,rndAnagPa,iuv, "PERFORMANCE");

}

export function chiediNumAvvisoAttiva() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	let rndAnagPaNew = inputDataUtil.getAnagPaNew();
    let iuv = genIuv();


 	let res = ChiediNumeroAvviso(baseUrl,rndAnagPsp,rndAnagPa);

    res = Attiva(baseUrl,rndAnagPsp,rndAnagPa,iuv,"PERFORMANCE");

}

export function rptSemplice() {
	
	let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
	let iuv = genIuvSemplice();



 	let res = RPT(baseUrl,rndAnagPsp,rndAnagPa,iuv);

    res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuv);
}

export function rpt1() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
 	let iuvArray = genIuvArray(1);


	let res = RPT_Carrello_1(baseUrl,rndAnagPsp,rndAnagPa,iuvArray);


    res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[0]);
}

export function rpt5() {

    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
	
    let iuvArray = genIuvArray(5);
	//console.debug("iuvArray=="+iuvArray);


 	let res = RPT_Carrello_5(baseUrl,rndAnagPsp,rndAnagPa,iuvArray);


    res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[0]);
    res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[1]);
    res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[2]);
    res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[3]);
    res = RT(baseUrl,rndAnagPsp,rndAnagPa,iuvArray[4]);
}



export default function(){
	total();
}


export function handleSummary(data) {
  console.debug('Preparing the end-of-test summary...');
 
  return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)
  
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
