import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";

export const checkStatus_Trend = new Trend('checkStatus');
export const All_Trend = new Trend('ALL');

export function paymentStatusBody(caller, daysToGoBack) {
    return JSON.stringify({
        caller: caller,
        daysToGoBack: daysToGoBack
    });
}

export function paymentStatus(baseUrl, paymentToken, caller, daysToGoBack) {
    const url = getBasePath(baseUrl, "paymentStatus") + "?paymenttoken=" + paymentToken;
    const body = paymentStatusBody(caller, daysToGoBack);
    console.log(`[FLOW] checkStatus REQUEST url=${url} caller=${caller} daysToGoBack=${daysToGoBack}`);

    console.debug("paymentStatus URL: " + url);
    console.debug("paymentStatus BODY: " + body);

    const res = http.request(
        'GET',
        url,
        body,
        {
            headers: getHeaders({ 'Content-Type': 'application/json' }),
            tags: { checkStatus: 'http_req_duration', ALL: 'http_req_duration', primitiva: "checkStatus" }
        }
    );

    console.debug("paymentStatus RES");
    console.debug(JSON.stringify(res));

    checkStatus_Trend.add(res.timings.duration);
    All_Trend.add(res.timings.duration);

    check(res, {
        'checkStatus:over_sla300': (r) => r.timings.duration > 300,
    },
        { checkStatus: 'over_sla300', ALL: 'over_sla300' }
    );

    check(res, {
        'checkStatus:over_sla400': (r) => r.timings.duration > 400,
    },
        { checkStatus: 'over_sla400', ALL: 'over_sla400' }
    );

    check(res, {
        'checkStatus:over_sla500': (r) => r.timings.duration > 500,
    },
        { checkStatus: 'over_sla500', ALL: 'over_sla500' }
    );

    check(res, {
        'checkStatus:over_sla600': (r) => r.timings.duration > 600,
    },
        { checkStatus: 'over_sla600', ALL: 'over_sla600' }
    );

    check(res, {
        'checkStatus:over_sla800': (r) => r.timings.duration > 800,
    },
        { checkStatus: 'over_sla800', ALL: 'over_sla800' }
    );

    check(res, {
        'checkStatus:over_sla1000': (r) => r.timings.duration > 1000,
    },
        { checkStatus: 'over_sla1000', ALL: 'over_sla1000' }
    );

    let httpStatus = 0;
    try {
        httpStatus = res.status;
    } catch (error) {}
    console.log(`[FLOW] checkStatus RESPONSE status=${httpStatus}`);

    check(
        res,
        {
            'checkStatus:ok_rate': (r) => httpStatus === 200,
        },
        { checkStatus: 'ok_rate', ALL: 'ok_rate' }
    );

    if (check(
        res,
        {
            'checkStatus:ko_rate': (r) => httpStatus !== 200,
        },
        { checkStatus: 'ko_rate', ALL: 'ko_rate' }
    )) {
        fail("paymentStatus status != 200: " + httpStatus);
    }

    return res;
}
