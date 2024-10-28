import psycopg2
import conf_postgres
import json

# Configurazione del database
db_config = {
    "host": "10.221.83.180",
    "database": "ndpspct",
    "user": "nodo4_cfg",
    "password": "n0D04_CFG",
    "port": "5444"
}



def get_db_connection(db_name, db_cfg, db_conf):
    db = None
    conn = None
    if db_name.lower() == "nodo_cfg":
        db = db_cfg
        conn = db_cfg.getConnection(db_conf.get('host'), db_conf.get(
            'database'), db_conf.get('user'), db_conf.get('password'), db_conf.get('port'))
    return conn



# Funzione per eseguire l'inserimento si stazioni
def insert_stazioni_data(dati_stazioni, dati_pa_stazione_pa):
    try:
        conn = get_db_connection("nodo_cfg", conf_postgres, db_config)
        cursor = conn.cursor()
        
        # Query per la tabella stazioni
        query_stazioni_template = """
        INSERT INTO nodo4_cfg.stazioni (id_stazione, enabled, ip, password, porta, protocollo, redirect_ip,
            redirect_path, redirect_porta, redirect_query_string, servizio, rt_enabled, servizio_pof, fk_intermediario_pa,
            redirect_protocollo, protocollo_4mod, ip_4mod, porta_4mod, servizio_4mod, proxy_enabled, proxy_host, proxy_port,
            proxy_username, proxy_password, protocollo_avv, ip_avv, porta_avv, servizio_avv, timeout, num_thread, timeout_a,
            timeout_b, timeout_c, flag_online, versione, servizio_nmp, invio_rt_istantaneo, versione_primitive, target_host,
            target_port, target_path, target_host_pof, target_port_pof, target_path_pof, flag_standin, is_payment_options_enabled,
            rest_endpoint)
        VALUES ($id_stazione, $enabled, $ip, $password, $porta, $protocollo, $redirect_ip,
            $redirect_path, $redirect_porta, $redirect_query_string, $servizio, $rt_enabled, $servizio_pof, $fk_intermediario_pa,
            $redirect_protocollo, $protocollo_4mod, $ip_4mod, $porta_4mod, $servizio_4mod, $proxy_enabled, $proxy_host, $proxy_port,
            $proxy_username, $proxy_password, $protocollo_avv, $ip_avv, $porta_avv, $servizio_avv, $timeout, $num_thread, $timeout_a,
            $timeout_b, $timeout_c, $flag_online, $versione, $servizio_nmp, $invio_rt_istantaneo, $versione_primitive, $target_host,
            $target_port, $target_path, $target_host_pof, $target_port_pof, $target_path_pof, $flag_standin, $is_payment_options_enabled,
            $rest_endpoint) RETURNING obj_id
        """


        # Query per la tabella pa_stazione_pa
        query_pa_stazione_pa_template = """
        INSERT INTO nodo4_cfg.pa_stazione_pa (progressivo, fk_pa, fk_stazione, aux_digit, segregazione, quarto_modello, broadcast, pagamento_spontaneo)
        VALUES($progressivo, $fk_pa, $fk_stazione, $aux_digit, $segregazione, $quarto_modello, $broadcast, $pagamento_spontaneo)
        """
    
        i = 0
        #Prepara query stazioni
        for record in dati_stazioni:
            query_stazioni = query_stazioni_template
            
            for keys,values in record.items():
                query_stazioni = query_stazioni.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)

        # Eseguire l'inserimento in batch per stazioni e replace obj_id
            cursor.execute(query_stazioni)
            obj_id = cursor.fetchone()[0]
            dati_pa_stazione_pa[i]['fk_stazione'] = obj_id
            i += 1

        #prepara query pa_stazione_pa
        j = 0
        for record in dati_pa_stazione_pa:
            query_pa_stazione_pa = query_pa_stazione_pa_template
            
            for keys,values in record.items():
                query_pa_stazione_pa = query_pa_stazione_pa.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)
            j += 1
        # Eseguire l'inserimento in batch per pa_stazione_pa
            cursor.execute(query_pa_stazione_pa)

        # Salvare le modifiche
        conn.commit()
        print("Dati inseriti con successo!")

        for stazione in dati_pa_stazione_pa:
            print(f"Stazione inserita -> obj_id: {str(stazione['fk_stazione'])}")
    except Exception as e:
        conn.rollback()
        print(f"Errore durante l'inserimento: {e}")
    finally:
        cursor.close()
        conf_postgres.closeConnection(conn)





