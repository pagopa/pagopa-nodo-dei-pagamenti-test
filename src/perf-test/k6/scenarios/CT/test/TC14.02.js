import { group } from 'k6';
import TC0204 from './TC02.04.js';

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
          timeUnit: '3s',
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
           tags: { test_type: 'ALL', scenarioName: 'TC14.02' }
    }
  },
  summaryTrendStats: ['avg', 'min', 'max', 'p(90)', 'p(95)', 'p(99)', 'p(99.5)', 'p(99.9)', 'p(99.99)', 'p(100)', 'count']
};

export default function () {
    // Genera un numero casuale compreso tra 0 e 1
    const rand = Math.random()*100;
    let skipSpo = rand<=10;
    TC0204(skipSpo);
    
	
}