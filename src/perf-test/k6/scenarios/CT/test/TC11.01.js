import { group } from 'k6';
import scenario1 from './TC02.03.js';
import scenario2 from './TC02.04.js';
import scenario3 from './TC03.05.js';
import scenario4 from './TC06.05_NMU_misto.js';
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
          maxVUs: 1500,
          timeUnit: '4s',
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
           tags: { test_type: 'ALL', scenarioName: 'TC11.01' }
    }
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
