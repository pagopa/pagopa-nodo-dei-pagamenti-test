import http from 'k6/http';
import { check } from 'k6';

export function challengeReqBody(creq){

return 'creq='+creq
};

  
//export function ob_CC_Challenge(basePMUrl, creq) {
export function ob_CC_Challenge(basePMUrl, creq) { //in sit aggiungere acsUrl
 

 const res = http.post(
    basePMUrl+'/pmmockserviceapi/issuer/3ds2.0/challenge', //scommentare in perf
    //acsUrl, //commentare in perf
	challengeReqBody(creq),
    { headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Upgrade-Insecure-Requests': '1'},
	redirects: 0,
	tags: { ob_CC_Challenge: 'http_req_duration', ALL: 'http_req_duration'}
	}
  );
  
  check(res, {
 	'ob_CC_Challenge:over_sla300': (r) => r.timings.duration >300,
   },
   { ob_CC_Challenge: 'over_sla300' , ALL:'over_sla300'}
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla400': (r) => r.timings.duration >400,
   },
   { ob_CC_Challenge: 'over_sla400' , ALL:'over_sla400'}
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla500 ': (r) => r.timings.duration >500,
   },
   { ob_CC_Challenge: 'over_sla500', ALL:'over_sla500' }
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla600': (r) => r.timings.duration >600,
   },
   { ob_CC_Challenge: 'over_sla600' , ALL:'over_sla600'}
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla800': (r) => r.timings.duration >800,
   },
   { ob_CC_Challenge: 'over_sla800', ALL:'over_sla3800' }
   );
   
   check(res, {
 	'ob_CC_Challenge:over_sla1000': (r) => r.timings.duration >1000,
   },
   { ob_CC_Challenge: 'over_sla1000' , ALL:'over_sla1000'}
   );
  
    console.log(res);
   	let threedstransId = 'NA';
    let result={};
    result.threedstransId='NA';
    try{
    //let threeDSServerTransID =  new RegExp(`id="threeDSServerTransID">.*?<`); //to uncomment in perf
    let threeDSServerTransID =  new RegExp(`id="threeDSSessionData">.*?<`);
    let dsServTransId = threeDSServerTransID.exec(res);
    console.log('dsServTransId='+dsServTransId);
    let sl = dsServTransId.split('>');
    threedstransId = sl[1].replace('<','');
    result.threedstransId=threedstransId;
     }catch(err){}




   check(
    res,
    {
    
	 'ob_CC_Challenge:ok_rate': (r) =>  res.status == 200,
    },
    { ob_CC_Challenge: 'ok_rate', ALL:'ok_rate' }
	);
 
  check(
    res,
    {
     
	 'ob_CC_Challenge:ko_rate': (r) => res.status !== 200,
    },
    { ob_CC_Challenge: 'ko_rate', ALL:'ko_rate' }
  );
    
  return result;
}

