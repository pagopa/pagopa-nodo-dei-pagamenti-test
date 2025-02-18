import { group } from 'k6';
import TC0601_new_new from './TC06.01_new_new.js';
import TC0602_new_old from './TC06.02_new_old.js';
import TC0603_new_new from './TC06.03_new_new.js';
import TC0604_new_old from './TC06.04_new_old.js';
import { SharedArray } from 'k6/data';

export const getScalini = new SharedArray('scalini', function () {
	
  const f = JSON.parse(open('../../../cfg/'+`${__ENV.steps}`+'.json'));

  return f; 
});

export const options = {
  scenarios: {
    mixed_scenario: {
      preAllocatedVUs: 1, // how large the initial pool of VUs would be
          executor: 'ramping-arrival-rate',
          timeUnit: '4s',
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
           tags: { test_type: 'ALL', scenarioName: 'TC06.05_NMU_misto' }
    }
  }
};

export default function () {
    // Genera un numero casuale compreso tra 0 e 1
    const randomNumber = Math.random();


    if (randomNumber < 0.05) { //5%
        group('ScenarioMisto: TC0602_new_old', () => {
            TC0602_new_old();
        });
    } else if (randomNumber < 0.1) { //10 - 5 = 5%
        group('ScenarioMisto: TC0603_new_new', () => {
            TC0603_new_new();
        });
    } else if (randomNumber < 0.15) { // 15 - 5 - 5 = 5%
        group('ScenarioMisto: TC0604_new_old', () => {
            TC0604_new_old();
        });
    } else { //85%
        group('ScenarioMisto: TC0601_new_new', () => {
            TC0601_new_new();
        });
    }
}

export function handleSummary(data) {
    console.debug('Preparing the end-of-test summary...');

    return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)

}
