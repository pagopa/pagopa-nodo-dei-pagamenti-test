import { group } from 'k6';
import scenario1 from './TC02.03.js';
import scenario2 from './TC02.04.js';
import scenario3 from './TC03.05.js';
import scenario4 from './TC06.05_NMU_misto.js';

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
