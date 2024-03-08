import { jUnit, textSummary } from './CT/test/util/k6summary.js';
import { randomIntBetween, randomString } from './CT/test/util/k6utils.js';

export function handleSummary(data, path,test) {
  console.debug('Preparing the end-of-test summary...');
  console.debug('out path is '+ path);
  console.debug('out test is'+ test);
 
  var csv = extractData(data);
  let d = (new Date).toISOString().substr(0,10);
     
   return {
    'stdout': textSummary(data, { indent: ' ', enableColors: true, expected_response: 'ALL' }), // Show the text summary to stdout...
	[`${path}/${d}_${test}.summary.json`]: JSON.stringify(data), // and a JSON with all the details...
	//${path}/summary.html': htmlReport(data),
	[`${path}/${d}_${test}.summary.csv`]: csv[0],
	[`${path}/${d}_${test}.trOverSla.csv`]: csv[1],
	[`${path}/${d}_${test}.resultCodeSummary.csv`]: csv[2],
	[`${path}/${d}_${test}.junit.xml`]: jUnit(data),
	 	
  };
  
}


export function extractData(data, type) {
   
  /*console.debug(data.root_group.checks[0].name);
  console.debug(data.root_group.checks[0].passes);
  console.debug(data.metrics.http_req_duration.values);*/
  var eles = [];
  var prop = [];
  //console.debug(data.metrics);
 
 let myJSON = JSON.stringify(data.metrics);
 //myJSON= myJSON.slice(1,-1);
 //console.debug(myJSON);
 var json = JSON.parse(myJSON);
 
 var summary = [];  
 var trOverSla = [];
 var resultCodeSummary = [];
	
 for(let key of Object.keys(json)){
  //console.debug(key);
  //console.debug(json[key]);
  
   var rec = new Object();
   var recSla = new Object();
   var recResultCode = new Object();
   
  if (key.indexOf("http_req_duration{")==0 && key!="http_req_duration{expected_response:true}"){
	  var obj = new Object();
	  obj.key = key;
	  obj.value = json[key];
	 	  
	   var tmp=obj.key.split('{');
	   var nameTmp = tmp[1].slice(0,-1);
	   var name = nameTmp.split(':');
	  	 
	  
    for(var i = 0; i < summary.length; i++) {
		
      if (summary[i].api == name[0]) {
        rec = summary[i];
		summary.splice(i, 1); 
		
        break;
     }
     }
	 
	   //console.debug("name------"+name[0]);
	   rec.api = name[0];
	   rec.trNum = parseInt(obj.value.values.count);
	   rec.minEl = parseInt(obj.value.values.min);
	   rec.maxEl = parseInt(obj.value.values.max);
	   rec.avgEl = parseInt(obj.value.values.avg);
	   
	   //var str = JSON.stringify(rec);
	   //console.debug(rec.api);
	   
	   summary.push(rec);
	 
  }
  
  
  if(key.indexOf("checks{")==0 ){
	  var obj = new Object();
	  obj.key = key;
	  obj.value = json[key];
	  eles.push(obj);
	  
	   var tmp=obj.key.split('{');
	   var nameTmp = tmp[1].slice(0,-1);
	   var name = nameTmp.split(':');
	  
  	  
	 for(var i = 0; i < summary.length; i++) {
      if (summary[i].api == name[0]) {
        rec = summary[i];
				
        summary.splice(i, 1); 
		
        break;
     }
     }
	 
	 for(var i = 0; i < trOverSla.length; i++) {
      if (trOverSla[i].api == name[0]) {
        recSla = trOverSla[i];
				
        trOverSla.splice(i, 1); 
		
        break;
     }
     }
	 
	 for(var i = 0; i < resultCodeSummary.length; i++) {
      if (resultCodeSummary[i].api == name[0]) {
        recResultCode = resultCodeSummary[i];
				
        resultCodeSummary.splice(i, 1); 
		
        break;
     }
     }

   
	   rec.api = name[0];
	   recSla.api = name[0];
	   recResultCode.api = name[0];
	   	  
	   if(name[1]=='over_sla300'){
	
	   rec.trOverSla300 = obj.value.values.passes;
	   recSla.trOverSla300 = parseInt(obj.value.values.passes);
	   }
	   if(name[1]=='over_sla400'){
	
	    recSla.trOverSla400 = parseInt(obj.value.values.passes);
	   }
	   if(name[1]=='over_sla500'){
	
	    recSla.trOverSla500 = parseInt(obj.value.values.passes);
	   }
	   if(name[1]=='over_sla600'){
	
	    recSla.trOverSla600 = parseInt(obj.value.values.passes);
	   }
	   if(name[1]=='over_sla800'){
	
	    recSla.trOverSla800 = parseInt(obj.value.values.passes);
	   }
	   if(name[1]=='over_sla1000'){
	
	    recSla.trOverSla1000 = parseInt(obj.value.values.passes);
	   }
	   
       if(name[1]=='ok_rate'){
	       rec.percOK = parseFloat(obj.value.values.rate).toFixed(2);
	       rec.trOK =parseInt(obj.value.values.passes);
		   recResultCode.trOK = parseInt(obj.value.values.passes);
		}
	   
	   if(name[1]=='ko_rate'){
		   recResultCode.trKO = parseInt(obj.value.values.passes);
	   }
	   	   
	   //var str = JSON.stringify(rec);
	   //console.debug(recResultCode.api);
	   
	   summary.push(rec);	
	   trOverSla.push(recSla);
	   resultCodeSummary.push(recResultCode);
  }
 
	  
 // let x = "'"+key+"'";
 // eles.push(key+":"+Object.values(json[key]));
}
/*for(let value of Object.values(json)){
  console.debug(value);
  
 // eles.push(key+":"+Object.values(json[key]));
}*/
  /*console.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  console.debug(trOverSla);
  console.debug(resultCodeSummary);*/
 /* console.debug(eles[1][1].values.avg);
  console.debug(eles[0][0]);*/
 //return summary;
 var returnArray = []
 var csvsumm = ConvertToCSV(summary);
 var csvoversla = ConvertToCSV(trOverSla);
 var csvresultcode = ConvertToResultCodeCSV(resultCodeSummary);
 
 returnArray.push(csvsumm);
 returnArray.push(csvoversla);
 returnArray.push(csvresultcode);
  
 return returnArray;
 
}




