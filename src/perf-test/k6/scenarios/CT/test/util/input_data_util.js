import papaparse from './papaparse.js';
import { SharedArray } from 'k6/data';

const csvAnagPsp = new SharedArray('PSP_data', function () {

	return papaparse.parse(open('../../../../data/anagraficaPSP_ALL.csv'), { header: true }).data;
});

const csvAnagPspv1 = new SharedArray('PSP_data_v1', function () {

	return papaparse.parse(open('../../../../data/anagraficaPSP_ALL_v1.csv'), { header: true }).data;
});

const csvAnagPa = new SharedArray('PA_data', function () {

	return papaparse.parse(open('../../../../data/anagraficaPA.csv'), { header: true }).data;
});

const csvAnagPaNew = new SharedArray('PA_data_new', function () {

	return papaparse.parse(open('../../../../data/anagraficaPANew.csv'), { header: true }).data;
});

const csvAnagPaNewVersPrim2 = new SharedArray('PA_data_new_VersPrim2', function () {

	return papaparse.parse(open('../../../../data/anagraficaPANewVersPrim2.csv'), { header: true }).data;
});

export function getAnagPsp() {
	let psp = csvAnagPsp[Math.floor(Math.random() * csvAnagPsp.length)];
	console.debug("PSP " + JSON.stringify(psp));
	return psp;
}

export function getAnagPspV1() {
	let psp = csvAnagPspv1[Math.floor(Math.random() * csvAnagPspv1.length)];
	console.debug("PSP " + JSON.stringify(psp));
	return psp;
}

export function getAnagPa() {
	let pa = csvAnagPa[Math.floor(Math.random() * csvAnagPa.length)];
	console.debug("PA " + JSON.stringify(pa));
	return pa;
}

export function getAnagPaNew() {
	let paNew = csvAnagPaNew[Math.floor(Math.random() * csvAnagPaNew.length)];
	console.debug("PA NEW " + JSON.stringify(paNew));
	return paNew;
}


export function getAnagPaNewVersPrim2() {
	let paNew = csvAnagPaNewVersPrim2[Math.floor(Math.random() * csvAnagPaNewVersPrim2.length)];
	console.debug("PA NEW " + JSON.stringify(paNew));
	return paNew;
}


