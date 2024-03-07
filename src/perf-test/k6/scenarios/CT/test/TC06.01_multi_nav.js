import { check } from 'k6';
//import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { SharedArray } from 'k6/data';
import papaparse from './util/papaparse.js';
import { activatePaymentNoticeV2 } from './api/activatePaymentNoticeV2.js';
import { closePaymentV2_5Token } from './api/closePaymentV2_5Token.js';
import { sendPaymentOutcomeV2 } from './api/sendPaymentOutcomeV2.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';
import { sleep } from 'k6';


const csvBaseUrl = new SharedArray('baseUrl', function () {

    return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;

});


const chars = '0123456789';
// NoticeNumber
export function genNoticeNumber() {
    let noticeNumber = '312';
    for (var i = 15; i > 0; --i) noticeNumber += chars[Math.floor(Math.random() * chars.length)];
    return noticeNumber;
}

export function transaction_id() {
    let transactionId = ''
    for (var i = 8; i > 0; --i) transactionId += chars[Math.floor(Math.random() * chars.length)];
    return transactionId;
}


export function genIdempotencyKey() {
    let key1 = '';
    let key2 = Math.round((Math.pow(36, 10 + 1) - Math.random() * Math.pow(36, 10))).toString(36).slice(1);
    for (var i = 11; i > 0; --i) key1 += chars[Math.floor(Math.random() * chars.length)];
    let returnValue = key1 + "_" + key2;
    return returnValue;
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
    let rndAnagPaNew = inputDataUtil.getAnagPaNewVersPrim2();

    let noticeNmbr = genNoticeNumber();
    let idempotencyKey = genIdempotencyKey();
    let transactionId = transaction_id();
    let pspTransactionId = transaction_id();

    var res = activatePaymentNoticeV2(baseSoapUrl, rndAnagPsp, rndAnagPaNew, genNoticeNumber(), genIdempotencyKey(), "3_causale");
    let paymentToken = res.paymentToken;

    res = activatePaymentNoticeV2(baseSoapUrl, rndAnagPsp, rndAnagPaNew, genNoticeNumber(), genIdempotencyKey(), "3_causale");
    let secPaymentToken = res.paymentToken;

    res = activatePaymentNoticeV2(baseSoapUrl, rndAnagPsp, rndAnagPaNew, genNoticeNumber(), genIdempotencyKey(), "3_causale");
    let thirdPaymentToken = res.paymentToken;

    res = activatePaymentNoticeV2(baseSoapUrl, rndAnagPsp, rndAnagPaNew, genNoticeNumber(), genIdempotencyKey(), "3_causale");
    let fourthPaymentToken = res.paymentToken;

    res = activatePaymentNoticeV2(baseSoapUrl, rndAnagPsp, rndAnagPaNew, genNoticeNumber(), genIdempotencyKey(), "3_causale");
    let fifthPaymentToken = res.paymentToken;

    let outcome = 'OK';
    res = closePaymentV2_5Token(baseRestUrl, rndAnagPsp, paymentToken, secPaymentToken, thirdPaymentToken, fourthPaymentToken, fifthPaymentToken, outcome, transactionId, pspTransactionId, res.importoTotale);

    sleep(1);

    res = sendPaymentOutcomeV2(baseSoapUrl, rndAnagPsp, paymentToken);
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