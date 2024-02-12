import { check } from 'k6';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from './util/papaparse.js';
import { checkPosition } from './api/checkPosition.js';
import { activatePaymentNoticeV2 } from './api/activatePaymentNoticeV2.js';
import { closePaymentV2 } from './api/closePaymentV2.js';
import { sendPaymentOutcomeV2 } from './api/sendPaymentOutcomeV2.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';


const csvBaseUrl = new SharedArray('baseUrl', function () {

    return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;

});


const chars = '0123456789';
// NoticeNumber
export function genNoticeNumber() {
    let noticeNumber = '311';
    for (var i = 15; i > 0; --i) noticeNumber += chars[Math.floor(Math.random() * chars.length)];
    return noticeNumber;
}


export const getScalini = new SharedArray('scalini', function () {


    const f = JSON.parse(open('../../../cfg/' + `${__ENV.steps}` + '.json'));

    return f;
});

export const options = {

    scenarios: {
        total: {
            timeUnit: '4s',
            preAllocatedVUs: 1, // how large the initial pool of VUs would be
            executor: 'ramping-arrival-rate',
            //executor: 'ramping-vus',
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
                { target: getScalini[0].Scalino_CT_10, duration: getScalini[0].Scalino_CT_TIME_10 + 's' }, //to uncomment
            ],
            tags: { test_type: 'ALL' },
            exec: 'total',
        }

    },
    summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'count'],
    discardResponseBodies: false,
    thresholds: {

        'http_req_duration{checkPosition:http_req_duration}': [],
        'http_req_duration{activatePaymentNoticeV2:http_req_duration}': [],
        'http_req_duration{closePaymentV2:http_req_duration}': [],
        'http_req_duration{sendPaymentOutcomeV2:http_req_duration}': [],
        'http_req_duration{ALL:http_req_duration}': [],
        'checks{checkPosition:over_sla300}': [],
        'checks{checkPosition:over_sla400}': [],
        'checks{checkPosition:over_sla500}': [],
        'checks{checkPosition:over_sla600}': [],
        'checks{checkPosition:over_sla800}': [],
        'checks{checkPosition:over_sla1000}': [],
        'checks{checkPosition:ok_rate}': [],
        'checks{checkPosition:ko_rate}': [],
        'checks{activatePaymentNoticeV2:over_sla300}': [],
        'checks{activatePaymentNoticeV2:over_sla400}': [],
        'checks{activatePaymentNoticeV2:over_sla500}': [],
        'checks{activatePaymentNoticeV2:over_sla600}': [],
        'checks{activatePaymentNoticeV2:over_sla800}': [],
        'checks{activatePaymentNoticeV2:over_sla1000}': [],
        'checks{activatePaymentNoticeV2:ok_rate}': [],
        'checks{activatePaymentNoticeV2:ko_rate}': [],
        'checks{closePaymentV2:over_sla300}': [],
        'checks{closePaymentV2:over_sla400}': [],
        'checks{closePaymentV2:over_sla500}': [],
        'checks{closePaymentV2:over_sla600}': [],
        'checks{closePaymentV2:over_sla800}': [],
        'checks{closePaymentV2:over_sla1000}': [],
        'checks{closePaymentV2:ok_rate}': [],
        'checks{closePaymentV2:ko_rate}': [],
        'checks{sendPaymentOutcomeV2:over_sla300}': [],
        'checks{sendPaymentOutcomeV2:over_sla400}': [],
        'checks{sendPaymentOutcomeV2:over_sla500}': [],
        'checks{sendPaymentOutcomeV2:over_sla600}': [],
        'checks{sendPaymentOutcomeV2:over_sla800}': [],
        'checks{sendPaymentOutcomeV2:over_sla1000}': [],
        'checks{sendPaymentOutcomeV2:ok_rate}': [],
        'checks{sendPaymentOutcomeV2:ko_rate}': [],
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
    let baseRestUrl = "";
    let urls = csvBaseUrl;
    for (var key in urls) {
        if (urls[key].ENV == `${__ENV.env}`) {

            baseSoapUrl = urls[key].SOAP_BASEURL;
            baseRestUrl = urls[key].REST_BASEURL;
        }
    }
    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPaNew = inputDataUtil.getAnagPaNew();

    let noticeNmbr = genNoticeNumber();
    let idempotencyKey = genIdempotencyKey();

    res = checkPosition(baseSoapUrl, rndAnagPaNew, noticeNmbr);

    let res = activatePaymentNoticeV2(baseSoapUrl,rndAnagPsp,rndAnagPaNew,noticeNmbr,idempotencyKey);
    let paymentToken = res.paymentToken;

    let outcome = 'OK';
    res =  closePaymentV2(baseRestUrl,rndAnagPsp,paymentToken,outcome,"09910087308786","09910087308786", res.importoTotale);

    res = sendPaymentOutcomeV2(baseSoapUrl,rndAnagPsp,paymentToken);
}

export default function () {
    total();
}