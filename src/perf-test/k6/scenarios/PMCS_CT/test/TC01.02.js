import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { startSession } from './api/startSession.js';
import { ob_PP_psp } from './api/ob_PP_psp.js';
import { ob_PP_pspInternal } from './api/ob_PP_pspInternal.js';
import { ob_PP_Confirm_Call } from './api/ob_PP_Confirm_Call.js';
import { ob_PP_Confirm } from './api/ob_PP_Confirm.js';
import { ob_PP_Confirm_Continue } from './api/ob_PP_Confirm_Continue.js';
import { ob_PP_Confirm_Logout } from './api/ob_PP_Confirm_Logout.js';
import { ob_PP_Confirm_bye } from './api/ob_PP_Confirm_bye.js';
import * as inputDataUtil from './util/input_data_util.js';
import * as common from '../../CommonScript.js';
//import exec from 'k6/execution';
//import { getCurrentStageIndex } from 'https://jslib.k6.io/k6-utils/1.3.0/index.js';
//import * as db from './db/db.js';


//NB in SIT x ogni run utilizzare token di utente con codice fiscale diverso

const csvBaseUrl = new SharedArray('baseUrl', function () {
  
  return papaparse.parse(open('../../../cfg/baseURL_PM.csv'), { header: true }).data;
  
});



const myListAnno = ["24", "25", "25", "26", "27"];
const myListMese = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];

/*const csvTokens = new SharedArray('tokenIO_data', function () {
    
  return papaparse.parse(open('../../../data/tokenIOList.csv'), { header: true }).data;
});*/


 
export const getScalini = new SharedArray('scalini', function () {
	
 const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
  //console.log(f);
  return f; 
}); 



