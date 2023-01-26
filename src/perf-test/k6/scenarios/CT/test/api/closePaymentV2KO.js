import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';

export const closePaymentV2KO_esitoKO_Trend = new Trend('closePaymentV2KO_esitoKO');
export const closePaymentV2KO_esitoKO_All = new Trend('ALL');

export function closePaymentV2KO_esitoKOBody(psp, intpsp, chpsp_c, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee) {

  let dt = new Date();
  let ms = dt.getMilliseconds();

  let timezone_offset_min = dt.getTimezoneOffset() - 120,
    offset_hrs = parseInt(Math.abs(timezone_offset_min / 60)),
    offset_min = Math.abs(timezone_offset_min % 60),
    timezone_standard;

  if (offset_hrs < 10)
    offset_hrs = '0' + offset_hrs;

  if (offset_min < 10)
    offset_min = '0' + offset_min;


  if (timezone_offset_min < 0)
    timezone_standard = '+' + offset_hrs + ':' + offset_min;
  else if (timezone_offset_min > 0)
    timezone_standard = '-' + offset_hrs + ':' + offset_min;
  else if (timezone_offset_min == 0)
    timezone_standard = 'Z';

  dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" + ("0" + dt.getDate()).slice(-2) + "T" +
    ("0" + dt.getHours()).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2) + "." + ms + timezone_standard;

  return `
    {"paymentTokens": [
      "${paymentToken_1}",
      "${paymentToken_2}",
      "${paymentToken_3}",
      "${paymentToken_4}",
      "${paymentToken_5}"
    ],
    "outcome": "OK",
    "idPSP": "${psp}",
    "idBrokerPSP": "${intpsp}",
    "idChannel": "${chpsp_c}",
    "paymentMethod": "TPAY",
    "transactionId": "${transactionId}",
    "totalAmount": ${totalAmount},
    "fee": ${fee},
    "timestampOperation": "${dt}",
    "additionalPaymentInformations": {
      "transactionId": "${additionalTransactionId}",
      "spoMockV2": "true",
      "esitoMock":"KO"
    },
    "additionalPMInfo": {
      "key": "value"
    }
  }
  `
};

