
export function extractData(data, type) {
   
  /*console.log(data.root_group.checks[0].name);
  console.log(data.root_group.checks[0].passes);
  console.log(data.metrics.http_req_duration.values);*/
  var eles = [];
  var prop = [];
  //console.log(data.metrics);
 
 let myJSON = JSON.stringify(data.metrics);
 //myJSON= myJSON.slice(1,-1);
 //console.log(myJSON);
 var json = JSON.parse(myJSON);
 
 var summary = [];  
 var trOverSla = [];
 var resultCodeSummary = [];
	
 for(let key of Object.keys(json)){
  //console.log(key);
  //console.log(json[key]);
  
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
	 
	   //console.log("name------"+name[0]);
	   rec.api = name[0];
	   rec.trNum = parseInt(obj.value.values.count);
	   rec.minEl = parseInt(obj.value.values.min);
	   rec.maxEl = parseInt(obj.value.values.max);
	   rec.avgEl = parseInt(obj.value.values.avg);
	   
	   //var str = JSON.stringify(rec);
	   //console.log(rec.api);
	   
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
	   //console.log(recResultCode.api);
	   
	   summary.push(rec);	
	   trOverSla.push(recSla);
	   resultCodeSummary.push(recResultCode);
  }
 
	  
 // let x = "'"+key+"'";
 // eles.push(key+":"+Object.values(json[key]));
}
/*for(let value of Object.values(json)){
  console.log(value);
  
 // eles.push(key+":"+Object.values(json[key]));
}*/
  /*console.log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
  console.log(trOverSla);
  console.log(resultCodeSummary);*/
 /* console.log(eles[1][1].values.avg);
  console.log(eles[0][0]);*/
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
	//console.log("dentro converter");
	
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
   
  //console.log("sorted="+JSON.stringify(jsonArr))

  const header = Object.keys(jsonArr[0]);
  let h = header.toString();
  //console.log(h);
 
 /* const replacer = (key, value) => value === null ? '' : value // specify how you want to handle null values here
  console.log(header);
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
 // console.log(str);
  return str;
    
}





export function ConvertToResultCodeCSV(jsonArray) {
	//console.log("dentro resultCode converter");
	
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
   
  //console.log("sorted="+JSON.stringify(jsonArr))
  
  let summary = [];  
  const rec1 = [];
  const rec2 = [];
  const header = [];
  header.push('Code');
  
 
  rec1.push("200_OK");
  rec2.push("Error");
  //console.log(rec1);
	
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
	//console.log(rec1);
	
	summary.push(rec1, rec2);
	//console.log(summary);
  
  
  let h = header.toString();
  //console.log(h);
 
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
  //console.log(str);
  return str;
    
}
	