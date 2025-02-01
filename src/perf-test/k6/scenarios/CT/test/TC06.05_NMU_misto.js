import { group } from 'k6';
import { SharedArray } from 'k6/data';
import scenario1 from './TC06.01_new_new.js';
import scenario2 from './TC06.02_new_old.js';
import scenario3 from './TC06.03_new_new.js';
import scenario4 from './TC06.04_new_old.js';

export const getScalini = new SharedArray('scalini', function () {
	
	// here you can open files, and then do additional processing or generate the array with data dynamically
	const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));
	//console.debug(f);
	return f; // f must be an array[]
  });

export const options = {
  scenarios: {
        total: {
          timeUnit: '3s',
          preAllocatedVUs: 1, // how large the initial pool of VUs would be
          executor: 'ramping-arrival-rate',
          //executor: 'ramping-vus',
          maxVUs: 1500,
          stages: [
            { target: getScalini[0].Scalino_CT_1, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_1+'s' },
            { target: getScalini[0].Scalino_CT_2, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_2, duration: getScalini[0].Scalino_CT_TIME_2+'s' },
            { target: getScalini[0].Scalino_CT_3, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_3, duration: getScalini[0].Scalino_CT_TIME_3+'s' },
            { target: getScalini[0].Scalino_CT_4, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_4, duration: getScalini[0].Scalino_CT_TIME_4+'s' },
            { target: getScalini[0].Scalino_CT_5, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_5, duration: getScalini[0].Scalino_CT_TIME_5+'s' },
            { target: getScalini[0].Scalino_CT_6, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_6, duration: getScalini[0].Scalino_CT_TIME_6+'s' },
            { target: getScalini[0].Scalino_CT_7, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_7, duration: getScalini[0].Scalino_CT_TIME_7+'s' },
            { target: getScalini[0].Scalino_CT_8, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_8, duration: getScalini[0].Scalino_CT_TIME_8+'s' },
            { target: getScalini[0].Scalino_CT_9, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_9, duration: getScalini[0].Scalino_CT_TIME_9+'s' },
            { target: getScalini[0].Scalino_CT_10, duration: 0+'s' },
            { target: getScalini[0].Scalino_CT_10, duration: getScalini[0].Scalino_CT_TIME_10+'s' }, //to uncomment
           ],
          tags: { test_type: 'ALL', scenarioName: 'misto' },
          //exec: 'total',
        }

      },
    summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'p(99)', 'p(99.99)', 'p(100)', 'count'],
    discardResponseBodies: false,
    thresholds: {

        'http_req_duration{checkPosition:http_req_duration}': [],
        'http_req_duration{activatePaymentNoticeV2:http_req_duration}': [],
        'http_req_duration{closePaymentV2:http_req_duration}': [],
        'http_req_duration{sendPaymentOutcomeV2:http_req_duration}': [],
        'http_req_duration{RPT_Semplice_NMU:http_req_duration}': [],
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
        'checks{RPT_Semplice_NMU:over_sla300}': [],
        'checks{RPT_Semplice_NMU:over_sla400}': [],
        'checks{RPT_Semplice_NMU:over_sla500}': [],
        'checks{RPT_Semplice_NMU:over_sla600}': [],
        'checks{RPT_Semplice_NMU:over_sla800}': [],
        'checks{RPT_Semplice_NMU:over_sla1000}': [],
        'checks{RPT_Semplice_NMU:ok_rate}': [],
        'checks{RPT_Semplice_NMU:ko_rate}': [],
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

export default function () {
    // Genera un numero casuale compreso tra 0 e 1
    const randomNumber = Math.random();


    if (randomNumber < 0.1) { //10%
        group('ScenarioMisto: scenario1', () => {
            scenario4();
        });
    } else if (randomNumber < 0.25) { //15%
        group('ScenarioMisto: scenario2', () => {
            scenario3();
        });
    } else if (randomNumber < 0.5) { // 25%
        group('ScenarioMisto: scenario3', () => {
            scenario2();
        });
    } else { //50%
        group('ScenarioMisto: scenario4', () => {
            scenario1();
        });
    }
}

export function handleSummary(data) {
    console.debug('Preparing the end-of-test summary...');

    return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)

}
