import { check } from 'k6';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from './util/papaparse.js';;
import { nodoChiediInformativaPA } from './api/nodoChiediInformativaPA.js';
import { nodoPAChiediInformativaPA } from './api/nodoPAChiediInformativaPA.js';
import { nodoChiediCatalogoServiziV2 } from './api/nodoChiediCatalogoServiziV2.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';
//import * as test_selector from '../../test_selector.js';



const csvBaseUrl = new SharedArray('baseUrl', function () {

  return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;

});


const chars = '0123456789';

export function genIuv() {

  /*let iuv = Math.random()*100000000000000000;
  iuv = iuv.toString().split('.')[0];*/
  let iuv = '';
  for (var i = 17; i > 0; --i) iuv += chars[Math.floor(Math.random() * chars.length)];
  let user = "";
  let returnValue = user + iuv;
  return returnValue;

}


//const scalini= run.getScalini[0]; 

export const getScalini = new SharedArray('scalini', function () {

  // here you can open files, and then do additional processing or generate the array with data dynamically
  const f = JSON.parse(open('../../../cfg/' + `${__ENV.steps}` + '.json'));
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
      maxVUs: 1500,
      stages: [
        { target: getScalini[0].Scalino_CT_1, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_1 + 's' },
        { target: getScalini[0].Scalino_CT_2, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_2, duration: getScalini[0].Scalino_CT_TIME_2 + 's' },
        { target: getScalini[0].Scalino_CT_3, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_3, duration: getScalini[0].Scalino_CT_TIME_3 + 's' },
        { target: getScalini[0].Scalino_CT_4, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_4, duration: getScalini[0].Scalino_CT_TIME_4 + 's' },
        { target: getScalini[0].Scalino_CT_5, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_5, duration: getScalini[0].Scalino_CT_TIME_5 + 's' },
        { target: getScalini[0].Scalino_CT_6, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_6, duration: getScalini[0].Scalino_CT_TIME_6 + 's' },
        { target: getScalini[0].Scalino_CT_7, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_7, duration: getScalini[0].Scalino_CT_TIME_7 + 's' },
        { target: getScalini[0].Scalino_CT_8, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_8, duration: getScalini[0].Scalino_CT_TIME_8 + 's' },
        { target: getScalini[0].Scalino_CT_9, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_9, duration: getScalini[0].Scalino_CT_TIME_9 + 's' },
        { target: getScalini[0].Scalino_CT_10, duration: 0 + 's' },
        { target: getScalini[0].Scalino_CT_10, duration: getScalini[0].Scalino_CT_TIME_10 + 's' }, //to uncomment
      ],
      tags: { test_type: 'ALL' },
      exec: 'total',
    }

  },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'p(99)', 'p(99.99)', 'p(100)', 'count'],
  discardResponseBodies: false,
  thresholds: {
    'http_req_duration{nodoChiediInformativaPA:http_req_duration}': [],
    'http_req_duration{nodoPAChiediInformativaPA:http_req_duration}': [],
    'http_req_duration{RPT_Carrello_5:http_req_duration}': [],
    'http_req_duration{ALL:http_req_duration}': [],
    'checks{nodoChiediInformativaPA:over_sla300}': [],
    'checks{nodoChiediInformativaPA:over_sla400}': [],
    'checks{nodoChiediInformativaPA:over_sla500}': [],
    'checks{nodoChiediInformativaPA:over_sla600}': [],
    'checks{nodoChiediInformativaPA:over_sla800}': [],
    'checks{nodoChiediInformativaPA:over_sla1000}': [],
    'checks{nodoChiediInformativaPA:ok_rate}': [],
    'checks{nodoChiediInformativaPA:ko_rate}': [],
    'checks{nodoPAChiediInformativaPA:over_sla300}': [],
    'checks{nodoPAChiediInformativaPA:over_sla400}': [],
    'checks{nodoPAChiediInformativaPA:over_sla500}': [],
    'checks{nodoPAChiediInformativaPA:over_sla600}': [],
    'checks{nodoPAChiediInformativaPA:over_sla800}': [],
    'checks{nodoPAChiediInformativaPA:over_sla1000}': [],
    'checks{nodoPAChiediInformativaPA:ok_rate}': [],
    'checks{nodoPAChiediInformativaPA:ko_rate}': [],
    'checks{nodoChiediCatalogoServiziV2:over_sla300}': [],
    'checks{nodoChiediCatalogoServiziV2:over_sla400}': [],
    'checks{nodoChiediCatalogoServiziV2:over_sla500}': [],
    'checks{nodoChiediCatalogoServiziV2:over_sla600}': [],
    'checks{nodoChiediCatalogoServiziV2:over_sla800}': [],
    'checks{nodoChiediCatalogoServiziV2:over_sla1000}': [],
    'checks{nodoChiediCatalogoServiziV2:ok_rate}': [],
    'checks{nodoChiediCatalogoServiziV2:ko_rate}': [],
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

export function total() {

  let baseSoapUrl = "";
  let urls = csvBaseUrl;
  for (var key in urls) {
    if (urls[key].ENV == `${__ENV.env}`) {

      baseSoapUrl = urls[key].SOAP_BASEURL;
    }
  }
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPa = inputDataUtil.getAnagPa();

  let res = nodoChiediInformativaPA(baseSoapUrl, rndAnagPsp);

  res = nodoPAChiediInformativaPA(baseSoapUrl, rndAnagPa);

  res = nodoChiediCatalogoServiziV2(baseSoapUrl, rndAnagPsp);

}

export default function () {
  total();
}

export function handleSummary(data) {
  console.debug('Preparing the end-of-test summary...');

  return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)

}


export function checks(res, outcome, pattern) {

  check(res, {
    'ALL over_sla300': (r) => r.timings.duration > 300,
  },
    { ALL: 'over_sla300' }
  );

  check(res, {
    'ALL over_sla400': (r) => r.timings.duration > 400,
  },
    { ALL: 'over_sla400' }
  );

  check(res, {
    'ALL over_sla500': (r) => r.timings.duration > 500,
  },
    { ALL: 'over_sla500' }
  );

  check(res, {
    'ALL over_sla600': (r) => r.timings.duration > 600,
  },
    { ALL: 'over_sla600' }
  );

  check(res, {
    'ALL over_sla800': (r) => r.timings.duration > 800,
  },
    { ALL: 'over_sla800' }
  );

  check(res, {
    'ALL over_sla1000': (r) => r.timings.duration > 1000,
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
