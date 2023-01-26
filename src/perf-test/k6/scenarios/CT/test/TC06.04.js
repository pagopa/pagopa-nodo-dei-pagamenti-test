import { SharedArray } from 'k6/data';
import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { checkPosition_5 } from './api/checkPosition_5.js';
import { activatePaymentNoticeV2 } from './api/activatePaymentNoticeV2.js';
import { closePaymentV2KO_esitoKO } from './api/closePaymentV2KO.js';
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
    total: {
      timeUnit: '4s',
      preAllocatedVUs: 1,
      executor: 'ramping-arrival-rate',
      maxVUs: 500,
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
      ],
      tags: { test_type: 'ALL' },
      exec: 'total',
    }
  },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'count'],
  discardResponseBodies: false,
  thresholds: {
    'checks{checkPosition_5:ko_rate}': ['rate<0.01'],
    'checks{checkPosition_5:ok_rate}': [],
    'checks{checkPosition_5:over_sla300}': [],
    'checks{checkPosition_5:over_sla400}': [],
    'checks{checkPosition_5:over_sla500}': [],
    'checks{checkPosition_5:over_sla600}': [],
    'checks{checkPosition_5:over_sla800}': [],
    'checks{checkPosition_5:over_sla1000}': [],
    'checks{activatePaymentNoticeV2:ko_rate}': ['rate<0.01'],
    'checks{activatePaymentNoticeV2:ok_rate}': [],
    'checks{activatePaymentNoticeV2:over_sla300}': [],
    'checks{activatePaymentNoticeV2:over_sla400}': [],
    'checks{activatePaymentNoticeV2:over_sla500}': [],
    'checks{activatePaymentNoticeV2:over_sla600}': [],
    'checks{activatePaymentNoticeV2:over_sla800}': [],
    'checks{activatePaymentNoticeV2:over_sla1000}': [],
    'checks{closePaymentV2KO_esitoKO:ko_rate}': ['rate<0.01'],
    'checks{closePaymentV2KO_esitoKO:ok_rate}': [],
    'checks{closePaymentV2KO_esitoKO:over_sla300}': [],
    'checks{closePaymentV2KO_esitoKO:over_sla400}': [],
    'checks{closePaymentV2KO_esitoKO:over_sla500}': [],
    'checks{closePaymentV2KO_esitoKO:over_sla600}': [],
    'checks{closePaymentV2KO_esitoKO:over_sla800}': [],
    'checks{closePaymentV2KO_esitoKO:over_sla1000}': [],
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
  let noticeNumber_2 = genNoticeNumber();
  let noticeNumber_3 = genNoticeNumber();
  let noticeNumber_4 = genNoticeNumber();
  let noticeNumber_5 = genNoticeNumber();
  let rndAnagPsp = inputDataUtil.getAnagPsp();
  let rndAnagPaNew = inputDataUtil.getAnagPaNew();
  let idempotencyKey_1 = common.genIdempotencyKey();
  for (let key in urls) {
    if (urls[key].ENV == `${__ENV.env}`) {
      restBaseUrl = urls[key].REST_BASEURL;
      soapBaseUrl = urls[key].SOAP_BASEURL;
    }
  }

  checkPosition_5(restBaseUrl, noticeNumber_1, noticeNumber_2, noticeNumber_3, noticeNumber_4, noticeNumber_5);

  let paymentToken_1 = activatePaymentNoticeV2(soapBaseUrl, rndAnagPsp, rndAnagPaNew, noticeNumber_1, idempotencyKey_1, "1");

  let idempotencyKey_2 = common.genIdempotencyKey();

  let paymentToken_2 = activatePaymentNoticeV2(soapBaseUrl, rndAnagPsp, rndAnagPaNew, noticeNumber_2, idempotencyKey_2, "1");

  let idempotencyKey_3 = common.genIdempotencyKey();

  let paymentToken_3 = activatePaymentNoticeV2(soapBaseUrl, rndAnagPsp, rndAnagPaNew, noticeNumber_3, idempotencyKey_3, "1");

  let idempotencyKey_4 = common.genIdempotencyKey();

  let paymentToken_4 = activatePaymentNoticeV2(soapBaseUrl, rndAnagPsp, rndAnagPaNew, noticeNumber_4, idempotencyKey_4, "1");

  let idempotencyKey_5 = common.genIdempotencyKey();

  let paymentToken_5 = activatePaymentNoticeV2(soapBaseUrl, rndAnagPsp, rndAnagPaNew, noticeNumber_5, idempotencyKey_5, "1");

  closePaymentV2KO_esitoKO(restBaseUrl, rndAnagPsp, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, "OK", "09910087308786", "09910087308786", 1.0, 0.01)
}