export function closePaymentV2KO_esitoKO(restBaseUrl, rndAnagPsp, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee) {

  let res = http.post(restBaseUrl + '/v2/closepayment',
  closePaymentV2KO_esitoKOBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee)
    ,
    {
      headers: { 'Content-Type': 'application/json' },
      tags: { closePaymentV2KO_esitoKO: 'http_req_duration', ALL: 'http_req_duration' }
    }
  );

  console.log("closePaymentV2KO_esitoKO RES ###############");
  console.log(res);
  closePaymentV2KO_esitoKO_Trend.add(res.timings.duration);
  closePaymentV2KO_esitoKO_All.add(res.timings.duration);


  check(res, {
    'closePaymentV2KO_esitoKO:over_sla300': (r) => r.timings.duration > 300,
  },
    { closePaymentV2KO_esitoKO: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'closePaymentV2KO_esitoKO:over_sla400': (r) => r.timings.duration > 400,
  },
    { closePaymentV2KO_esitoKO: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'closePaymentV2KO_esitoKO:over_sla500 ': (r) => r.timings.duration > 500,
  },
    { closePaymentV2KO_esitoKO: 'over_sla500', ALL: 'over_sla500' }
  );

  check(res, {
    'closePaymentV2KO_esitoKO:over_sla600': (r) => r.timings.duration > 600,
  },
    { closePaymentV2KO_esitoKO: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'closePaymentV2KO_esitoKO:over_sla800': (r) => r.timings.duration > 800,
  },
    { closePaymentV2KO_esitoKO: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'closePaymentV2KO_esitoKO:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { closePaymentV2KO_esitoKO: 'over_sla1000', ALL: 'over_sla1000' }
  );

  let esito;

  try {
    esito = JSON.parse(res.body)["outcome"];
  } catch (error) {
    console.log(error)
  }

  check(
    res,
    {
      'closePaymentV2KO_esitoKO:ok_rate': (r) => esito == 'OK',
    },
    { closePaymentV2KO_esitoKO: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {

      'closePaymentV2KO_esitoKO:ko_rate': (r) => esito !== 'OK',
    },
    { closePaymentV2KO_esitoKO: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail("esito != ok: " + esito);
  }

}


export const closePaymentV2KO_errResp_Trend = new Trend('closePaymentV2KO_errResp');
export const closePaymentV2KO_errResp_All = new Trend('ALL');

export function closePaymentV2KO_errRespBody(psp, intpsp, chpsp_c, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee) {

  let dt = new Date();
  let ms = dt.getMilliseconds();

  let timezone_offset_min = dt.getTimezoneOffset() - 120,
    offset_hrs = parseInt(Math.abs(timezone_offset_min / 60)),
    offset_min = Math.abs(timezone_offset_min % 60),
    timezone_standard;

  if (offset_hrs < 10)
    offset_hrs = '0' + offset_hrs;

  if (offset_min < 10)
    offset_min = '0' + offset_min;


  if (timezone_offset_min < 0)
    timezone_standard = '+' + offset_hrs + ':' + offset_min;
  else if (timezone_offset_min > 0)
    timezone_standard = '-' + offset_hrs + ':' + offset_min;
  else if (timezone_offset_min == 0)
    timezone_standard = 'Z';

  dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" + ("0" + dt.getDate()).slice(-2) + "T" +
    ("0" + dt.getHours()).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2) + "." + ms + timezone_standard;

  return `
    {"paymentTokens": [
      "${paymentToken_1}",
      "${paymentToken_2}",
      "${paymentToken_3}",
      "${paymentToken_4}",
      "${paymentToken_5}"
    ],
    "outcome": "OK",
    "idPSP": "${psp}",
    "idBrokerPSP": "${intpsp}",
    "idChannel": "${chpsp_c}",
    "paymentMethod": "TPAY",
    "transactionId": "${transactionId}",
    "totalAmount": ${totalAmount},
    "fee": ${fee},
    "timestampOperation": "${dt}",
    "additionalPaymentInformations": {
      "transactionId": "${additionalTransactionId}",
      "spoMockV2": "true",
      "esitoMock":"ERR RESP"
    },
    "additionalPMInfo": {
      "key": "value"
    }
  }
  `
};

export function closePaymentV2KO_errResp(restBaseUrl, rndAnagPsp, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee) {

  let res = http.post(restBaseUrl + '/v2/closepayment',
  closePaymentV2KO_errRespBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee)
    ,
    {
      headers: { 'Content-Type': 'application/json' },
      tags: { closePaymentV2KO_errResp: 'http_req_duration', ALL: 'http_req_duration' }
    }
  );

  console.log("closePaymentV2KO_errResp RES ###############");
  console.log(res);
  closePaymentV2KO_errResp_Trend.add(res.timings.duration);
  closePaymentV2KO_errResp_All.add(res.timings.duration);


  check(res, {
    'closePaymentV2KO_errResp:over_sla300': (r) => r.timings.duration > 300,
  },
    { closePaymentV2KO_errResp: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'closePaymentV2KO_errResp:over_sla400': (r) => r.timings.duration > 400,
  },
    { closePaymentV2KO_errResp: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'closePaymentV2KO_errResp:over_sla500 ': (r) => r.timings.duration > 500,
  },
    { closePaymentV2KO_errResp: 'over_sla500', ALL: 'over_sla500' }
  );

  check(res, {
    'closePaymentV2KO_errResp:over_sla600': (r) => r.timings.duration > 600,
  },
    { closePaymentV2KO_errResp: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'closePaymentV2KO_errResp:over_sla800': (r) => r.timings.duration > 800,
  },
    { closePaymentV2KO_errResp: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'closePaymentV2KO_errResp:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { closePaymentV2KO_errResp: 'over_sla1000', ALL: 'over_sla1000' }
  );

  let esito;

  try {
    esito = JSON.parse(res.body)["outcome"];
  } catch (error) {
    console.log(error)
  }

  check(
    res,
    {
      'closePaymentV2KO_errResp:ok_rate': (r) => esito == 'OK',
    },
    { closePaymentV2KO_errResp: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {

      'closePaymentV2KO_errResp:ko_rate': (r) => esito !== 'OK',
    },
    { closePaymentV2KO_errResp: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail("esito != ok: " + esito);
  }

}