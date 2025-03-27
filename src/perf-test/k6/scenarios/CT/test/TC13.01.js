import { group } from 'k6';
import TC0203 from './TC02.03.js';
import TC0204 from './TC02.04.js';
import TC0305 from './TC03.05.js';
import TC0306 from './TC03.06.js';
import TC0601_new_new from './TC06.01_new_new.js';
import TC0601_new_old from './TC06.01_new_old.js';
import TC0601_multi_nav from './TC06.01_multi_nav.js';
import TC0601_broadcast from './TC06.01_Broadcast.js';
import TC0601_MBD from './TC06.01_MBD.js';
import TC0602_new_new from './TC06.02_new_new.js';
import TC0603_new_old from './TC06.03_new_old.js';
import TC0604_new_new from './TC06.04_new_new.js';
import TC0604_new_old from './TC06.04_new_old.js';
import TC0801 from './TC08.01.js';
import TC0901 from './TC09.01.js';
import TC0902 from './TC09.02.js';
import TC1001 from './TC10.01.js';
import TC0603_new_new from './TC06.03_new_new.js';
import TC0602_new_old from './TC06.02_new_old.js';
import TC1201 from './TC12.01.js';
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
    const rand = Math.random()*100;

	if (rand < 0.01) { //0.01%
        group('ScenarioMisto: TC06.03_new_old', () => {
			TC0603_new_old();
        });
    } else if (rand < 0.02) { // 0.01%
        group('ScenarioMisto: TC06.04_new_old', () => {
			TC0604_new_old();
        });
    } else if (rand < 0.03) { // 0.01%
        group('ScenarioMisto: TC08.01', () => {
			TC0801();
        });
    } else if (rand < 0.19) { // 0.16%
        group('ScenarioMisto: TC09.02', () => {
			TC0902();
        });
    } else if (rand < 0.39) { // 0.2%
        group('ScenarioMisto: TC06.03_new_new', () => {
			TC0603_new_new();
        });
    } else if (rand < 0.59) { // 0.2%
        group('ScenarioMisto: TC06.04_new_new', () => {
			TC0604_new_new();
        });
    } else if (rand < 0.89) { // 0.3%
        group('ScenarioMisto: TC09.01', () => {
			TC0901();
        });
    } else if (rand < 1.21) { // 0.32%
        group('ScenarioMisto: TC06.01_MBD', () => {
			TC0601_MBD();
        });
    } else if (rand < 1.55) { // 0.34%
        group('ScenarioMisto: TC06.02_new_old', () => {
			TC0602_new_old();
        });
    } else if (rand < 2.30) { // 0.75%
        group('ScenarioMisto: TC06.01_broadcast', () => {
			TC0601_broadcast();
        });
    } else if (rand < 3.30) { // 1%
        group('ScenarioMisto: TC03.06', () => {
			TC0306();
        });
    } else if (rand < 4.30) { // 1%
        group('ScenarioMisto: TC06.01_new_old', () => {
			TC0601_new_old();
        });
    } else if (rand < 5.30) { // 1%
        group('ScenarioMisto: TC12.01', () => {
			TC1201();
        });
    } else if (rand < 6.33) { // 1.03%
        group('ScenarioMisto: TC10.01', () => {
			TC1001();
        });
    } else if (rand < 7.63) { // 1.3%
        group('ScenarioMisto: TC06.01_multi_nav', () => {
			TC0601_multi_nav();
        });
    } else if (rand < 9) { // 1.37%
        group('ScenarioMisto: TC02.03', () => {
			TC0203();
        });
    } else if (rand < 10.37) { // 1.37&
        group('ScenarioMisto: TC02.04', () => {
			TC0204();
        });
    } else if (rand < 18.15) { // 7.78%
        group('ScenarioMisto: TC06.02_new_new', () => {
			TC0602_new_new();
        });
    } else if (rand < 39.00) { // 20.85%
        group('ScenarioMisto: TC06.01_new_new', () => {
			TC0601_new_new();
        });
    } else { //61%
        group('ScenarioMisto: TC03.05', () => {
			TC0305();
        });
    }

}

export function handleSummary(data) {
    console.debug('Preparing the end-of-test summary...');

    return common.handleSummary(data, `${__ENV.outdir}`, `${__ENV.test}`)

}