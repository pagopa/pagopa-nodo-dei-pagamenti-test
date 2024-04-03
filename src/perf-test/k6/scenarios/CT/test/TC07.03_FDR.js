import { group } from 'k6';
import * as common from '../../CommonScript.js';
import scenario1 from './TC07.01_invioFDR.js';
import scenario2 from './TC07.02_richiestaFDR.js';


export const options = {
    summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'p(99)', 'p(99.99)', 'p(100)', 'count'],
    discardResponseBodies: false,
    thresholds: {

        'http_req_duration{nodoInviaFlussoRendicontazioneBig:http_req_duration}': [],
		'http_req_duration{nodoInviaFlussoRendicontazioneSmall:http_req_duration}': [],
		'http_req_duration{nodoChiediElencoFlussiRendicontazione:http_req_duration}': [],
		'http_req_duration{nodoChiediFlussoRendicontazione:http_req_duration}': [],
		'http_req_duration{ALL:http_req_duration}': [],
		'checks{nodoInviaFlussoRendicontazioneBig:over_sla300}': [],
		'checks{nodoInviaFlussoRendicontazioneBig:over_sla400}': [],
		'checks{nodoInviaFlussoRendicontazioneBig:over_sla500}': [],
		'checks{nodoInviaFlussoRendicontazioneBig:over_sla600}': [],
		'checks{nodoInviaFlussoRendicontazioneBig:over_sla800}': [],
		'checks{nodoInviaFlussoRendicontazioneBig:over_sla1000}': [],
		'checks{nodoInviaFlussoRendicontazioneBig:ok_rate}': [],
		'checks{nodoInviaFlussoRendicontazioneBig:ko_rate}': [],
		'checks{nodoInviaFlussoRendicontazioneSmall:over_sla300}': [],
		'checks{nodoInviaFlussoRendicontazioneSmall:over_sla400}': [],
		'checks{nodoInviaFlussoRendicontazioneSmall:over_sla500}': [],
		'checks{nodoInviaFlussoRendicontazioneSmall:over_sla600}': [],
		'checks{nodoInviaFlussoRendicontazioneSmall:over_sla800}': [],
		'checks{nodoInviaFlussoRendicontazioneSmall:over_sla1000}': [],
		'checks{nodoInviaFlussoRendicontazioneSmall:ok_rate}': [],
		'checks{nodoInviaFlussoRendicontazioneSmall:ko_rate}': [],
		'checks{nodoChiediElencoFlussiRendicontazione:over_sla300}': [],
		'checks{nodoChiediElencoFlussiRendicontazione:over_sla400}': [],
		'checks{nodoChiediElencoFlussiRendicontazione:over_sla500}': [],
		'checks{nodoChiediElencoFlussiRendicontazione:over_sla600}': [],
		'checks{nodoChiediElencoFlussiRendicontazione:over_sla800}': [],
		'checks{nodoChiediElencoFlussiRendicontazione:over_sla1000}': [],
		'checks{nodoChiediElencoFlussiRendicontazione:ok_rate}': [],
		'checks{nodoChiediElencoFlussiRendicontazione:ko_rate}': [],
		'checks{nodoChiediFlussoRendicontazione:over_sla300}': [],
		'checks{nodoChiediFlussoRendicontazione:over_sla400}': [],
		'checks{nodoChiediFlussoRendicontazione:over_sla500}': [],
		'checks{nodoChiediFlussoRendicontazione:over_sla600}': [],
		'checks{nodoChiediFlussoRendicontazione:over_sla800}': [],
		'checks{nodoChiediFlussoRendicontazione:over_sla1000}': [],
		'checks{nodoChiediFlussoRendicontazione:ok_rate}': [],
		'checks{nodoChiediFlussoRendicontazione:ko_rate}': [],
		'checks{ALL:over_sla300}': [],
		'checks{ALL:over_sla400}': [],
		'checks{ALL:over_sla500}': [],
		'checks{ALL:over_sla600}': [],
		'checks{ALL:over_sla800}': [],
		'checks{ALL:over_sla1000}': [],
		'checks{ALL:ok_rate}': [],
		'checks{ALL:ko_rate}': []
		
    },


};

export default function () {
    // Genera un numero casuale compreso tra 0 e 1
    const randomNumber = Math.random();


    if (randomNumber < 0.5) { //50%
        group('ScenarioMisto: scenario1', () => {
            scenario1();
        });
    } else { //50%
        group('ScenarioMisto: scenario2', () => {
            scenario2();
        });
    }
}

export function handleSummary(data) {
    console.debug('Preparing the end-of-test summary...');

    return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)

}
