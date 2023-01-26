import http from 'k6/http';
import { check, fail } from 'k6';
import { parseHTML } from "k6/html";
import { Trend } from 'k6/metrics';


export const activatePaymentNoticeV2_Trend = new Trend('activatePaymentNoticeV2');
export const All_Trend = new Trend('ALL');

export function activatePaymentNoticeV2ReqBody(psp, intpsp, chpsp, cfpa_n, noticeNumber, idempotencyKey, type) {
    if (type === "1") {
        return `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
    <soapenv:Header/>
    <soapenv:Body>
        <nod:activatePaymentNoticeV2Request>
            <idPSP>${psp}</idPSP>
            <idBrokerPSP>${intpsp}</idBrokerPSP>
            <idChannel>${chpsp}</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>${idempotencyKey}</idempotencyKey>
            <qrCode>
                <fiscalCode>${cfpa_n}</fiscalCode>
                <noticeNumber>${noticeNumber}</noticeNumber>
            </qrCode>
            <amount>2.00</amount>
            <dueDate>2056-01-26</dueDate>
            <paymentNote>2_M</paymentNote>
        </nod:activatePaymentNoticeV2Request>
    </soapenv:Body>
    </soapenv:Envelope>`}

    else if(type === "2"){
        return `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
           <nod:activatePaymentNoticeV2Request>
              <idPSP>${psp}</idPSP>
              <idBrokerPSP>${intpsp}</idBrokerPSP>
              <idChannel>${chpsp}</idChannel>
              <password>pwdpwdpwd</password>
              <idempotencyKey>${idempotencyKey}</idempotencyKey>
              <qrCode>
                 <fiscalCode>${cfpa_n}</fiscalCode>
                 <noticeNumber>${noticeNumber}</noticeNumber>
              </qrCode>
              <amount>2.00</amount>
              <dueDate>2056-01-26</dueDate>
              <paymentNote>2_M</paymentNote>
              <paymentMethod>PO</paymentMethod>
              <touchPoint>PSP</touchPoint>
           </nod:activatePaymentNoticeV2Request>
        </soapenv:Body>
     </soapenv:Envelope>`}

     else if(type === "3"){
        return `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
           <nod:activatePaymentNoticeV2Request>
              <idPSP>${psp}</idPSP>
              <idBrokerPSP>${intpsp}</idBrokerPSP>
              <idChannel>${chpsp}</idChannel>
              <password>pwdpwdpwd</password>
              <idempotencyKey>${idempotencyKey}</idempotencyKey>
              <qrCode>
                 <fiscalCode>${cfpa_n}</fiscalCode>
                 <noticeNumber>${noticeNumber}</noticeNumber>
              </qrCode>
              <amount>2.00</amount>
              <dueDate>2056-01-26</dueDate>
              <paymentNote>2_M</paymentNote>
              <paymentMethod>PO</paymentMethod>
              <touchPoint>ATM</touchPoint>
           </nod:activatePaymentNoticeV2Request>
        </soapenv:Body>
     </soapenv:Envelope>`}
    };

export function activatePaymentNoticeV2(baseUrl, rndAnagPsp, rndAnagPa, noticeNumber, idempotencyKey, type) {
    let body = activatePaymentNoticeV2ReqBody(rndAnagPsp.PSP, rndAnagPsp.INTPSP, rndAnagPsp.CHPSP, rndAnagPa.CF, noticeNumber, idempotencyKey, type);
    let res = http.post(baseUrl, body,
        {
            headers: { 'Content-Type': 'text/xml', 'SOAPAction': 'activatePaymentNoticeV2' },
            tags: { activatePaymentNoticeV2: 'http_req_duration', ALL: 'http_req_duration' }
        }
    );

    console.log("activatePaymentNoticeV2 RES ###########");
    console.log(res);

    activatePaymentNoticeV2_Trend.add(res.timings.duration);
    All_Trend.add(res.timings.duration);

    check(res, {
        'activatePaymentNoticeV2:over_sla300': (r) => r.timings.duration > 300,
    },
        { activatePaymentNoticeV2: 'over_sla300', ALL: 'over_sla300' }
    );

    check(res, {
        'activatePaymentNoticeV2:over_sla400': (r) => r.timings.duration > 400,
    },
        { activatePaymentNoticeV2: 'over_sla400', ALL: 'over_sla400' }
    );

    check(res, {
        'activatePaymentNoticeV2:over_sla500': (r) => r.timings.duration > 500,
    },
        { activatePaymentNoticeV2: 'over_sla500', ALL: 'over_sla600' }
    );

    check(res, {
        'activatePaymentNoticeV2:over_sla600': (r) => r.timings.duration > 600,
    },
        { activatePaymentNoticeV2: 'over_sla600', ALL: 'over_sla600' }
    );

    check(res, {
        'activatePaymentNoticeV2:over_sla800': (r) => r.timings.duration > 800,
    },
        { activatePaymentNoticeV2: 'over_sla800', ALL: 'over_sla800' }
    );

    check(res, {
        'activatePaymentNoticeV2:over_sla1000': (r) => r.timings.duration > 1000,
    },
        { activatePaymentNoticeV2: 'over_sla1000', ALL: 'over_sla1000' }
    );


    let outcome;
    let paymentToken;
    
    try {
        let doc = parseHTML(res.body);
        let script = doc.find('outcome');
        outcome = script.text();
        script = doc.find('paymentToken');
        paymentToken = script.text();
        console.log("activatePaymentNoticeV2 paymentToken: " + paymentToken);
    } catch (error) { 
        console.log(error)
    }

    check(
        res,
        {
            'activatePaymentNoticeV2:ok_rate': (r) => outcome == 'OK',
        },
        { activatePaymentNoticeV2: 'ok_rate', ALL: 'ok_rate' }
    );

    if (check(
        res,
        {
            'activatePaymentNoticeV2:ko_rate': (r) => outcome !== 'OK',
        },
        { activatePaymentNoticeV2: 'ko_rate', ALL: 'ko_rate' }
    )) {
        fail("Outcome != OK: " + outcome);
    }

    return paymentToken;

}