export const options = {
	
    scenarios: {
  	total: {
      timeUnit: '8s', //dev'essere uguale al n°di richieste per ogni iterazione
      preAllocatedVUs: 1, // how large the initial pool of VUs would be
      executor: 'ramping-arrival-rate',
      //executor: 'ramping-vus',
      //gracefulStop: '0s',
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
	'http_req_duration{startSession:http_req_duration}': [],
	'startSession': [],
    'http_req_duration{ob_PP_psp:http_req_duration}': [],
    'ob_PP_psp': [],
	'http_req_duration{ob_PP_pspInternal:http_req_duration}': [],
	'ob_PP_pspInternal': [],
	'http_req_duration{ob_PP_Confirm_Call:http_req_duration}': [],
	'ob_PP_Confirm_Call': [],
	'http_req_duration{ob_PP_Confirm:http_req_duration}': [],
	'ob_PP_Confirm': [],
	'http_req_duration{ob_PP_Confirm_Continue:http_req_duration}': [],
	'ob_PP_Confirm_Continue': [],
	'http_req_duration{ob_PP_Confirm_Logout:http_req_duration}': [],
	'ob_PP_Confirm_Logout': [],
	'http_req_duration{ob_PP_Confirm_bye:http_req_duration}': [],
	'ob_PP_Confirm_bye': [],
	'http_req_duration{ALL:http_req_duration}': [],
	'ALL': [],
	'checks{ob_PP_psp:over_sla300}': [],
	'checks{ob_PP_psp:over_sla400}': [],
	'checks{ob_PP_psp:over_sla500}': [],
	'checks{ob_PP_psp:over_sla600}': [],
	'checks{ob_PP_psp:over_sla800}': [],
	'checks{ob_PP_psp:over_sla1000}': [],
	'checks{ob_PP_psp:ok_rate}': [],
	'checks{ob_PP_psp:ko_rate}': ['rate<0.01'],
	'checks{startSession:over_sla300}': [],
	'checks{startSession:over_sla400}': [],
	'checks{startSession:over_sla500}': [],
	'checks{startSession:over_sla600}': [],
	'checks{startSession:over_sla800}': [],
	'checks{startSession:over_sla1000}': [],
	'checks{startSession:ok_rate}': [],
	'checks{startSession:ko_rate}': ['rate<0.01'],
	'checks{ob_PP_pspInternal:over_sla300}': [],
	'checks{ob_PP_pspInternal:over_sla400}': [],
	'checks{ob_PP_pspInternal:over_sla500}': [],
	'checks{ob_PP_pspInternal:over_sla600}': [],
	'checks{ob_PP_pspInternal:over_sla800}': [],
	'checks{ob_PP_pspInternal:over_sla1000}': [],
	'checks{ob_PP_pspInternal:ok_rate}': [],
	'checks{ob_PP_pspInternal:ko_rate}': ['rate<0.01'],
	'checks{ob_PP_Confirm_Call:over_sla300}': [],
	'checks{ob_PP_Confirm_Call:over_sla400}': [],
	'checks{ob_PP_Confirm_Call:over_sla500}': [],
	'checks{ob_PP_Confirm_Call:over_sla600}': [],
	'checks{ob_PP_Confirm_Call:over_sla800}': [],
	'checks{ob_PP_Confirm_Call:over_sla1000}': [],
	'checks{ob_PP_Confirm_Call:ok_rate}': [],
	'checks{ob_PP_Confirm_Call:ko_rate}': ['rate<0.01'],
	'checks{ob_PP_Confirm:over_sla300}': [],
	'checks{ob_PP_Confirm:over_sla400}': [],
	'checks{ob_PP_Confirm:over_sla500}': [],
	'checks{ob_PP_Confirm:over_sla600}': [],
	'checks{ob_PP_Confirm:over_sla800}': [],
	'checks{ob_PP_Confirm:over_sla1000}': [],
	'checks{ob_PP_Confirm:ok_rate}': [],
	'checks{ob_PP_Confirm:ko_rate}': ['rate<0.01'],
	'checks{ob_PP_Confirm_Continue:over_sla300}': [],
	'checks{ob_PP_Confirm_Continue:over_sla400}': [],
	'checks{ob_PP_Confirm_Continue:over_sla500}': [],
	'checks{ob_PP_Confirm_Continue:over_sla600}': [],
	'checks{ob_PP_Confirm_Continue:over_sla800}': [],
	'checks{ob_PP_Confirm_Continue:over_sla1000}': [],
	'checks{ob_PP_Confirm_Continue:ok_rate}': [],
	'checks{ob_PP_Confirm_Continue:ko_rate}': ['rate<0.01'],
	'checks{ob_PP_Confirm_Logout:over_sla300}': [],
	'checks{ob_PP_Confirm_Logout:over_sla400}': [],
	'checks{ob_PP_Confirm_Logout:over_sla500}': [],
	'checks{ob_PP_Confirm_Logout:over_sla600}': [],
	'checks{ob_PP_Confirm_Logout:over_sla800}': [],
	'checks{ob_PP_Confirm_Logout:over_sla1000}': [],
	'checks{ob_PP_Confirm_Logout:ok_rate}': [],
	'checks{ob_PP_Confirm_Logout:ko_rate}': ['rate<0.01'],
	'checks{ob_PP_Confirm_bye:over_sla300}': [],
	'checks{ob_PP_Confirm_bye:over_sla400}': [],
	'checks{ob_PP_Confirm_bye:over_sla500}': [],
	'checks{ob_PP_Confirm_bye:over_sla600}': [],
	'checks{ob_PP_Confirm_bye:over_sla800}': [],
	'checks{ob_PP_Confirm_bye:over_sla1000}': [],
	'checks{ob_PP_Confirm_bye:ok_rate}': [],
	'checks{ob_PP_Confirm_bye:ko_rate}': ['rate<0.01'],
	'checks{ALL:over_sla300}': [],
	'checks{ALL:over_sla400}': [],
	'checks{ALL:over_sla500}': [],
	'checks{ALL:over_sla600}': [],
	'checks{ALL:over_sla800}': [],
	'checks{ALL:over_sla1000}': [],
	'checks{ALL:ok_rate}': [],
	'checks{ALL:ko_rate}': ['rate<0.01'],
	},
   
  
}; 





export function total() {

  //console.log("current stage index="+getCurrentStageIndex());
  //console.log(exec.test.options.scenarios.total.stages[getCurrentStageIndex()].target);
  //options.rps = exec.test.options.scenarios.total.stages[getCurrentStageIndex()].target;
  //console.log(options.rps);

  let baseUrl = "";
  let baseUrlPP = "";
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseUrl = urls[key].BASEURL;
		baseUrlPP = urls[key].MOCK_PP_BASEURL;
      }
  }
 
   
  let tokenIO = inputDataUtil.getTokenIO_PP().tokenIO;
  /*let users = ["aPPantani@nft.it", "gPPgiuggiole@nft.it", "pPPpagliaccio@nft.it", "zPPzabalai@nft.it","sPPsacs@nft.it"];

  let tokenIO = '';
  let chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  for (var i = 22; i > 0; --i) tokenIO += chars[Math.floor(Math.random() * chars.length)];
  //console.log("tokenIO="+tokenIO);
  let mail = users[Math.floor(Math.random() * users.length)];
  //console.log("mail="+mail);
  let fc = "ST";
  for (var i = 8; i > 0; --i) fc += chars[Math.floor(Math.random() * chars.length)].toUpperCase();
  //console.log("fc="+fc);
  //db.exec(tokenIO, mail, fc);*/
   
  let res = startSession(baseUrl, tokenIO);

  /*
    try{
    out= res.body.toString();
  //  }catch(error){ out='NA' }

  commonChecks(res);
  standardChecks(res, out, 'substring', `"status":"REGISTERED_SPID"`);*/
  let token = res.token;


  /*let token = 'NA';
     try{
     token=res.json().data.sessionToken;
     }catch(error){}*/

  res = ob_PP_psp(baseUrl,token);
    /*commonChecks(res);
    standardChecks(res, res.status, 'matches', 200);  */



   res = ob_PP_pspInternal(baseUrl);
    //console.log(res);
    /*let redUrlPP='NA';
      try{
      redUrlPP= res.json().data.redirectUrl;
      }catch(error){
      redUrlPP='NA';
      }
    commonChecks(res);
    standardChecks(res, redUrlPP, 'substring', baseUrl); //'10.6.189.28'
    let pp_id_back='NA';
    //redUrlPP='htpp:/jfjfjffj.com/jgj?ere=1'; //to comment
    try{
    if(redUrlPP!==undefined){
  	  pp_id_back=redUrlPP.substr(redUrlPP.indexOf("id_back=")+8);
    }
    }catch(error){}
    //console.log(pp_id_back);*/
  let pp_id_back=res.pp_id_back;


  res= ob_PP_Confirm_Call(baseUrlPP,pp_id_back); //baseUrlPP
    /*commonChecks(res);
    standardChecks(res, res.status, 'matches', 200);*/



  res= ob_PP_Confirm(baseUrlPP); //baseUrlPP
    /*
    let redirect=undefined;
    let RED_Path = "NA";
    try{
    let headers= res.headers;
    redirect = headers['Location'];
    //redirect='htpp:/jfjfjffj.com/jgj?ere=1';
    if(redirect !== undefined){
  	 RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));
    }
    }catch(error){}
    commonChecks(res);
    invertedChecks(res, redirect, 'matches', undefined);  */
  let RED_Path=res.RED_Path;



    //RED_Path = '/pp-restapi-CD/ugugug?ip=1'; //to comment
  res=ob_PP_Confirm_Continue(baseUrl, RED_Path);
    /*redirect=undefined;
    try{
    headers= res.headers;
    redirect = headers['Location'];
    RED_Path = "NA";
    if(redirect !== undefined){
  	 RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));
    }
    }catch(error){}
    commonChecks(res);
    invertedChecks(res, redirect, 'matches', undefined);  */
  RED_Path= res.RED_Path;



    //RED_Path = '/pp-restapi-CD/ugugug?ip=1'; //to comment
  res=ob_PP_Confirm_Logout(baseUrl, RED_Path);
    /*RED_Path = "NA";
    try{
    headers= res.headers;
    redirect = headers['Location'];
    if(redirect !== undefined){

  	 RED_Path=redirect.substr(redirect.indexOf("/pp-restapi-CD"));

    }
    }catch(err){RED_Path='NA';}
    commonChecks(res);
    invertedChecks(res, redirect, 'matches', undefined);  */
  RED_Path =res.RED_Path;


    //RED_Path = '/pp-restapi-CD/ugugug?ip=1'; //to comment
  res=ob_PP_Confirm_bye(baseUrl, RED_Path);


}


