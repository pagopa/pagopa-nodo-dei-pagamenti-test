import { check } from 'k6';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from './util/papaparse.js';
import { chiediInformazioniPagamento } from './api/chiediInformazioniPagamento.js';
import { inoltraEsitoPagamentoCarta } from './api/inoltraEsitoPagamentoCarta.js';
import { RPT_Carrello_2 } from './api/RPT_Carrello_2.js';
import { RT } from './api/RT.js';
import * as inputDataUtil from './util/input_data_util.js';
//import * as test_selector from '../../test_selector.js';



const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;
  
});



export const getScalini = new SharedArray('scalini', function () {
	
  // here you can open files, and then do additional processing or generate the array with data dynamically
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.debug(f);
  return f; // f must be an array[]
});

export const options = {
	
  scenarios: {
      	total: {
          timeUnit: '5s',
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
          tags: { test_type: 'ALL' },
          exec: 'total',
        }

      },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'p(99)', 'p(99.99)', 'p(100)', 'count'],
  discardResponseBodies: false,
  thresholds: {
    
    'http_req_duration{RPT_Carrello_2:http_req_duration}': [],
    'http_req_duration{RT:http_req_duration}': [],
	'http_req_duration{chiediInformazioniPagamento:http_req_duration}': [],
    'http_req_duration{inoltraEsitoPagamentoCarta:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
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
	'checks{chiediInformazioniPagamento:over_sla300}': [],
	'checks{chiediInformazioniPagamento:over_sla400}': [],
	'checks{chiediInformazioniPagamento:over_sla500}': [],
	'checks{chiediInformazioniPagamento:over_sla600}': [],
	'checks{chiediInformazioniPagamento:over_sla800}': [],
	'checks{chiediInformazioniPagamento:over_sla1000}': [],
	'checks{chiediInformazioniPagamento:ok_rate}': [],
	'checks{chiediInformazioniPagamento:ko_rate}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla300}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla400}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla500}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla600}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla800}': [],
	'checks{inoltraEsitoPagamentoCarta:over_sla1000}': [],
	'checks{inoltraEsitoPagamentoCarta:ok_rate}': [],
	'checks{inoltraEsitoPagamentoCarta:ko_rate}': [],
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
  let paymentToken=res.paymentToken;
	console.debug("paymentToken from RPT_Carrello_2 "+ paymentToken);

  
  res = chiediInformazioniPagamento(baseRestUrl,paymentToken, rndAnagPa);
  
  let importoTotale = res.importoTotale;
  res = inoltraEsitoPagamentoCarta(baseRestUrl,rndAnagPsp,paymentToken,'esito','OK', importoTotale,15465081);


  
  res = RT(baseSoapUrl,rndAnagPsp,rndAnagPa,iuvArray[0]);


  res = RT(baseSoapUrl,rndAnagPsp,rndAnagPa,iuvArray[1]);

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


