import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { SharedArray } from 'k6/data';

const csvAnagPsp = new SharedArray('PSP_data', function () {
    
  return papaparse.parse(open('../../../../data/anagraficaPSP_ALL_SIT.csv'), { header: true }).data;
});

const csvAnagPa = new SharedArray('PA_data', function () {
	  
  return papaparse.parse(open('../../../../data/anagraficaPA_SIT.csv'), { header: true }).data;
});

const csvAnagPaNew = new SharedArray('PA_data_new', function () {
	  
  return papaparse.parse(open('../../../../data/anagraficaPA_NEW_SIT.csv'), { header: true }).data;
});

const csvAnagPaSit = new SharedArray('PA_data_sit', function () {
	  
  return papaparse.parse(open('../../../../data/anagraficaPA_SIT.csv'), { header: true }).data;
});

const csvAnagPaPerf = new SharedArray('PA_data_perf', function () {
	  
  return papaparse.parse(open('../../../../data/anagraficaPA_PERF.csv'), { header: true }).data;
});



export function getAnagPsp(){
	return csvAnagPsp[Math.floor(Math.random() * csvAnagPsp.length)];
}

export function getAnagPa(){
	return csvAnagPa[Math.floor(Math.random() * csvAnagPa.length)];
}

/*export function getAnagPaNew(){
	return csvAnagPaNew[Math.floor(Math.random() * csvAnagPaNew.length)];
*/	

/*export function getAnagPaNew(){
	return csvAnagPaSit[Math.floor(Math.random() * csvAnagPaPerf.length)];
}
} */

export function getAnagPaNew(){
	return csvAnagPaNew[Math.floor(Math.random() * csvAnagPaNew.length)];
}