export default function(){
	total();
}


export function handleSummary(data) {
  console.log('Preparing the end-of-test summary...');
 
  return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)
  
}

/*
export function commonChecks(res){
	
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
}



export function standardChecks(res, outcome, rule, pattern) {
	
	
   
   if (rule !=='substring'){
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
   }else{
  
    check(
    res,
    {
    
	 'ALL:ok_rate': (r) => outcome.toString().includes(pattern),
    },
    { ALL: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ALL:ko_rate': (r) => !outcome.toString().includes(pattern),
    },
    { ALL: 'ko_rate' }
  );
   }

}




export function invertedChecks(res, outcome, rule, pattern) {
	
	
   
   if (rule !=='substring'){
   check(
    res,
    {
     'ALL OK status': (r) => outcome !== pattern,
    },
    { ALL: 'ok_rate' }
	);
	
	 check(
    res,
    {
      'ALL KO status': (r) => outcome == pattern,
    },
    { ALL: 'ko_rate' }
  );
   }else{
  
    check(
    res,
    {
    
	 'ALL:ok_rate': (r) => !outcome.toString().includes(pattern),
    },
    { ALL: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ALL:ko_rate': (r) => outcome.toString().includes(pattern),
    },
    { ALL: 'ko_rate' }
  );
   }

}
*/