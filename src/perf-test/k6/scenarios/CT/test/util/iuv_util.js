const chars = '0123456789';

export function genIuv(){
	
	//let iuv = Math.random()*100000000000000000;
	//iuv = iuv.toString().split('.')[0];
	let iuv='';
	for (var i = 17; i > 0; --i) iuv += chars[Math.floor(Math.random() * chars.length)];
	let user ="";
	let returnValue=user+iuv;
    return returnValue;

}


export function genIuvArray(l){
	
var iuvArray = [];
/*let user = Math.random()*10000;
	user = user.toString().split('.')[0];*/
	let user='';
	for (var i = 4; i > 0; --i) user += chars[Math.floor(Math.random() * chars.length)];
	var dt = new Date();
	let ms = dt.getMilliseconds();
	
	dt = dt.getFullYear() + ("0" + (dt.getMonth() + 1)).slice(-2) + ("0" + dt.getDate()).slice(-2) + 
	("0" + dt.getHours() ).slice(-2) + ("0" + dt.getMinutes()).slice(-2) + ("0" + dt.getSeconds()).slice(-2)+ ms;

let iuv = "";	
//console.debug(dt+"------"+user);
for(let i = 0; i < l; i++){
  iuv = "P" + i;
  iuv += user; 
  iuv += makeid(3);
  iuv += "_";
  iuv += dt;
  iuvArray.push(iuv);

}

return iuvArray;

}


function makeid(length) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() *  charactersLength));
   }
   return result;
}

export function genIuvSemplice(){
    let iuv ="P_";
	let user='';
	for (var i = 4; i > 0; --i) user += chars[Math.floor(Math.random() * chars.length)];
	iuv += user; 
	iuv += makeid(3);
	iuv += "_";
	var dt = new Date();
	let ms = dt.getMilliseconds();
	
	dt = dt.getFullYear() + ("0" + (dt.getMonth() + 1)).slice(-2) + ("0" + dt.getDate()).slice(-2) + 
	("0" + dt.getHours() ).slice(-2) + ("0" + dt.getMinutes()).slice(-2) + ("0" + dt.getSeconds()).slice(-2)+ ms;
		
	iuv += dt;
	
   
    return iuv;

}

