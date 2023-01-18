import http from 'k6/http';
import { check } from 'k6';

export function ob_CC_CheckOut(baseUrl, RED_Path) {
 
   
 const res = http.get(
    baseUrl+RED_Path,
   	{ headers: { 'Content-Type': 'application/x-www-form-urlencoded'} ,
	tags: { ob_CC_CheckOut: 'http_req_duration', ALL: 'http_req_duration'}
	}
	);
	
	
	check(res, {
 	'ob_CC_CheckOut:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_CheckOut: 'over_sla300' }
   );
   
   check(res, {
 	'ob_CC_CheckOut:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_CheckOut: 'over_sla400' }
   );
   
   check(res, {
 	'ob_CC_CheckOut:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_CheckOut: 'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_CheckOut:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_CheckOut: 'over_sla600' }
   );
   
   check(res, {
 	'ob_CC_CheckOut:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_CheckOut: 'over_sla800' }
   );
   
   check(res, {
 	'ob_CC_CheckOut:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_CheckOut: 'over_sla1000' }
   );
  
     
   //console.log(res);
   //let body=  `{"remote_ip":"193.203.229.107","remote_port":1444,"url":"https://acardste.vaservices.eu:1444","status":404,"status_text":"404 Not Found","proto":"HTTP/1.1","headers":{"Date":"Mon, 11 Jul 2022 10:13:57 GMT","X-Frame-Options":": DENY","X-Content-Type-Options":": nosniff","Referrer-Policy":"no-referrer-when-downgrade","Strict-Transport-Security":"max-age=31536000;includeSubDomains;preload","Content-Length":"74","Content-Type":"text/html"},"cookies":{},"body":"\u003chtml\u003e\u003chead\u003e\u003ctitle\u003eError\u003c/title\u003e\u003c/head\u003e\u003cbody\u003e404 - Not Found\u003c/body\u003e\u003c/html\u003e","timings":{"duration":34.9006,"blocked":200.8708,"looking_up":0,"connecting":64.4608,"tls_handshaking":136.41,"sending":0,"waiting":34.9006,"receiving":0},"tls_version":"tls1.2","tls_cipher_suite":"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA","ocsp":{"produced_at":0,"this_update":0,"next_update":0,"revoked_at":0,"revocation_reason":"","status":"unknown"},"error":"","error_code":1404,"request":{"method":"GET","url":"https://acardste.vaservices.eu:1444","headers":{"User-Agent":["k6/0.38.3 (https://k6.io/)"],"Content-Type":["application/x-www-form-urlencoded"],"Cookie":["SRVSQCK=prf-agid01|Ysv36"]},"body":"","cookies":{"SRVSQCK":[{"name":"SRVSQCK","value":"prf-agid01|Ysv36","replace":false}]}}}`; 
   //let regexTransId = `id="transactionId" value="(.*)"`;
   let idTr='NA';
   let regexTransId =  new RegExp(`id="transactionId" value=".*?"`);
   try{
   let idTr1 = regexTransId.exec(res);
   //console.log(idTr1);
   let sl = idTr1.split('="');
   idTr = sl[1].replace('"','');
   }catch(err){idTr='NA';}
   //console.log('dopo try-catch='+idTr);
   //console.log(idTr);
	 
   check(
    res,
    {
    
	 'ob_CC_CheckOut:ok_rate': (r) =>  idTr !== 'NA',
    },
    { ob_CC_CheckOut: 'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_CheckOut:ko_rate': (r) => idTr == 'NA',
    },
    { ob_CC_CheckOut: 'ko_rate' }
  );
  
  
  
  return res;
   
}

