import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";

export const checkPosition_Trend = new Trend('checkPosition');
export const All_Trend = new Trend('ALL');

export function checkPositionBody(cfpa, noticeNmbr) {
    return `
{
    "positionslist": [
        {
            "fiscalCode": "${cfpa}",
            "noticeNumber": "${noticeNmbr}"
        }
    ]
}
`
};

export function checkPosition(baseUrl, rndAnagPa, noticeNmbr) {

    console.log(checkPositionBody(rndAnagPa.CF, noticeNmbr));
    const res = http.post(
        getBasePath(baseUrl, "checkPosition"),
        checkPositionBody(rndAnagPa.CF, noticeNmbr),
        {
            headers: getHeaders({ 'Content-Type': 'text/xml', 'SOAPAction': 'checkPosition' }),
            tags: { checkPosition: 'http_req_duration', ALL: 'http_req_duration', primitiva: "checkPosition" }
        }
    );

    console.debug("checkPosition RES");
    console.debug(JSON.stringify(res));

    checkPosition_Trend.add(res.timings.duration);
    All_Trend.add(res.timings.duration);

    check(res, {
        'checkPosition:over_sla300': (r) => r.timings.duration > 300,
    },
        { checkPosition: 'over_sla300', ALL: 'over_sla300' }
    );

    check(res, {
        'checkPosition:over_sla400': (r) => r.timings.duration > 400,
    },
        { checkPosition: 'over_sla400', ALL: 'over_sla400' }
    );

    check(res, {
        'checkPosition:over_sla500 ': (r) => r.timings.duration > 500,
    },
        { checkPosition: 'over_sla500', ALL: 'over_sla500' }
    );

    check(res, {
        'checkPosition:over_sla600': (r) => r.timings.duration > 600,
    },
        { checkPosition: 'over_sla600', ALL: 'over_sla600' }
    );

    check(res, {
        'checkPosition:over_sla800': (r) => r.timings.duration > 800,
    },
        { checkPosition: 'over_sla800', ALL: 'over_sla800' }
    );

    check(res, {
        'checkPosition:over_sla1000': (r) => r.timings.duration > 1000,
    },
        { checkPosition: 'over_sla1000', ALL: 'over_sla1000' }
    );

    let outcome='';
    try{
    outcome= JSON.parse(res.body)["outcome"];
    }catch(error){}

    check(
        res,
        {
            'checkPosition:ok_rate': (r) => outcome == 'OK',
        },
        { checkPosition: 'ok_rate', ALL: 'ok_rate' }
    );

    if (check(
        res,
        {
            'checkPosition:ko_rate': (r) => outcome !== 'OK',
        },
        { checkPosition: 'ko_rate', ALL: 'ko_rate' }
    )) {
        fail("outcome != ok: " + outcome);
    }

    return res;

}

