import sql from 'k6/x/sql';
import { check } from 'k6';

const db = sql.open('postgres', './file_h2.db'); //mysql, sqlite3, sqlserver


export function setup() {
  /*db.exec(`CREATE TABLE IF NOT EXISTS keyvalues (
           id integer PRIMARY KEY AUTOINCREMENT,
           key varchar NOT NULL,
           value varchar);`);*/
}

export function teardown() {
  db.close();
}

export function exec (tokenIO, fc, mail) {
	
  let dt=Date.now();
  
  db.exec("INSERT INTO EXTENDED_PAGOPA_USER VALUES('${tokenIO}', 'StressPP', '${fc}', '${dt}', 'TestPP','${mail}', '${mail}');");

 
  }
