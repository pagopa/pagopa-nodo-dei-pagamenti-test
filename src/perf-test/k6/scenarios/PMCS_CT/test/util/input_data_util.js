import papaparse from 'https://jslib.k6.io/papaparse/5.1.1/index.js';
import { SharedArray } from 'k6/data';



const csvTokenIO_CC = new SharedArray('tokenIO_CC_data', function () {
    
  return papaparse.parse(open('../../../../data/tokenIOList.csv'), { header: true }).data;
});


const csvTokenIO_PP = new SharedArray('tokenIO_PP_data', function () {
    
  return papaparse.parse(open('../../../../data/tokenPP_OB.csv'), { header: true }).data;
});


const csvAnagPay_CC = new SharedArray('anagPayCC_data', function () {
    
  return papaparse.parse(open('../../../../data/anagPayCC.csv'), { header: true }).data;
});


const csvAnagPay_PP = new SharedArray('anagPayPP_data', function () {
    
  return papaparse.parse(open('../../../../data/anagPayPP.csv'), { header: true }).data;
});

/*
const csvPay_PP = new SharedArray('pay_PP_data', function () {
    
  return papaparse.parse(open('../../../../data/pay_PP.csv'), { header: true }).data;
});


const csvPay_CC = new SharedArray('pay_CC_data', function () {
    
  return papaparse.parse(open('../../../../data/pay_CC.csv'), { header: true }).data;
});*/

const csvPay = new SharedArray('pay_data', function () {
    
  return papaparse.parse(open('../../../../data/pay.csv'), { header: true }).data;
});


const csvCards = new SharedArray('cards_data', function () {
    
  return papaparse.parse(open('../../../../data/carte.csv'), { header: true }).data;
}); 






export function getCards(){
	return csvCards[Math.floor(Math.random() * csvCards.length)];
}

export function getTokenIO_CC(){ 
	return csvTokenIO_CC[Math.floor(Math.random() * csvTokenIO_CC.length)];
}

export function getTokenIO_PP(){
	return csvTokenIO_PP[Math.floor(Math.random() * csvTokenIO_PP.length)];
}

export function getAnagPay_CC(){
	return csvAnagPay_CC[Math.floor(Math.random() * csvAnagPay_CC.length)];
}

export function getAnagPay_PP(){
	return csvAnagPay_PP[Math.floor(Math.random() * csvAnagPay_PP.length)];
}

/*export function getPay_CC(){
	return csvPay_CC[Math.floor(Math.random() * csvPay_CC.length)];
}

export function getPay_PP(){
	return csvPay_PP[Math.floor(Math.random() * csvPay_PP.length)];
}
*/
export function getPay(){
	return csvPay[Math.floor(Math.random() * csvPay.length)];
}