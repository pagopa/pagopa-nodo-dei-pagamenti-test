import { group } from 'k6';
import scenario1 from './TC06.01_new_new.js';
import scenario2 from './TC06.02_new_old.js';
import scenario3 from './TC06.03_new_new.js';
import scenario4 from './TC06.04_new_old.js';

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
