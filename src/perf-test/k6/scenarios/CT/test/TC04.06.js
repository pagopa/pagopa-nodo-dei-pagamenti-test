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
import { RPT_Carrello_2 } from './api/RPT_Carrello_2.js';
import { RT } from './api/RT.js';
import { chiediInformazioniPagamento } from './api/chiediInformazioniPagamento.js';
import { nodoChiediAvanzamentoPagamento_Post } from './api/nodoChiediAvanzamentoPagamento_Post.js';
import { nodoChiediAvanzamentoPagamento_Pre } from './api/nodoChiediAvanzamentoPagamento_Pre.js';
import { inoltraEsitoPagamentoCarta } from './api/inoltraEsitoPagamentoCarta.js';
import * as outputUtil from './util/output_util.js';
import * as inputDataUtil from './util/input_data_util.js';
import { parseHTML } from "k6/html";
//import * as test_selector from '../../test_selector.js';


const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;
  
});


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
    'http_req_duration{nodoChiediAvanzamentoPagamento_Pre:http_req_duration}': [],
    // we can reference the scenario names as well
    'http_req_duration{inoltraEsitoPagamentoCarta:http_req_duration}': [],
	'http_req_duration{chiediInformazioniPagamento:http_req_duration}': [],
	'http_req_duration{RPT_Carrello_2:http_req_duration}': [],
	'http_req_duration{RT:http_req_duration}': [],
	'http_req_duration{nodoChiediAvanzamentoPagamento_Post:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	'checks{nodoChiediAvanzamentoPagamento_Pre:over_sla300}': [],
	'checks{nodoChiediAvanzamentoPagamento_Pre:over_sla400}': [],
	'checks{nodoChiediAvanzamentoPagamento_Pre:over_sla500}': [],
	'checks{nodoChiediAvanzamentoPagamento_Pre:over_sla600}': [],
	'checks{nodoChiediAvanzamentoPagamento_Pre:over_sla800}': [],
	'checks{nodoChiediAvanzamentoPagamento_Pre:over_sla1000}': [],
	'checks{nodoChiediAvanzamentoPagamento_Pre:ok_rate}': [],
	'checks{nodoChiediAvanzamentoPagamento_Pre:ko_rate}': [],
	'checks{nodoChiediAvanzamentoPagamento_Post:over_sla300}': [],
	'checks{nodoChiediAvanzamentoPagamento_Post:over_sla400}': [],
	'checks{nodoChiediAvanzamentoPagamento_Post:over_sla500}': [],
	'checks{nodoChiediAvanzamentoPagamento_Post:over_sla600}': [],
	'checks{nodoChiediAvanzamentoPagamento_Post:over_sla800}': [],
	'checks{nodoChiediAvanzamentoPagamento_Post:over_sla1000}': [],
	'checks{nodoChiediAvanzamentoPagamento_Post:ok_rate}': [],
	'checks{nodoChiediAvanzamentoPagamento_Post:ko_rate}': [],
	'checks{RPT_Carrello_2:over_sla300}': [],
	'checks{RPT_Carrello_2:over_sla400}': [],
	'checks{RPT_Carrello_2:over_sla500}': [],
	'checks{RPT_Carrello_2:over_sla600}': [],
	'checks{RPT_Carrello_2:over_sla800}': [],
	'checks{RPT_Carrello_2:over_sla1000}': [],
	'checks{RPT_Carrello_2:ok_rate}': [],
	'checks{RPT_Carrello_2:ko_rate}': [],
	'checks{RT:over_sla300}': [],
	'checks{RT:over_sla400}': [],
	'checks{RT:over_sla500}': [],
	'checks{RT:over_sla600}': [],
	'checks{RT:over_sla800}': [],
	'checks{RT:over_sla1000}': [],
	'checks{RT:ok_rate}': [],
	'checks{RT:ko_rate}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla300}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla400}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla500}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla600}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla800}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla1000}': [],
	'checks{inoltraEsitoPagamentoCarta:ok_rate}': [],
	'checks{inoltraEsitoPagamentoCarta:ko_rate}': [],
	'checks{chiediInformazioniPagamento:over_sla300}': [],
	'checks{chiediInformazioniPagamento:over_sla400}': [],
	'checks{chiediInformazioniPagamento:over_sla500}': [],
	'checks{chiediInformazioniPagamento:over_sla600}': [],
	'checks{chiediInformazioniPagamento:over_sla800}': [],
	'checks{chiediInformazioniPagamento:over_sla1000}': [],
	'checks{chiediInformazioniPagamento:ok_rate}': [],
	'checks{chiediInformazioniPagamento:ko_rate}': [],
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



