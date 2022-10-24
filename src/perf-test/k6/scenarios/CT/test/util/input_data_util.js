import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { SharedArray } from 'k6/data';

const csvAnagPsp = new SharedArray('PSP_data', function () {
    
  return papaparse.parse(open('../../../../data/anagraficaPSP_ALL.csv'), { header: true }).data;
});

const csvAnagPa = new SharedArray('PA_data', function () {
	  
  return papaparse.parse(open('../../../../data/anagraficaPA.csv'), { header: true }).data;
});

const csvAnagPaNew = new SharedArray('PA_data_new', function () {
	  
  return papaparse.parse(open('../../../../data/anagraficaPANew.csv'), { header: true }).data;
});

export function getAnagPsp(){
	let psp = csvAnagPsp[Math.floor(Math.random() * csvAnagPsp.length)];
	console.debug("PSP "+ JSON.stringify(psp));
	return psp;
}

export function getAnagPa(){
	let pa = csvAnagPa[Math.floor(Math.random() * csvAnagPa.length)];
	console.debug("PA "+ JSON.stringify(pa));
	return pa;
}

export function getAnagPaNew(){
	let paNew = csvAnagPaNew[Math.floor(Math.random() * csvAnagPaNew.length)];
	console.debug("PA NEW "+ JSON.stringify(paNew));
	return paNew;
}


