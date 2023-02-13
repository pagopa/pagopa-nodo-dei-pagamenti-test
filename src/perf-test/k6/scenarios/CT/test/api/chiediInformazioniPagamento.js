import http from 'k6/http';
import { check, fail } from 'k6';
import { Trend } from 'k6/metrics';
import {getBasePath, getHeaders} from "../util/base_path_util.js";


export const chiediInformazioniPagamento_Trend = new Trend('chiediInformazioniPagamento');
export const All_Trend = new Trend('ALL');


export function chiediInformazioniPagamento(baseUrl,paymentToken, rndAnagPa) {

 const pathToCall = getBasePath(baseUrl, "nodoPerPMv1")+'/informazioniPagamento?idPagamento='
 let res=http.get(pathToCall+paymentToken,
    { headers: getHeaders({ 'Content-Type': 'application/json'/*, 'Host': 'api.prf.platform.pagopa.it'*/ }) ,
	tags: { chiediInformazioniPagamento: 'http_req_duration' , ALL: 'http_req_duration', name: pathToCall+"<idPagamento>"}
	}
  );
  
  console.debug("chiediInformazioniPagamento RES");
  console.debug(JSON.stringify(res));
  
  console.debug(JSON.stringify(res));
    chiediInformazioniPagamento_Trend.add(res.timings.duration);
    All_Trend.add(res.timings.duration);

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
   let jsonResponse = JSON.parse(res.body);
   ragioneSocialeExtr=jsonResponse.ragioneSociale;
   result.ragioneSocialeExtr=ragioneSocialeExtr;
   
   result.importoTotale = parseFloat(jsonResponse.importoTotale).toFixed(2);
   }catch(error){}

     console.debug("importoTotale: "+result.importoTotale);
     console.debug("ragionesociale---pa: "+ragioneSocialeExtr+"---"+ rndAnagPa.PA);
   
   check(
    res,
    {
      //'chiediInformazioniPagamento:ok_rate': (r) => outcome == 'OK',
	  'chiediInformazioniPagamento:ok_rate': (r) => ragioneSocialeExtr == pa,
    },
    { chiediInformazioniPagamento: 'ok_rate', ALL:'ok_rate' }
	);
	
	if(check(
    res,
    {
       //'chiediInformazioniPagamento:ko_rate': (r) => outcome !== 'OK',
	   'chiediInformazioniPagamento:ko_rate': (r) => ragioneSocialeExtr !== pa,
    },
    { chiediInformazioniPagamento: 'ko_rate', ALL:'ko_rate' }
  )){
	fail("ragioneSocialeExtr != pa: "+ragioneSocialeExtr);
}
   
     return result;
}