export function genIuvArray(l){
	
var iuvArray = [];
let user = Math.random()*10000;
	user = user.toString().split('.')[0];
	var dt = new Date();
	let ms = dt.getMilliseconds();
	
	dt = dt.getFullYear() + ("0" + (dt.getMonth() + 1)).slice(-2) + ("0" + dt.getDate()).slice(-2) + 
	("0" + dt.getHours() ).slice(-2) + ("0" + dt.getMinutes()).slice(-2) + ("0" + dt.getSeconds()).slice(-2)+ ms;

let iuv = "";	
//console.log(dt+"------"+user);
for(let i = 0; i < l; i++){
  iuv = "P" + i;
  iuv += user; 
  iuv += makeid(3);
  iuv += "_";
  iuv += dt;
  iuvArray.push(iuv);

}
//console.log("genIuvArray="+iuvArray);
//console.log("genIuvArray1="+iuvArray[0]);
return iuvArray;

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

	let iuvArray = genIuvArray(2);
	
   
    let res =  RPT_Carrello_2(baseSoapUrl,rndAnagPa,iuvArray);
  
    let doc = parseHTML(res.body);
    let script = doc.find('esitoComplessivoOperazione');
    let outcome = script.text();
	script = doc.find('url');
    var token = script.text();
    var paymentToken = token.split('=')[1];
    
    checks(res, outcome, 'OK');
	   
	
	
    res = chiediInformazioniPagamento(baseRestUrl,paymentToken, rndAnagPa);
	
	let ragioneSocialeExtr= res["ragioneSociale"];;
    	 
         
    checks(res, ragioneSocialeExtr, rndAnagPa.PA);
 
 
 
 
    res = inoltraEsitoPagamentoCarta(baseRestUrl,rndAnagPsp,paymentToken);
	 
    outcome= res["error"];
     
    checks(res, outcome, 408);
	

	
	
	res = nodoChiediAvanzamentoPagamento_Pre(baseRestUrl,paymentToken);

    outcome= res["esito"];
     
    checks(res, outcome, "ACK_UNKNOWN");
	
	
	
	
	res = RT(baseSoapUrl,rndAnagPsp,rndAnagPa,iuvArray[0]);
	 
    doc = parseHTML(res.body);
    script = doc.find('esito');
    outcome = script.text();
     
    checks(res, outcome, 'OK');

	
	
	res = RT(baseSoapUrl,rndAnagPsp,rndAnagPa,iuvArray[1]);
	 
    doc = parseHTML(res.body);
    script = doc.find('esito');
    outcome = script.text();
     
    checks(res, outcome, 'OK');
	
	
	
	res = nodoChiediAvanzamentoPagamento_Post(baseRestUrl,paymentToken);

    outcome= res["esito"];
     
    checks(res, outcome, "OK");
  
}


export default function(){
	total();
}


export function handleSummary(data) {
  console.log('Preparing the end-of-test summary...');
 
  var csv = outputUtil.extractData(data);
     
   return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true, expected_response: 'ALL' }), // Show the text summary to stdout...
	'./scenarios/CT/test/output/TC04.09.summary.json': JSON.stringify(data), // and a JSON with all the details...
	//'./scenarios/CT/test/output/summary.html': htmlReport(data),
	'./scenarios/CT/test/output/TC04.09.summary.csv': csv[0],
	'./scenarios/CT/test/output/TC04.09.trOverSla.csv': csv[1],
	'./scenarios/CT/test/output/TC04.09.resultCodeSummary.csv': csv[2],
	
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



