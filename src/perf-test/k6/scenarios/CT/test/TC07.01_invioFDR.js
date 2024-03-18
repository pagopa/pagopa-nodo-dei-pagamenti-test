import { check } from 'k6';
import { SharedArray } from 'k6/data';
import papaparse from './util/papaparse.js';
import * as common from '../../CommonScript.js';
import * as inputDataUtil from './util/input_data_util.js';
import * as nodoInviaFlussoRendicontazioneBig from './api/nodoInviaFlussoRendicontazioneBig.js';
import * as nodoInviaFlussoRendicontazioneSmall from './api/nodoInviaFlussoRendicontazioneSmall.js';

const csvBaseUrl = new SharedArray('baseUrl', function() {

	return papaparse.parse(open('../../../cfg/baseURL_Nodo.csv'), { header: true }).data;

});

export const getScalini = new SharedArray('scalini', function() {


	const f = JSON.parse(open('../../../cfg/' + `${__ENV.steps}` + '.json'));

	return f;
});

export const options = {

	scenarios: {
		total: {
			timeUnit: '1s',
			preAllocatedVUs: 1, // how large the initial pool of VUs would be
			executor: 'ramping-arrival-rate',
			//executor: 'ramping-vus',
			maxVUs: 1500,
			stages: [
				{ target: getScalini[0].Scalino_CT_1, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_1, duration: getScalini[0].Scalino_CT_TIME_1 + 's' },
				{ target: getScalini[0].Scalino_CT_2, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_2, duration: getScalini[0].Scalino_CT_TIME_2 + 's' },
				{ target: getScalini[0].Scalino_CT_3, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_3, duration: getScalini[0].Scalino_CT_TIME_3 + 's' },
				{ target: getScalini[0].Scalino_CT_4, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_4, duration: getScalini[0].Scalino_CT_TIME_4 + 's' },
				{ target: getScalini[0].Scalino_CT_5, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_5, duration: getScalini[0].Scalino_CT_TIME_5 + 's' },
				{ target: getScalini[0].Scalino_CT_6, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_6, duration: getScalini[0].Scalino_CT_TIME_6 + 's' },
				{ target: getScalini[0].Scalino_CT_7, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_7, duration: getScalini[0].Scalino_CT_TIME_7 + 's' },
				{ target: getScalini[0].Scalino_CT_8, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_8, duration: getScalini[0].Scalino_CT_TIME_8 + 's' },
				{ target: getScalini[0].Scalino_CT_9, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_9, duration: getScalini[0].Scalino_CT_TIME_9 + 's' },
				{ target: getScalini[0].Scalino_CT_10, duration: 0 + 's' },
				{ target: getScalini[0].Scalino_CT_10, duration: getScalini[0].Scalino_CT_TIME_10 + 's' }, //to uncomment
			],
			tags: { test_type: 'ALL' },
			exec: 'total',
		}

	},
	summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'p(99)', 'p(99.99)', 'p(100)', 'count'],
	discardResponseBodies: false,
	thresholds: {

		'http_req_duration{nodoInviaFlussoRendicontazioneBig:http_req_duration}': [],
		'http_req_duration{nodoInviaFlussoRendicontazioneSmall:http_req_duration}': [],
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
    total();
}

export function total() {

    let baseSoapUrl = "";
    let urls = csvBaseUrl;
    for (var key in urls) {
        if (urls[key].ENV == `${__ENV.env}`) {

            baseSoapUrl = urls[key].SOAP_BASEURL;
        }
    }
    let rndAnagPsp = inputDataUtil.getAnagPsp();
    let rndAnagPa = inputDataUtil.getAnagPa();
    
    const randomValue = Math.random(); // num between 0 and 1

    if (randomValue <= 0.7) { // 70 % 

        nodoInviaFlussoRendicontazioneBig.nodoInviaFlussoRendicontazioneBig(baseSoapUrl, rndAnagPsp.PSP, rndAnagPsp.CHPSP, rndAnagPsp.INTPSP, rndAnagPa.PA);
    } else {
        nodoInviaFlussoRendicontazioneSmall.nodoInviaFlussoRendicontazioneSmall(baseSoapUrl, rndAnagPsp.PSP, rndAnagPsp.CHPSP, rndAnagPsp.INTPSP, rndAnagPa.PA);
        
    }
    
}

export function handleSummary(data) {
    console.debug('Preparing the end-of-test summary...');

    return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)

}

export function checks(res, outcome, pattern) {

	check(res, {
		'ALL over_sla300': (r) => r.timings.duration > 300,
	},
		{ ALL: 'over_sla300' }
	);

	check(res, {
		'ALL over_sla400': (r) => r.timings.duration > 400,
	},
		{ ALL: 'over_sla400' }
	);

	check(res, {
		'ALL over_sla500': (r) => r.timings.duration > 500,
	},
		{ ALL: 'over_sla500' }
	);

	check(res, {
		'ALL over_sla600': (r) => r.timings.duration > 600,
	},
		{ ALL: 'over_sla600' }
	);

	check(res, {
		'ALL over_sla800': (r) => r.timings.duration > 800,
	},
		{ ALL: 'over_sla800' }
	);

	check(res, {
		'ALL over_sla1000': (r) => r.timings.duration > 1000,
	},
		{ ALL: 'over_sla1000' }
	);

	check(
		res,
		{
			//'ALL OK status': (r) => r.status == 200,
			'ALL OK status': (r) => outcome == pattern,
		},
		{ ALL: 'ok_rate' }
	);

	check(
		res,
		{
			//'ALL KO status': (r) => r.status !== 200,
			'ALL KO status': (r) => outcome !== pattern,
		},
		{ ALL: 'ko_rate' }
	);

}