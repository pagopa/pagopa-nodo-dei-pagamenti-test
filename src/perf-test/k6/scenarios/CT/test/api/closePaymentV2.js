import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';


export const closePayment_Trend = new Trend('closePayment');
export const All_Trend = new Trend('ALL');


export function closePaymentReqBody(psp, intpsp, chpsp_c, paymentToken, outcome, transactionId, additionalTransactionId) {

  var dt = new Date();
  let ms = dt.getMilliseconds();

  var timezone_offset_min = dt.getTimezoneOffset() - 120,
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

  //console.debug(timezone_standard); 

  dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" + ("0" + dt.getDate()).slice(-2) + "T" +
    ("0" + dt.getHours()).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2) + "." + ms + timezone_standard;

  return `
{
  "paymentTokens": [
    "${paymentToken}"
  ],
  "outcome": "outcome",
  "identificativoPsp": "${psp}",
  "tipoVersamento": "TPAY",
  "identificativoIntermediario": "${intpsp}",
  "identificativoCanale": "${chpsp_c}",
  "transactionId": "${transactionId}",
  "totalAmount": 1.0,
  "fee": 1.0,
  "timestampOperation": "${dt}",
  "additionalPaymentInformations": {
  "transactionId": "${additionalTransactionId}", //09910087308786 o 99910087308786
  "spoMock": "true"
  }
}
`
};

