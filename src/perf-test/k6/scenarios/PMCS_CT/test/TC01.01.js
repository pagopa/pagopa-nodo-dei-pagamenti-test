import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { jUnit, textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';
import { startSession } from './api/startSession.js';
import { ob_CC_Onboard } from './api/ob_CC_Onboard.js';
import { ob_CC_Verify } from './api/ob_CC_Verify.js';
import { ob_CC_VerifyInternal } from './api/ob_CC_VerifyInternal.js';
import { ob_CC_CheckOut } from './api/ob_CC_CheckOut.js';
import { ob_CC_Check_1 } from './api/ob_CC_Check_1.js';
import { ob_CC_Check_2 } from './api/ob_CC_Check_2.js';
import { ob_CC_Check_3 } from './api/ob_CC_Check_3.js';
import { ob_CC_Logout } from './api/ob_CC_Logout.js';
import { ob_CC_Challenge } from './api/ob_CC_Challenge.js';
import { ob_CC_Response} from './api/ob_CC_Response.js';
import { ob_CC_update} from './api/ob_CC_update.js';
import { ob_CC_bye} from './api/ob_CC_bye.js';
import { ob_CC_resume3ds2} from './api/ob_CC_resume3ds2.js';
import { ob_CC_continueToStep1 } from './api/ob_CC_continueToStep1.js';
import * as inputDataUtil from './util/input_data_util.js';
import * as common from '../../CommonScript.js';
//import * as db from './db/db.js';

//NB in perf togliere riferimenti a acsUrl anche in obCC_Challenge e in check2 e scommentare la ob_CC_Response
//   questo scenario è propedeutico al TC01.03 --> la carta usata lì deve essere verificata qui

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

//const apisNumber = 15;
export const options = {

        scenarios: {
        	total: {
            timeUnit: '21s', //dev'essere uguale al n°di richieste per ogni iterazione + stima n°ripetizioni check (2/3)
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
    'http_req_duration{ob_CC_Onboard:http_req_duration}': [],
    'http_req_duration{ob_CC_Verify:http_req_duration}': [],
	'http_req_duration{ob_CC_VerifyInternal:http_req_duration}': [],
	'http_req_duration{ob_CC_continueToStep1:http_req_duration}': [],
	'http_req_duration{ob_CC_CheckOut:http_req_duration}': [],
	'http_req_duration{ob_CC_Check_1:http_req_duration}': [],
	'http_req_duration{ob_CC_Check_2:http_req_duration}': [],
	'http_req_duration{ob_CC_Check_3:http_req_duration}': [],
	'http_req_duration{ob_CC_Logout:http_req_duration}': [],
	'http_req_duration{ob_CC_bye:http_req_duration}': [],
	'http_req_duration{ob_CC_update:http_req_duration}': [],
	'http_req_duration{ob_CC_Challenge:http_req_duration}': [],
	'http_req_duration{ob_CC_Response:http_req_duration}': [],
	'http_req_duration{ob_CC_resume3ds2:http_req_duration}': [],
	'http_req_duration{startSession:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [], //'p(95)<200' 95% of requests should be below 200ms
	'checks{ob_CC_Onboard:over_sla300}': [], //'rate<0.9' 90% of requests of this api should be below 300ms
	'checks{ob_CC_Onboard:over_sla400}': [],
	'checks{ob_CC_Onboard:over_sla500}': [],
	'checks{ob_CC_Onboard:over_sla600}': [],
	'checks{ob_CC_Onboard:over_sla800}': [],
	'checks{ob_CC_Onboard:over_sla1000}': [],
	'checks{ob_CC_Onboard:ok_rate}': [],
	'checks{ob_CC_Onboard:ko_rate}': [],
	'checks{ob_CC_Verify:over_sla300}': [],
	'checks{ob_CC_Verify:over_sla400}': [],
	'checks{ob_CC_Verify:over_sla500}': [],
	'checks{ob_CC_Verify:over_sla600}': [],
	'checks{ob_CC_Verify:over_sla800}': [],
	'checks{ob_CC_Verify:over_sla1000}': [],
	'checks{ob_CC_Verify:ok_rate}': [],
	'checks{ob_CC_Verify:ko_rate}': [],
	'checks{ob_CC_VerifyInternal:over_sla300}': [],
	'checks{ob_CC_VerifyInternal:over_sla400}': [],
	'checks{ob_CC_VerifyInternal:over_sla500}': [],
	'checks{ob_CC_VerifyInternal:over_sla600}': [],
	'checks{ob_CC_VerifyInternal:over_sla800}': [],
	'checks{ob_CC_VerifyInternal:over_sla1000}': [],
	'checks{ob_CC_VerifyInternal:ok_rate}': [],
	'checks{ob_CC_VerifyInternal:ko_rate}': [],
	'checks{ob_CC_continueToStep1:over_sla300}': [],
	'checks{ob_CC_continueToStep1:over_sla400}': [],
	'checks{ob_CC_continueToStep1:over_sla500}': [],
	'checks{ob_CC_continueToStep1:over_sla600}': [],
	'checks{ob_CC_continueToStep1:over_sla800}': [],
	'checks{ob_CC_continueToStep1:over_sla1000}': [],
	'checks{ob_CC_continueToStep1:ok_rate}': [],
	'checks{ob_CC_continueToStep1:ko_rate}': [],
	'checks{ob_CC_CheckOut:over_sla300}': [],
	'checks{ob_CC_CheckOut:over_sla400}': [],
	'checks{ob_CC_CheckOut:over_sla500}': [],
	'checks{ob_CC_CheckOut:over_sla600}': [],
	'checks{ob_CC_CheckOut:over_sla800}': [],
	'checks{ob_CC_CheckOut:over_sla1000}': [],
	'checks{ob_CC_CheckOut:ok_rate}': [],
	'checks{ob_CC_CheckOut:ko_rate}': [],
	'checks{ob_CC_Check_1:over_sla300}': [],
	'checks{ob_CC_Check_1:over_sla400}': [],
	'checks{ob_CC_Check_1:over_sla500}': [],
	'checks{ob_CC_Check_1:over_sla600}': [],
	'checks{ob_CC_Check_1:over_sla800}': [],
	'checks{ob_CC_Check_1:over_sla1000}': [],
	'checks{ob_CC_Check_1:ok_rate}': [],
	'checks{ob_CC_Check_1:ko_rate}': [],
	'checks{ob_CC_Check_2:over_sla300}': [],
	'checks{ob_CC_Check_2:over_sla400}': [],
	'checks{ob_CC_Check_2:over_sla500}': [],
	'checks{ob_CC_Check_2:over_sla600}': [],
	'checks{ob_CC_Check_2:over_sla800}': [],
	'checks{ob_CC_Check_2:over_sla1000}': [],
	'checks{ob_CC_Check_2:ok_rate}': [],
	'checks{ob_CC_Check_2:ko_rate}': [],
	'checks{ob_CC_Check_3:over_sla300}': [],
	'checks{ob_CC_Check_3:over_sla400}': [],
	'checks{ob_CC_Check_3:over_sla500}': [],
	'checks{ob_CC_Check_3:over_sla600}': [],
	'checks{ob_CC_Check_3:over_sla800}': [],
	'checks{ob_CC_Check_3:over_sla1000}': [],
	'checks{ob_CC_Check_3:ok_rate}': [],
	'checks{ob_CC_Check_3:ko_rate}': [],
	'checks{ob_CC_Logout:over_sla300}': [],
	'checks{ob_CC_Logout:over_sla400}': [],
	'checks{ob_CC_Logout:over_sla500}': [],
	'checks{ob_CC_Logout:over_sla600}': [],
	'checks{ob_CC_Logout:over_sla800}': [],
	'checks{ob_CC_Logout:over_sla1000}': [],
	'checks{ob_CC_Logout:ok_rate}': [],
	'checks{ob_CC_Logout:ko_rate}': [],
	'checks{ob_CC_bye:over_sla300}': [],
	'checks{ob_CC_bye:over_sla400}': [],
	'checks{ob_CC_bye:over_sla500}': [],
	'checks{ob_CC_bye:over_sla600}': [],
	'checks{ob_CC_bye:over_sla800}': [],
	'checks{ob_CC_bye:over_sla1000}': [],
	'checks{ob_CC_bye:ok_rate}': [],
	'checks{ob_CC_bye:ko_rate}': [],
	'checks{ob_CC_update:over_sla300}': [],
	'checks{ob_CC_update:over_sla400}': [],
	'checks{ob_CC_update:over_sla500}': [],
	'checks{ob_CC_update:over_sla600}': [],
	'checks{ob_CC_update:over_sla800}': [],
	'checks{ob_CC_update:over_sla1000}': [],
	'checks{ob_CC_update:ok_rate}': [],
	'checks{ob_CC_update:ko_rate}': [],
	'checks{startSession:over_sla300}': [],
	'checks{startSession:over_sla400}': [],
	'checks{startSession:over_sla500}': [],
	'checks{startSession:over_sla600}': [],
	'checks{startSession:over_sla800}': [],
	'checks{startSession:over_sla1000}': [],
	'checks{startSession:ok_rate}': [],
	'checks{startSession:ko_rate}': [],
	'checks{ob_CC_Challenge:over_sla300}': [],
	'checks{ob_CC_Challenge:over_sla400}': [],
	'checks{ob_CC_Challenge:over_sla500}': [],
	'checks{ob_CC_Challenge:over_sla600}': [],
	'checks{ob_CC_Challenge:over_sla800}': [],
	'checks{ob_CC_Challenge:over_sla1000}': [],
	'checks{ob_CC_Challenge:ok_rate}': [],
	'checks{ob_CC_Challenge:ko_rate}': [],
	'checks{ob_CC_Response:over_sla300}': [],
	'checks{ob_CC_Response:over_sla400}': [],
	'checks{ob_CC_Response:over_sla500}': [],
	'checks{ob_CC_Response:over_sla600}': [],
	'checks{ob_CC_Response:over_sla800}': [],
	'checks{ob_CC_Response:over_sla1000}': [],
	'checks{ob_CC_Response:ok_rate}': [],
	'checks{ob_CC_Response:ko_rate}': [],
	'checks{ob_CC_resume3ds2:over_sla300}': [],
	'checks{ob_CC_resume3ds2:over_sla400}': [],
	'checks{ob_CC_resume3ds2:over_sla500}': [],
	'checks{ob_CC_resume3ds2:over_sla600}': [],
	'checks{ob_CC_resume3ds2:over_sla800}': [],
	'checks{ob_CC_resume3ds2:over_sla1000}': [],
	'checks{ob_CC_resume3ds2:ok_rate}': [],
	'checks{ob_CC_resume3ds2:ko_rate}': [],
	'checks{ALL:over_sla300}': [],
	'checks{ALL:over_sla400}': [],
	'checks{ALL:over_sla500}': [],
	'checks{ALL:over_sla600}': [],
	'checks{ALL:over_sla800}': [],
	'checks{ALL:over_sla1000}': [],
	'checks{ALL:ok_rate}': [],
	'checks{ALL:ko_rate}': [], //'rate<0.01' http errors should be less than 0.01%
	},
   
  
}; 





export function total() {

  let baseUrl = "";
  let baseUrlPM = "";
  let urls = csvBaseUrl;
  for (var key in urls){
	   if (urls[key].ENV == `${__ENV.env}`){
     
		baseUrl = urls[key].BASEURL;
		baseUrlPM = urls[key].MOCK_PM_BASEURL;
      }
  }
 
   
  let tokenIO = inputDataUtil.getTokenIO_CC().tokenIO;
  /* let users = ["aPPantani@nft.it", "gPPgiuggiole@nft.it", "pPPpagliaccio@nft.it", "zPPzabalai@nft.it","sPPsacs@nft.it"];

  let tokenIO = '';
  let chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  for (var i = 22; i > 0; --i) tokenIO += chars[Math.floor(Math.random() * chars.length)];
  //console.log("tokenIO="+tokenIO);
  let mail = users[Math.floor(Math.random() * users.length)];
  //console.log("mail="+mail);
  let fc = "ST";
  for (var i = 8; i > 0; --i) fc += chars[Math.floor(Math.random() * chars.length)].toUpperCase();
  //console.log("fc="+fc);
  //db.exec(tokenIO, mail, fc); */
   
  //console.log("----------------------startsess-------------"+tokenIO);

  let res = startSession(baseUrl, tokenIO);
  let token = res.token;
  console.log("token="+token);
  console.log("tokenIo="+tokenIO);


	
  //let rndCard = inputDataUtil.getCards().cardNumber;
  let rndCard = inputDataUtil.getTokenIO_CC().card;
  let rndM = Math.floor(Math.random() * myListMese.length);
  let scdMese = myListMese[rndM];
  let rndY = Math.floor(Math.random() * myListAnno.length);
  let scdAnno = myListAnno[rndY];


  res = ob_CC_Onboard(baseUrl,token, rndCard, scdMese, scdAnno);
  //let outcome= res["data.idWallet"];
  /*let outcome=undefined;
      //console.log(res);
      try{
      outcome= res.json().data.idWallet;
      }catch(error){
      outcome=undefined;
      }
  commonChecks(res);
  invertedChecks(res, outcome, 'matches', undefined);  
  console.log(res.status+";"+tokenIO+";"+res.json().data.idWallet+";"+rndCard)*/
  let outcome=res.outcome;
  console.log("idWallet="+outcome);
  console.log(";"+tokenIO+";"+outcome);
  
  
  res = ob_CC_Verify(baseUrl,outcome,token);

  /*commonChecks(res);
  standardChecks(res, res.body, 'substring', 'DOCTYPE html');*/
  //console.log(res);
  
  res = ob_CC_VerifyInternal(baseUrl);
  let idTr=res.idTr;
  let RED_Path = res.RED_Path;
  //console.log(res);

  //RED_Path="/hfhfhfhfh?tyty=1"; //to comment


  res = ob_CC_CheckOut(baseUrl, RED_Path);
  idTr=res.idTr;


   
  let resCheck1 = ''; 
  let statusTr = undefined;
  do {
  //console.log("dentro while");
  resCheck1 = ob_CC_Check_1(baseUrl, idTr);

  statusTr=resCheck1.statusTr;
  }
  while (!(statusTr == 'Confermato' || statusTr == 'In attesa del metodo 3ds2'))
  //console.log("dopo while");

  console.log(token+";"+outcome+";"+resCheck1.idPayment+";");



    if(statusTr === 'In attesa del metodo 3ds2'){
    //if(statusTr === 'Confermato'){ //to comment
		
	  let threeDSMethodData = 'threeDSMethodData';
	  res = ob_CC_continueToStep1(baseUrl, idTr, threeDSMethodData);
	  /*commonChecks(res);
      standardChecks(res, res.status, 'matches', 200);  */
	  
	  
	  
	  let resCheck2 = ''; 
	  let creq = '';
	  //let acsUrl=''; //in perf non si usa
  	  do {

        resCheck2 = ob_CC_Check_2(baseUrl, idTr);
        statusTr = resCheck2.statusTr;
        creq=resCheck2.creq;
        //acsUrl=resCheck2.acsUrl; //in perf non si usa
       /* console.log(resCheck2.body);
        statusTr=undefined;
        try{
        let subStMsg=resCheck2.body.substr(resCheck2.body.indexOf("statusMessage")+16);
        statusTr = subStMsg.split('"')[0];
        /*statusTr = resCheck2['statusMessage'];
        statusTr = 'In attesa della challenge 3ds2'; *///to comment
        /*
        let subCreq=resCheck2.body.substr(resCheck2.body.indexOf("creq")+7);
        console.log(subCreq);
        creq = subCreq.split('"')[0];
        }catch(error){}
        console.log("creq="+creq);
        console.log("statusTr="+statusTr);
		//creq = resCheck2['params.creq'];
		//console.log("dentro while 2");
		commonChecks(resCheck2);
        invertedChecks(resCheck2, statusTr, 'matches', undefined);  */
      }
      while (statusTr !== 'In attesa della challenge 3ds2');



	  //console.log("dopo while 2");
	  res= ob_CC_Challenge(baseUrlPM, creq);
	  //res= ob_CC_Challenge(baseUrlPM, creq, acsUrl); //in perf acsUrl non si usa
	  let threedstransId = res.threedstransId;

	  //console.log('threedstransId='+threedstransId);



      res= ob_CC_Response(baseUrl, threedstransId, token); //scommentare in perf



	  let rndCres ='';
	  let chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
	  for (var i = 12; i > 0; --i) rndCres += chars[Math.floor(Math.random() * chars.length)];
	  res= ob_CC_resume3ds2(baseUrl, idTr, rndCres);
	  /*commonChecks(res);
	  standardChecks(res, res.status, 'matches', 200);*/
	  
	  
	  
	  let resCheck3 = ''; 
	  do {
       
        resCheck3 = ob_CC_Check_3(baseUrl, idTr);
        statusTr = resCheck3.statusTr;
        console.log("check3====="+statusTr);
        //statusTr = resCheck3['statusMessage'];
        /*statusTr=undefined;
        try{
        let subStMsg=resCheck1.body.substr(resCheck1.body.indexOf("statusMessage")+16);
        statusTr = subStMsg.split('"')[0];
        }catch(error){}
        //statusTr = 'Confermato'; //to comment
		//console.log("dentro while 3");
		commonChecks(resCheck3);
        invertedChecks(resCheck3, statusTr, 'matches', undefined);  */
      }
      while (statusTr !== 'Confermato');
	  
    }
	

    res= ob_CC_Logout(baseUrl, idTr);
    RED_Path=res.RED_Path;
    idTr=res.idTr;

    //console.log("redPath="+RED_Path+"idTr="+idTr);
	//RED_Path="/hfhfhfhfh?tyty=1"; //to comment
	res= ob_CC_bye(baseUrl, RED_Path);

	
	
	res = ob_CC_update(baseUrl,token, rndCard, scdMese, scdAnno);
	/*console.log(res.body);
	//let esito = res['data.saved'];
	 let esito=undefined;
           //console.log(res);
           try{
           esito= res.json().data.saved;
           }catch(error){
           esito=undefined;
           }
	commonChecks(res);
    standardChecks(res, esito, 'matches', '0');  */



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