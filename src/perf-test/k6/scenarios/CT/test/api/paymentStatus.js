import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";

export const paymentStatus_Trend = new Trend('paymentStatus');
export const All_Trend = new Trend('ALL');

export function paymentStatusBody(caller, daysToGoBack) {
    return JSON.stringify({
        caller: caller,
        daysToGoBack: daysToGoBack
    });
}

export function paymentStatus(baseUrl, paymentToken, caller, daysToGoBack) {
    const url =
        getBasePath(baseUrl, "paymentStatus") +
        "?paymenttoken=" + paymentToken +
        "&caller=" + encodeURIComponent(caller) +
        "&daysToGoBack=" + encodeURIComponent(daysToGoBack);


    const res = http.get(url, {
        headers: getHeaders({ 'Content-Type': 'application/json' }),
        tags: { paymentStatus: 'http_req_duration', ALL: 'http_req_duration', primitiva: "paymentStatus" }
    });



    paymentStatus_Trend.add(res.timings.duration);
    All_Trend.add(res.timings.duration);

    check(res, {
        'paymentStatus:over_sla300': (r) => r.timings.duration > 300,
    },
        { paymentStatus: 'over_sla300', ALL: 'over_sla300' }
    );

    check(res, {
        'paymentStatus:over_sla400': (r) => r.timings.duration > 400,
    },
        { paymentStatus: 'over_sla400', ALL: 'over_sla400' }
    );

    check(res, {
        'paymentStatus:over_sla500': (r) => r.timings.duration > 500,
    },
        { paymentStatus: 'over_sla500', ALL: 'over_sla500' }
    );

    check(res, {
        'paymentStatus:over_sla600': (r) => r.timings.duration > 600,
    },
        { paymentStatus: 'over_sla600', ALL: 'over_sla600' }
    );

    check(res, {
        'paymentStatus:over_sla800': (r) => r.timings.duration > 800,
    },
        { paymentStatus: 'over_sla800', ALL: 'over_sla800' }
    );

    check(res, {
        'paymentStatus:over_sla1000': (r) => r.timings.duration > 1000,
    },
        { paymentStatus: 'over_sla1000', ALL: 'over_sla1000' }
    );

    let httpStatus = 0;
    try {
        httpStatus = res.status;
    } catch (error) {}

    check(
        res,
        {
            'paymentStatus:ok_rate': (r) => httpStatus === 200,
        },
        { paymentStatus: 'ok_rate', ALL: 'ok_rate' }
    );

    if (check(
        res,
        {
            'paymentStatus:ko_rate': (r) => httpStatus !== 200,
        },
        { paymentStatus: 'ko_rate', ALL: 'ko_rate' }
    )) {
        fail("paymentStatus status != 200: " + httpStatus);
    }

    return res;
}
