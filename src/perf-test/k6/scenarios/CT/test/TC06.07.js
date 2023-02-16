import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { activatePaymentNoticeV2 } from './api/activatePaymentNoticeV2.js';
import { sendPaymentOutputV2 } from './api/sendPaymentOutputV2.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';


const csvBaseUrl = new SharedArray('baseUrl', () => {

  return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;

});

export const getScalini = new SharedArray('scalini', () => {

  const f = JSON.parse(open('../../../cfg/' + `${__ENV.steps}` + '.json'));

  return f;

});

export const options = {
  scenarios: {
    contacts: {
      startVus: 0,
      executor: 'ramping-vus',
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
        { target: getScalini[0].Scalino_CT_10, duration: getScalini[0].Scalino_CT_TIME_10 + 's' },
      ]
    },
  },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'count'],
  discardResponseBodies: false,
  thresholds: {
    'checks{ALL:ok_rate}': [],
    'checks{ALL:ko_rate}': [],
    'checks{activatePaymentNoticeV2:ko_rate}': ['rate<0.01'],
    'checks{activatePaymentNoticeV2:ok_rate}': [],
    'checks{activatePaymentNoticeV2:over_sla300}': [],
    'checks{activatePaymentNoticeV2:over_sla400}': [],
    'checks{activatePaymentNoticeV2:over_sla500}': [],
    'checks{activatePaymentNoticeV2:over_sla600}': [],
    'checks{activatePaymentNoticeV2:over_sla800}': [],
    'checks{activatePaymentNoticeV2:over_sla1000}': [],
    'checks{sendPaymentOutputV2:ko_rate}': ['rate<0.01'],
    'checks{sendPaymentOutputV2:ok_rate}': [],
    'checks{sendPaymentOutputV2:over_sla300}': [],
    'checks{sendPaymentOutputV2:over_sla400}': [],
    'checks{sendPaymentOutputV2:over_sla500}': [],
    'checks{sendPaymentOutputV2:over_sla600}': [],
    'checks{sendPaymentOutputV2:over_sla800}': [],
    'checks{sendPaymentOutputV2:over_sla1000}': []
  },
};

const chars = '0123456789';

function genNoticeNumber() {
  let noticeNumber = '311';
  for (let i = 15; i > 0; --i) noticeNumber += chars[Math.floor(Math.random() * chars.length)];
  return noticeNumber;
}

export default function () {
  total()
}

function total() {
  let restBaseUrl;
  let soapBaseUrl;
  let urls = csvBaseUrl;
  let noticeNumber_1 = genNoticeNumber();
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  for (let key in urls) {
    if (urls[key].ENV == `${__ENV.env}`) {
      restBaseUrl = urls[key].REST_BASEURL;
      soapBaseUrl = urls[key].SOAP_BASEURL;
    }
  }


  let idempotencyKey_1 = common.genIdempotencyKey();

  let paymentToken_1 = activatePaymentNoticeV2(soapBaseUrl, rndAnagPsp, rndAnagPaNew, noticeNumber_1, idempotencyKey_1, "2");

  let idempotencyKey_2 = common.genIdempotencyKey();

  sendPaymentOutputV2(soapBaseUrl, rndAnagPsp, idempotencyKey_2, paymentToken_1);
}
