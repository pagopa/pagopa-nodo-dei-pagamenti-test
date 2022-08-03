import http from 'k6/http';
import { check } from 'k6';
import { parseHTML } from "k6/html";


export function chiediInformazioniPagamento(baseUrl,paymentToken, rndAnagPa) {
 
 let res=http.get(baseUrl+'/informazioniPagamento?idPagamento='+paymentToken,
    { headers: { 'Content-Type': 'application/json', 'Host': 'api.dev.platform.pagopa.it' } ,
	tags: { chiediInformazioniPagamento: 'http_req_duration' , ALL: 'http_req_duration'}
	}
  );
  //console.log(res);
   check(res, {
 	'chiediInformazioniPagamento:over_sla300': (r) => r.timings.duration >300,
   },
   { chiediInformazioniPagamento: 'over_sla300', ALL:'over_sla300'  }
   );
   
   check(res, {
 	'chiediInformazioniPagamento:over_sla400': (r) => r.timings.duration >400,
   },
   { chiediInformazioniPagamento: 'over_sla400', ALL:'over_sla400'  }
   );
      
   check(res, {
 	'chiediInformazioniPagamento:over_sla500': (r) => r.timings.duration >500,
   },
   { chiediInformazioniPagamento: 'over_sla500', ALL:'over_sla500'  }
   );
   
   check(res, {
 	'chiediInformazioniPagamento:over_sla600': (r) => r.timings.duration >600,
   },
   { chiediInformazioniPagamento: 'over_sla600', ALL:'over_sla600'  }
   );
   
   check(res, {
 	'chiediInformazioniPagamento:over_sla800': (r) => r.timings.duration >800,
   },
   { chiediInformazioniPagamento: 'over_sla800' , ALL:'over_sla800' }
   );
   
   check(res, {
 	'chiediInformazioniPagamento:over_sla1000': (r) => r.timings.duration >1000,
   },
   { chiediInformazioniPagamento: 'over_sla1000' , ALL:'over_sla1000'}
   );
   
  /*const doc = parseHTML(res.body);
  const script = doc.find('outcome');
  const outcome = script.text();*/
  
 /* res={
        "id": "12123-24H-MADRID",
        "tariffModelId": "12123",
        "productId": "24H",
		 "ragioneSociale": "solemio srl",
        "origin": {
            "name": "MADRID",
            "regexpr": null,
            "code": "ES-M",
            "scales": null
		   
        }
   }; */
	 
   let ragioneSocialeExtr='';
   let pa=''
   let result={};
   result.ragioneSocialeExtr=ragioneSocialeExtr;
   try{
   pa = rndAnagPa.PA;
   ragioneSocialeExtr=res["ragioneSociale"];
   result.ragioneSocialeExtr=ragioneSocialeExtr;
   }catch(error){}

     console.log(ragioneSocialeExtr+"---"+ rndAnagPa.PA);
   // console.log("ragioneSocialeExtr="+ragioneSocialeExtr);
  // console.log(res.body);
  if(ragioneSocialeExtr!==pa){
   console.log("chiediInfoPagamento RESPONSE----------------"+res.body+"---"+rndAnagPa.PA);
  }

   
   check(
    res,
    {
      //'chiediInformazioniPagamento:ok_rate': (r) => outcome == 'OK',
	  'chiediInformazioniPagamento:ok_rate': (r) => ragioneSocialeExtr == pa,
    },
    { chiediInformazioniPagamento: 'ok_rate', ALL:'ok_rate' }
	);
	
	 check(
    res,
    {
       //'chiediInformazioniPagamento:ko_rate': (r) => outcome !== 'OK',
	   'chiediInformazioniPagamento:ko_rate': (r) => ragioneSocialeExtr !== pa,
    },
    { chiediInformazioniPagamento: 'ko_rate', ALL:'ko_rate' }
  );
   
     return result;
}