# Funzione per eseguire l'inserimento si stazioni
def insert_canali_data(dati_canali, dati_canali_nodo):
    try:
        conn = get_db_connection("nodo_cfg", conf_postgres, db_config)
        cursor = conn.cursor()
        
        # Query per la tabella canali nodo
        query_canali_nodo_template = """
        INSERT INTO nodo4_cfg.canali_nodo (redirect_ip, redirect_path, redirect_porta, redirect_query_string, 
        modello_pagamento, multi_payment, ragione_sociale, rpt_rt_compliant, wsapi, redirect_protocollo, id_serv_plugin,
        id_cluster, id_fesp_instance, lento, rt_push, agid_channel, on_us, carrello_carte, recovery, marca_bollo_digitale,
        flag_io, versione_primitive, flag_travaso, flag_standin)
        VALUES($redirect_ip, $redirect_path, $redirect_porta, $redirect_query_string, 
        $modello_pagamento, $multi_payment, $ragione_sociale, $rpt_rt_compliant, $wsapi, $redirect_protocollo, $id_serv_plugin,
        $id_cluster, $id_fesp_instance, $lento, $rt_push, $agid_channel, $on_us, $carrello_carte, $recovery, $marca_bollo_digitale,
        $flag_io, $versione_primitive, $flag_travaso, $flag_standin) RETURNING obj_id
        """


        # Query per la tabella canali
        query_canali_template = """
        INSERT INTO nodo4_cfg.canali (id_canale, enabled, ip, password, porta, protocollo, servizio, descrizione, fk_intermediario_psp, proxy_enabled,
        proxy_host, proxy_password, proxy_port, proxy_username, fk_canali_nodo, timeout, num_thread, use_new_fault_code, timeout_a, timeout_b, timeout_c,
        servizio_nmp, target_host, target_port, target_path, target_host_nmp, target_port_nmp, target_path_nmp)
        VALUES($id_canale, $enabled, $ip, $password, $porta, $protocollo, $servizio, $descrizione, $fk_intermediario_psp, $proxy_enabled,
        $proxy_host, $proxy_password, $proxy_port, $proxy_username, $fk_canali_nodo, $timeout, $num_thread, $use_new_fault_code, $timeout_a, $timeout_b, $timeout_c,
        $servizio_nmp, $target_host, $target_port, $target_path, $target_host_nmp, $target_port_nmp, $target_path_nmp)
        """
    
        i = 0
        #Prepara query canali_nodo
        for record in dati_canali_nodo:
            query_canali_nodo = query_canali_nodo_template
            
            for keys,values in record.items():
                query_canali_nodo = query_canali_nodo.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)

        # Eseguire l'inserimento in batch per canali nodo e replace obj_id
            cursor.execute(query_canali_nodo)
            obj_id = cursor.fetchone()[0]
            dati_canali[i]['fk_canali_nodo'] = obj_id
            i += 1

        #prepara query canali
        j = 0
        for record in dati_canali:
            query_canali = query_canali_template
            
            for keys,values in record.items():
                query_canali = query_canali.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)
            j += 1
        # Eseguire l'inserimento in batch per canali
            cursor.execute(query_canali)

        # Salvare le modifiche
        conn.commit()
        print("Dati inseriti con successo!")

        for canale in dati_canali:
            print(f"Canale inserito -> fk_canali_nodo: {str(canale['fk_canali_nodo'])}")
    except Exception as e:
        conn.rollback()
        print(f"Errore durante l'inserimento: {e}")
    finally:
        cursor.close()
        conf_postgres.closeConnection(conn)


def leggi_dati_da_file(file_path):
    try:
        dati_stazioni = []
        dati_pa_stazione_pa = []
        dati_canali = []
        dati_canali_nodo = [] 
        
        with open(file_path, 'r') as file:
            data = json.load(file)  # Carica il contenuto del file JSON in un dizionario o una lista

        count_stazioni = len(data['stazioni'])
        count_pa_stazione_pa = len(data['pa_stazione_pa'])
        count_canali = len(data['canali'])
        count_canali_nodo = len(data['canali_nodo'])

        assert count_stazioni == count_pa_stazione_pa, f"Numero di records per stazioni non corretto!!!!"
        assert count_canali == count_canali_nodo, f"Numero di records per canali non corretto!!!!"

        for i in range(0, count_stazioni):
            dati_stazioni.append(data['stazioni'][i])

        for i in range(0, count_pa_stazione_pa):    
            dati_pa_stazione_pa.append(data['pa_stazione_pa'][i])

        for i in range(0, count_canali):
            dati_canali.append(data['canali'][i])

        for i in range(0, count_canali_nodo):    
            dati_canali_nodo.append(data['canali_nodo'][i])

        return dati_stazioni,dati_pa_stazione_pa,dati_canali,dati_canali_nodo

    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print("----->>>> Assertion Error: ", e)
        # Interrompiamo il test
        raise AssertionError(str(e))

# Esecuzione dello script
if __name__ == '__main__':
    file_dati_stazioni = "C:\\Users\\luca.acone\\OneDrive - Accenture\\Desktop\\pagopanew\\pagopa-nodo-dei-pagamenti-test\\config_insert_data_test\\data_to_insert.json"
    dati_stazioni,dati_pa_stazione_pa,dati_canali,dati_canali_nodo = leggi_dati_da_file(file_dati_stazioni)
    insert_stazioni_data(dati_stazioni,dati_pa_stazione_pa)
    insert_canali_data(dati_canali,dati_canali_nodo)