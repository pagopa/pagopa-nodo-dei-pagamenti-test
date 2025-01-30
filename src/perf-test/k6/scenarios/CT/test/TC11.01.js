import { group } from 'k6';
import scenario1 from './TC02.03.js';
import scenario2 from './TC02.04.js';
import scenario3 from './TC03.05.js';
import scenario4 from './TC06.05_NMU_misto.js';

export const options = {
	
  thresholds: {
    // we can set different thresholds for the different scenarios because
    // of the extra metric tags we set!
    'http_req_duration{sendPaymentOutcome:http_req_duration}': [],
    // we can reference the scenario names as well
    'http_req_duration{activatePaymentNotice:http_req_duration}': [],
	'http_req_duration{RPT_Semplice_N3:http_req_duration}': [],
	'http_req_duration{ALL:http_req_duration}': [],
	'http_req_duration{sendPaymentOutcome_NN:http_req_duration}': [],
	'http_req_duration{activatePaymentNotice_NN:http_req_duration}': [],
	'http_req_duration{verifyPaymentNotice_NN:http_req_duration}': [],
	//'checks{webtest:ok_rate}': ['rate>0.85'],
	'checks{sendPaymentOutcome:over_sla300}': [],
	'checks{sendPaymentOutcome:over_sla400}': [],
	'checks{sendPaymentOutcome:over_sla500}': [],
	'checks{sendPaymentOutcome:over_sla600}': [],
	'checks{sendPaymentOutcome:over_sla800}': [],
	'checks{sendPaymentOutcome:over_sla1000}': [],
	'checks{sendPaymentOutcome:ok_rate}': [],
	'checks{sendPaymentOutcome:ko_rate}': [],
	'checks{sendPaymentOutcome_NN:over_sla300}': [],
	'checks{sendPaymentOutcome_NN:over_sla400}': [],
	'checks{sendPaymentOutcome_NN:over_sla500}': [],
	'checks{sendPaymentOutcome_NN:over_sla600}': [],
	'checks{sendPaymentOutcome_NN:over_sla800}': [],
	'checks{sendPaymentOutcome_NN:over_sla1000}': [],
	'checks{sendPaymentOutcome_NN:ok_rate}': [],
	'checks{sendPaymentOutcome_NN:ko_rate}': [],
	'checks{activatePaymentNotice:over_sla300}': [],
	'checks{activatePaymentNotice:over_sla400}': [],
	'checks{activatePaymentNotice:over_sla500}': [],
	'checks{activatePaymentNotice:over_sla600}': [],
	'checks{activatePaymentNotice:over_sla800}': [],
	'checks{activatePaymentNotice:over_sla1000}': [],
	'checks{activatePaymentNotice:ok_rate}': [],
	'checks{activatePaymentNotice:ko_rate}': [],
	'checks{activatePaymentNotice_NN:over_sla300}': [],
	'checks{activatePaymentNotice_NN:over_sla400}': [],
	'checks{activatePaymentNotice_NN:over_sla500}': [],
	'checks{activatePaymentNotice_NN:over_sla600}': [],
	'checks{activatePaymentNotice_NN:over_sla800}': [],
	'checks{activatePaymentNotice_NN:over_sla1000}': [],
	'checks{activatePaymentNotice_NN:ok_rate}': [],
	'checks{activatePaymentNotice_NN:ko_rate}': [],
	'checks{RPT_Semplice_N3:over_sla300}': [],
	'checks{RPT_Semplice_N3:over_sla400}': [],
	'checks{RPT_Semplice_N3:over_sla500}': [],
	'checks{RPT_Semplice_N3:over_sla600}': [],
	'checks{RPT_Semplice_N3:over_sla800}': [],
	'checks{RPT_Semplice_N3:over_sla1000}': [],
	'checks{RPT_Semplice_N3:ok_rate}': [],
	'checks{RPT_Semplice_N3:ko_rate}': [],
	'checks{verifyPaymentNotice_NN:over_sla300}': [],
	'checks{verifyPaymentNotice_NN:over_sla400}': [],
	'checks{verifyPaymentNotice_NN:over_sla500}': [],
	'checks{verifyPaymentNotice_NN:over_sla600}': [],
	'checks{verifyPaymentNotice_NN:over_sla800}': [],
	'checks{verifyPaymentNotice_NN:over_sla1000}': [],
	'checks{verifyPaymentNotice_NN:ok_rate}': [],
	'checks{verifyPaymentNotice_NN:ko_rate}': [],
	'checks{ALL:over_sla300}': [],
	'checks{ALL:over_sla400}': [],
	'checks{ALL:over_sla500}': [],
	'checks{ALL:over_sla600}': [],
	'checks{ALL:over_sla800}': [],
	'checks{ALL:over_sla1000}': [],
	'checks{ALL:ok_rate}': [],
	'checks{ALL:ko_rate}': [],
	}
   
  
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