export function closePayment(baseUrl, rndAnagPsp, paymentToken, outcome, transactionId, additionalTransactionId, totalAmount) {

  var dt = new Date();
  let ms = dt.getMilliseconds();

  var timezone_offset_min = dt.getTimezoneOffset() - 120,
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

  //console.debug(timezone_standard);

  dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" + ("0" + dt.getDate()).slice(-2) + "T" +
    ("0" + dt.getHours()).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2) + "." + ms + timezone_standard;

  let body = `{\"paymentTokens\":[\"${paymentToken}\"],\"outcome\":\"${outcome}\",\"idPSP\":\"${rndAnagPsp.PSP}\",\"idBrokerPSP\":\"${rndAnagPsp.INTPSP}\",\"idChannel\": \"${rndAnagPsp.CHPSP_C}\",\"paymentMethod\":\"TPAY\",\"transactionId\":\"${transactionId}\",\"totalAmount\":${totalAmount},\"fee\":0.00,\"timestampOperation\":\"${dt}\",\"additionalPaymentInformations\":{\"transactionId\":\"${additionalTransactionId}\",\"spoMockV2\":\"true\",\"esitoMock\":\"OK1SPO\"},\"additionalPMInfo\":{\"key\": \"value\"}}`;

  /*
  let body=  {
                "paymentTokens": [
                  paymentToken
                ],
                "outcome": outcome,
                "identificativoPsp": rndAnagPsp.PSP,
                "tipoVersamento": "TPAY",
                "identificativoIntermediario": rndAnagPsp.INTPSP,
                "identificativoCanale": rndAnagPsp.CHPSP_C,
                "transactionId": transactionId,
                "totalAmount": 1.0,
                "fee": 1.0,
                "timestampOperation": dt,
                "additionalPaymentInformations": {
                "transactionId": additionalTransactionId, //09910087308786 o 99910087308786
                "spoMock": "true"
                }
              };*/


  const res = http.post(
    'https://nodo-dei-pagamenti-prf-npa-nodopagamenti.tst-npc.sia.eu/azurept2' + '/v2/closepayment',
    //JSON.stringify(closePaymentReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken, outcome, transactionId, additionalTransactionId)),
    body,
    {
      headers: { 'Content-Type': 'application/json' },
      tags: { closePayment: 'http_req_duration', ALL: 'http_req_duration' }
    }
  );

  console.debug("closePaymentV2 RES");
  console.debug(res);


  closePayment_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);


  check(res, {
    'closePayment:over_sla300': (r) => r.timings.duration > 300,
  },
    { closePayment: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'closePayment:over_sla400': (r) => r.timings.duration > 400,
  },
    { closePayment: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'closePayment:over_sla500 ': (r) => r.timings.duration > 500,
  },
    { closePayment: 'over_sla500', ALL: 'over_sla500' }
  );

  check(res, {
    'closePayment:over_sla600': (r) => r.timings.duration > 600,
  },
    { closePayment: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'closePayment:over_sla800': (r) => r.timings.duration > 800,
  },
    { closePayment: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'closePayment:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { closePayment: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let esito = '';
  try {
    esito = JSON.parse(res.body)["outcome"];
  } catch (error) { }


  check(
    res,
    {

      'closePayment:ok_rate': (r) => esito == 'OK',
    },
    { closePayment: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {

      'closePayment:ko_rate': (r) => esito !== 'OK',
    },
    { closePayment: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail("esito != ok: " + esito);
  }

  return res;

}

export const closePaymentV2_5_Trend = new Trend('closePaymentV2_5');
export const closePaymentV2_5_All = new Trend('ALL');

export function closePaymentV2_5ReqBody(psp, intpsp, chpsp_c, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee) {

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
      "esitoMock":"OK"
    },
    "additionalPMInfo": {
      "key": "value"
    }
  }
  `
};

export function closePaymentV2_5(restBaseUrl, rndAnagPsp, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee) {

  let res = http.post(restBaseUrl + '/v2/closepayment',
    closePaymentV2_5ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken_1, paymentToken_2, paymentToken_3, paymentToken_4, paymentToken_5, transactionId, additionalTransactionId, totalAmount, fee)
    ,
    {
      headers: { 'Content-Type': 'application/json' },
      tags: { closePaymentV2_5: 'http_req_duration', ALL: 'http_req_duration' }
    }
  );

  console.log("closePaymentV2_5 RES ###############");
  console.log(res);
  closePaymentV2_5_Trend.add(res.timings.duration);
  closePaymentV2_5_All.add(res.timings.duration);


  check(res, {
    'closePaymentV2_5:over_sla300': (r) => r.timings.duration > 300,
  },
    { closePaymentV2_5: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'closePaymentV2_5:over_sla400': (r) => r.timings.duration > 400,
  },
    { closePaymentV2_5: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'closePaymentV2_5:over_sla500 ': (r) => r.timings.duration > 500,
  },
    { closePaymentV2_5: 'over_sla500', ALL: 'over_sla500' }
  );

  check(res, {
    'closePaymentV2_5:over_sla600': (r) => r.timings.duration > 600,
  },
    { closePaymentV2_5: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'closePaymentV2_5:over_sla800': (r) => r.timings.duration > 800,
  },
    { closePaymentV2_5: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'closePaymentV2_5:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { closePaymentV2_5: 'over_sla1000', ALL: 'over_sla1000' }
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
      'closePaymentV2_5:ok_rate': (r) => esito == 'OK',
    },
    { closePaymentV2_5: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {

      'closePaymentV2_5:ko_rate': (r) => esito !== 'OK',
    },
    { closePaymentV2_5: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail("esito != ok: " + esito);
  }

}


export const closePaymentV2_2_Trend = new Trend('closePaymentV2_2');
export const closePaymentV2_2_All = new Trend('ALL');

export function closePaymentV2_2ReqBody(psp, intpsp, chpsp_c, paymentToken_1, paymentToken_2, transactionId, additionalTransactionId, totalAmount, fee) {

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
      "${paymentToken_2}"
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
      "esitoMock":"OK"
    },
    "additionalPMInfo": {
      "key": "value"
    }
  }
  `
};

export function closePaymentV2_2(restBaseUrl, rndAnagPsp, paymentToken_1, paymentToken_2, transactionId, additionalTransactionId, totalAmount, fee) {

  let res = http.post(restBaseUrl + '/v2/closepayment',
    closePaymentV2_5ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken_1, paymentToken_2, transactionId, additionalTransactionId, totalAmount, fee)
    ,
    {
      headers: { 'Content-Type': 'application/json' },
      tags: { closePaymentV2_2: 'http_req_duration', ALL: 'http_req_duration' }
    }
  );

  console.log("closePaymentV2_2 RES ###############");
  console.log(res);
  closePaymentV2_2_Trend.add(res.timings.duration);
  closePaymentV2_2_All.add(res.timings.duration);


  check(res, {
    'closePaymentV2_2:over_sla300': (r) => r.timings.duration > 300,
  },
    { closePaymentV2_2: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'closePaymentV2_2:over_sla400': (r) => r.timings.duration > 400,
  },
    { closePaymentV2_2: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'closePaymentV2_2:over_sla500 ': (r) => r.timings.duration > 500,
  },
    { closePaymentV2_2: 'over_sla500', ALL: 'over_sla500' }
  );

  check(res, {
    'closePaymentV2_2:over_sla600': (r) => r.timings.duration > 600,
  },
    { closePaymentV2_2: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'closePaymentV2_2:over_sla800': (r) => r.timings.duration > 800,
  },
    { closePaymentV2_2: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'closePaymentV2_2:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { closePaymentV2_2: 'over_sla1000', ALL: 'over_sla1000' }
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
      'closePaymentV2_2:ok_rate': (r) => esito == 'OK',
    },
    { closePaymentV2_2: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {
      'closePaymentV2_2:ko_rate': (r) => esito !== 'OK',
    },
    { closePaymentV2_2: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail("esito != ok: " + esito);
  }

}