export function ConvertToCSV(jsonArray) {
	//console.debug("dentro converter");
	
var jsonArr = [] 

for(var i = 0; i < jsonArray.length; i++) {
  const sorted = Object.keys(jsonArray[i])
  .sort()
  .reduce((accumulator, key) => {
    accumulator[key] = jsonArray[i][key];

    return accumulator;
  }, {});
     jsonArr.push(sorted);
      
 }
   
  //console.debug("sorted="+JSON.stringify(jsonArr))

  const header = Object.keys(jsonArr[0]);
  let h = header.toString();
  //console.debug(h);
 
 /* const replacer = (key, value) => value === null ? '' : value // specify how you want to handle null values here
  console.debug(header);
  const csv = [
  header.join(','), // header row first
  jsonArr.map(row => header.map(fieldName => JSON.stringify(row[fieldName], replacer)).join(',')
  )].join('\r\n');
  */
   var array = typeof jsonArr != 'object' ? JSON.parse(jsonArr) : jsonArr;

      var str = '';
	  	  
			var header_line = header+ ',';
			header_line.slice(0, header_line.Length - 1);
			str += header_line + '\r\n';
		

      for (var i = 0; i < array.length; i++) {
        var line = '';
		
		for (var index in array[i]) {
          line += array[i][index] + ',';
        }

        line.slice(0, line.Length - 1);
        str += line + '\r\n';
	  }
 // console.debug(str);
  return str;
    
}





export function ConvertToResultCodeCSV(jsonArray) {
	//console.debug("dentro resultCode converter");
	
var jsonArr = [] 

for(var i = 0; i < jsonArray.length; i++) {
  const sorted = Object.keys(jsonArray[i])
  .sort()
  .reduce((accumulator, key) => {
    accumulator[key] = jsonArray[i][key];

    return accumulator;
  }, {});
     jsonArr.push(sorted);
      
 }
   
  //console.debug("sorted="+JSON.stringify(jsonArr))
  
  let summary = [];  
  const rec1 = [];
  const rec2 = [];
  const header = [];
  header.push('Result Code');
  
 
  rec1.push("OK"); //200_OK
  rec2.push("KO"); //Error
  //console.debug(rec1);
	
	for (var i = 0; i < jsonArr.length; i++) {
		header.push(jsonArr[i].api);
		
		/*var property=jsonArr[i].api;
        var obj={};
        obj[property]=parseInt(jsonArr[i].trKO)*/
		
		rec2.push(parseInt(jsonArr[i].trKO));
		
		/*var property=jsonArr[i].api;
        var obj={};
        obj[property]=parseInt(jsonArr[i].trOK)*/
	    rec1.push(parseInt(jsonArr[i].trOK))
	}
	//console.debug(rec1);
	
	summary.push(rec1, rec2);
	//console.debug(summary);
  
  
  let h = header.toString();
  //console.debug(h);
 
  var array = typeof summary != 'object' ? JSON.parse(summary) : summary;

      var str = '';
	  	  
			var header_line = header+ ',';
			header_line.slice(0, header_line.Length - 1);
			str += header_line + '\r\n';
		

      for (var i = 0; i < array.length; i++) {
        var line = '';
		
		for (var index in array[i]) {
          line += JSON.stringify(array[i][index]) + ',';
        }

        line.slice(0, line.Length - 1);
        str += line + '\r\n';
	  }
  //console.debug(str);
  return str;
    
}

// Idempotency
export function genIdempotencyKey(){
	let key1 = randomIntBetween(10000000000, 99999999999);
	let key2 = randomString(10, `abcdefghijklmnopqrstuvwxyz0123456789`);
	/*const chars = '0123456789';
	let key1='';
	let key2 = Math.round((Math.pow(36, 10 + 1) - Math.random() * Math.pow(36, 10))).toString(36).slice(1);
	for (var i = 11; i > 0; --i) key1 += chars[Math.floor(Math.random() * chars.length)];
	let returnValue=key1+"_"+key2;*/
	let result = key1+"_"+key2;
	console.debug("genIdempotencyKey "+ result);
	return result;
}

export function transaction_id() {
    let transactionId = ''
    const chars = '0123456789';
    for (var i = 8; i > 0; --i) transactionId += chars[Math.floor(Math.random() * chars.length)];
    return transactionId;
}

export function transaction_idKO() {
  let transactionId = ''
  const chars = '0123456789';
  for (var i = 8; i > 0; --i) transactionId += chars[Math.floor(Math.random() * chars.length)];
  transactionId += "ko";
  return transactionId;
}
	