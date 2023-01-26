import http from 'k6/http';
import { Trend } from 'k6/metrics';
import { check, fail } from 'k6';

export const checkPosition_5_Trend = new Trend('checkPosition_5');
export const All_Trend = new Trend('ALL');

export function checkPosition_5Body(noticeNumber_1, noticeNumber_2, noticeNumber_3, noticeNumber_4, noticeNumber_5) {
    return `{ "positionslist": [{ "fiscalCode": "00000000092", "noticeNumber": "${noticeNumber_1}" }, { "fiscalCode": "00000000092", "noticeNumber": "${noticeNumber_2}" }, { "fiscalCode": "00000000092", "noticeNumber": "${noticeNumber_3}" }, { "fiscalCode": "00000000092", "noticeNumber": "${noticeNumber_4}" }, { "fiscalCode": "00000000092", "noticeNumber": "${noticeNumber_5}" }] }`
};

export function checkPosition_5(restBaseUrl, noticeNumber_1, noticeNumber_2, noticeNumber_3, noticeNumber_4, noticeNumber_5) {

    let res = http.post(`${restBaseUrl}/checkPosition`,
        checkPosition_5Body(noticeNumber_1, noticeNumber_2, noticeNumber_3, noticeNumber_4, noticeNumber_5),
        {
            headers: { 'Content-Type': 'application/json' },
            tags: { checkPosition_5: 'http_req_duration', ALL: 'http_req_duration' }
        }
    );

    console.log("checkPosition_5 RES ##########");
    console.log(res);

    checkPosition_5_Trend.add(res.timings.duration);
    All_Trend.add(res.timings.duration);

    check(res, {
        'checkPosition_5:over_sla300': (r) => r.timings.duration > 300,
    },
        { checkPosition_5: 'over_sla300', ALL: 'over_sla300' }
    );

    check(res, {
        'checkPosition_5:over_sla400': (r) => r.timings.duration > 400,
    },
        { checkPosition_5: 'over_sla400', ALL: 'over_sla400' }
    );

    check(res, {
        'checkPosition_5:over_sla500 ': (r) => r.timings.duration > 500,
    },
        { checkPosition_5: 'over_sla500', ALL: 'over_sla500' }
    );

    check(res, {
        'checkPosition_5:over_sla600': (r) => r.timings.duration > 600,
    },
        { checkPosition_5: 'over_sla600', ALL: 'over_sla600' }
    );

    check(res, {
        'checkPosition_5:over_sla800': (r) => r.timings.duration > 800,
    },
        { checkPosition_5: 'over_sla800', ALL: 'over_sla800' }
    );

    check(res, {
        'checkPosition_5:over_sla1000': (r) => r.timings.duration > 1000,
    },
        { checkPosition_5: 'over_sla1000', ALL: 'over_sla1000' }
    );

    let result;

    try {

        let outcome = JSON.stringify(res.status)
        result = outcome.includes(200) ? "ok" : "check failed"
        console.log(result)

    } catch (error) {
        console.log(error)
    }

    check(
        res,
        {
            'checkPosition_5:ok_rate': (r) => result == 'ok',
        },
        { checkPosition_5: 'ok_rate', ALL: 'ok_rate' }
    );

    if (check(
        res,
        {
            'checkPosition_5:ko_rate': (r) => result !== 'ok',
        },
        { checkPosition_5: 'ko_rate', ALL: 'ko_rate' }
    )) {
        fail("Result != ok: " + result);
    }

}
