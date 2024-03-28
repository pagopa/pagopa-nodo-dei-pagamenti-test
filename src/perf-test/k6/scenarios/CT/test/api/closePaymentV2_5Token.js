import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';
import { getBasePath, getHeaders } from "../util/base_path_util.js";

export const closePayment_Trend = new Trend('closePaymentV2');
export const All_Trend = new Trend('ALL');


export function closePaymentV2ReqBody(psp, intpsp, chpsp_c, paymentToken, secPaymentToken, thirdPaymentToken, fourthPaymentToken, fifthPaymentToken, outcome, transactionId, additionalTransactionId, totalAmount) {

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
      "${paymentToken}",
      "${secPaymentToken}",
      "${thirdPaymentToken}",
      "${fourthPaymentToken}",
      "${fifthPaymentToken}"
  ],
  "idPSP": "${psp}",
  "paymentMethod": "TPAY",
  "idBrokerPSP": "${intpsp}",
  "idChannel": "${chpsp_c}",
  "outcome": "${outcome}",
  "identificativoPsp": "${psp}",
  "tipoVersamento": "TPAY",
  "identificativoIntermediario": "${intpsp}",
  "identificativoCanale": "${chpsp_c}",
  "transactionId": "${transactionId}",
  "totalAmount": ${totalAmount},
  "fee": 0,
  "timestampOperation": "${dt}",
  "additionalPaymentInformations": {
      "transactionId": "${additionalTransactionId}",
      "spoMock": "true"
  }
}
`
};

export function closePaymentV2_5Token(baseUrl, rndAnagPsp, paymentToken, secPaymentToken, thirdPaymentToken, fourthPaymentToken, fifthPaymentToken, outcome, transactionId, additionalTransactionId, totalAmount) {
  /*
   var dt = new Date();
   let ms = dt.getMilliseconds();
  
   var timezone_offset_min = dt.getTimezoneOffset()-120,
      offset_hrs = parseInt(Math.abs(timezone_offset_min/60)),
      offset_min = Math.abs(timezone_offset_min%60),
      timezone_standard;
  
   if(offset_hrs < 10)
      offset_hrs = '0' + offset_hrs;
  
   if(offset_min < 10)
      offset_min = '0' + offset_min;
  
  
   if(timezone_offset_min < 0)
      timezone_standard = '+' + offset_hrs + ':' + offset_min;
   else if(timezone_offset_min > 0)
      timezone_standard = '-' + offset_hrs + ':' + offset_min;
   else if(timezone_offset_min == 0)
      timezone_standard = 'Z';
  
   //console.debug(timezone_standard);
  
   dt = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" +  ("0" + dt.getDate()).slice(-2) + "T" +
   ("0" + dt.getHours() ).slice(-2) + ":" + ("0" + dt.getMinutes()).slice(-2) + ":" + ("0" + dt.getSeconds()).slice(-2)+ "." + ms + timezone_standard;*/

  //let body = `{\"paymentTokens\":[\"${paymentToken}\"],\"outcome\":\"${outcome}\",\"idPSP\":\"${rndAnagPsp.PSP}\",\"idBrokerPSP\":\"${rndAnagPsp.INTPSP}\",\"idChannel\": \"${rndAnagPsp.CHPSP_C}\",\"paymentMethod\":\"TPAY\",\"transactionId\":\"${transactionId}\",\"totalAmount\":${totalAmount},\"fee\":0.00,\"timestampOperation\":\"${dt}\",\"additionalPaymentInformations\":{\"transactionId\":\"${additionalTransactionId}\",\"spoMockV2\":\"true\",\"esitoMock\":\"OK1SPO\"},\"additionalPMInfo\":{\"key\": \"value\"}}`;

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

  console.debug(closePaymentV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken, secPaymentToken, thirdPaymentToken, fourthPaymentToken, fifthPaymentToken, outcome, transactionId, additionalTransactionId, totalAmount));
  
  const res = http.post(
    getBasePath(baseUrl, "closePaymentV2"),
    //JSON.stringify(closePaymentV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken, outcome, transactionId, additionalTransactionId)),
    closePaymentV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP_C, paymentToken, secPaymentToken, thirdPaymentToken, fourthPaymentToken, fifthPaymentToken, outcome, transactionId, additionalTransactionId, totalAmount),
    {
      headers: getHeaders({ 'Content-Type': 'application/json' }),
      tags: { closePaymentV2: 'http_req_duration', ALL: 'http_req_duration', primitiva: "closePaymentV2" }
    }
  );

  console.debug("closePaymentV2ReqBody RES");
  console.debug(JSON.stringify(res));


  closePayment_Trend.add(res.timings.duration);
  All_Trend.add(res.timings.duration);


  check(res, {
    'closePaymentV2:over_sla300': (r) => r.timings.duration > 300,
  },
    { closePaymentV2: 'over_sla300', ALL: 'over_sla300' }
  );

  check(res, {
    'closePaymentV2:over_sla400': (r) => r.timings.duration > 400,
  },
    { closePaymentV2: 'over_sla400', ALL: 'over_sla400' }
  );

  check(res, {
    'closePaymentV2:over_sla500 ': (r) => r.timings.duration > 500,
  },
    { closePaymentV2: 'over_sla500', ALL: 'over_sla500' }
  );

  check(res, {
    'closePaymentV2:over_sla600': (r) => r.timings.duration > 600,
  },
    { closePaymentV2: 'over_sla600', ALL: 'over_sla600' }
  );

  check(res, {
    'closePaymentV2:over_sla800': (r) => r.timings.duration > 800,
  },
    { closePaymentV2: 'over_sla800', ALL: 'over_sla800' }
  );

  check(res, {
    'closePaymentV2:over_sla1000': (r) => r.timings.duration > 1000,
  },
    { closePaymentV2: 'over_sla1000', ALL: 'over_sla1000' }
  );


  let esito = '';
  try {
    esito = JSON.parse(res.body)["outcome"];
  } catch (error) { }


  check(
    res,
    {

      'closePaymentV2:ok_rate': (r) => esito == 'OK',
    },
    { closePaymentV2: 'ok_rate', ALL: 'ok_rate' }
  );

  if (check(
    res,
    {

      'closePaymentV2:ko_rate': (r) => esito !== 'OK',
    },
    { closePaymentV2: 'ko_rate', ALL: 'ko_rate' }
  )) {
    fail("esito != ok: " + esito);
  }

  return res;
}