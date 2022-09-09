import * as outputUtil from './util/output_util.js';
import { jUnit, textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';
export function handleSummary(data, path) {
  console.log('Preparing the end-of-test summary...');
  console.log('out path is '+ path);
 
  var csv = outputUtil.extractData(data);
  let d = (new Date).toISOString().substr(0,10);
     
   return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true, expected_response: 'ALL' }), // Show the text summary to stdout...
	[`${path}/${d}_TC01.02.summary.json`]: JSON.stringify(data), // and a JSON with all the details...
	//${path}/summary.html': htmlReport(data),
	[`${path}/${d}_TC01.02.summary.csv`]: csv[0],
	[`${path}/${d}_TC01.02.trOverSla.csv`]: csv[1],
	[`${path}/${d}_TC01.02.resultCodeSummary.csv`]: csv[2],
	 	
  };
  
}