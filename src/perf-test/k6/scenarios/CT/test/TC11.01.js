import { group } from 'k6';
import { SharedArray } from 'k6/data';
// import {total as t1} from './TC02.03.js';

import scenario1 from './TC02.03.js';
import scenario2 from './TC02.04.js';
import scenario3 from './TC03.05.js';
import scenario4 from './TC06.05_NMU_misto.js';

// export function total() {
// }

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
	// we can set different thresholds for the different scenarios because
	// of the extra metric tags we set!
	'http_req_duration{sendPaymentOutcome:http_req_duration}': [],
	// we can reference the scenario names as well
	'http_req_duration{activatePaymentNotice:http_req_duration}': [],
	'http_req_duration{RPT_Semplice_N3:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	//'checks{webtest:ok_rate}': ['rate>0.85'],
	'checks{sendPaymentOutcome:over_sla300}': [],
	'checks{sendPaymentOutcome:over_sla400}': [],
	'checks{sendPaymentOutcome:over_sla500}': [],
	'checks{sendPaymentOutcome:over_sla600}': [],
	'checks{sendPaymentOutcome:over_sla800}': [],
	'checks{sendPaymentOutcome:over_sla1000}': [],
	'checks{sendPaymentOutcome:ok_rate}': [],
	'checks{sendPaymentOutcome:ko_rate}': [],
	'checks{activatePaymentNotice:over_sla300}': [],
	'checks{activatePaymentNotice:over_sla400}': [],
	'checks{activatePaymentNotice:over_sla500}': [],
	'checks{activatePaymentNotice:over_sla600}': [],
	'checks{activatePaymentNotice:over_sla800}': [],
	'checks{activatePaymentNotice:over_sla1000}': [],
	'checks{activatePaymentNotice:ok_rate}': [],
	'checks{activatePaymentNotice:ko_rate}': [],
	'checks{RPT_Semplice_N3:over_sla300}': [],
	'checks{RPT_Semplice_N3:over_sla400}': [],
	'checks{RPT_Semplice_N3:over_sla500}': [],
	'checks{RPT_Semplice_N3:over_sla600}': [],
	'checks{RPT_Semplice_N3:over_sla800}': [],
	'checks{RPT_Semplice_N3:over_sla1000}': [],
	'checks{RPT_Semplice_N3:ok_rate}': [],
	'checks{RPT_Semplice_N3:ko_rate}': [],
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

    // Utilizza la probabilità specificata per chiamare gli scenari appropriati
    if (randomNumber < 0.1) {
        group('ScenarioMisto: scenario1', () => {
            scenario1();
        });
    } else if (randomNumber < 0.2) {
        group('ScenarioMisto: scenario2', () => {
            scenario2();
        });
    } else if (randomNumber < 0.5) {
        group('ScenarioMisto: scenario3', () => {
            scenario3();
        });
    } else {
        group('ScenarioMisto: scenario4', () => {
            scenario4();
        });
    }
}
