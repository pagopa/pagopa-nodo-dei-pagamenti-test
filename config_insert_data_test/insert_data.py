import psycopg2
import conf_postgres
import json

#DB CONFIGURATIONS
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



# METHOD TO INSERT STATIONS
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
        #PREPARE QUERY INSERT STAZIONI
        for record in dati_stazioni:
            query_stazioni = query_stazioni_template
            
            for keys,values in record.items():
                query_stazioni = query_stazioni.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)

        #EXECUTE INSERT AND REPLACE FK STAZIONE
            cursor.execute(query_stazioni)
            obj_id = cursor.fetchone()[0]
            dati_pa_stazione_pa[i]['fk_stazione'] = obj_id
            i += 1

        #PREPARE QUERY INSERT PA STAZIONE PA
        j = 0
        for record in dati_pa_stazione_pa:
            query_pa_stazione_pa = query_pa_stazione_pa_template
            
            for keys,values in record.items():
                query_pa_stazione_pa = query_pa_stazione_pa.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)
            j += 1
        #EXECUTE INSER
            cursor.execute(query_pa_stazione_pa)

        #SAVE INSERT
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





#METHOD TO INSERT CANALI
def insert_canali_data(dati_canali, dati_canali_nodo, dati_canale_tipo_versamento, dati_psp_canale_tipo_versamento):
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
        $servizio_nmp, $target_host, $target_port, $target_path, $target_host_nmp, $target_port_nmp, $target_path_nmp) RETURNING obj_id
        """

        # Query per la tabella canale_tipo_versamento
        query_canale_tipo_versamento_template = """
        INSERT INTO nodo4_cfg.canale_tipo_versamento (fk_canale, fk_tipo_versamento)
        VALUES($fk_canale, $fk_tipo_versamento) RETURNING obj_id
        """


        # Query per la tabella psp_canale_tipo_versamento
        query_psp_canale_tipo_versamento_template = """
        INSERT INTO nodo4_cfg.psp_canale_tipo_versamento (fk_canale_tipo_versamento, fk_psp)
        VALUES($fk_canale_tipo_versamento, $fk_psp)
        """
    
        i = 0
        #PREPARE QUERY INSERT CANALI NODO
        for record in dati_canali_nodo:
            query_canali_nodo = query_canali_nodo_template
            
            for keys,values in record.items():
                query_canali_nodo = query_canali_nodo.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)

        #EXECUTE INSERT AND REPLACE FK CANALI NODO
            cursor.execute(query_canali_nodo)
            obj_id = cursor.fetchone()[0]
            dati_canali[i]['fk_canali_nodo'] = obj_id
            i += 1

        #PREPARE QUERY INSERT CANALI
        i = 0
        for record in dati_canali:
            query_canali = query_canali_template
            
            for keys,values in record.items():
                query_canali = query_canali.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)

        #EXECUTE INSERT AND REPLACE FK CANALE
            cursor.execute(query_canali)
            obj_id = cursor.fetchone()[0]
            for fk_canale in dati_canale_tipo_versamento[i]:
                fk_canale['fk_canale'] = obj_id
            i += 1


        #PREPARE QUERY INSERT CANALE TIPO VERSAMENTO
    
        list_fk_canale_tipo_versamento = []
        for list_json in dati_canale_tipo_versamento:
            list_obj_id = []
            for record in list_json:
                query_canale_tipo_versamento = query_canale_tipo_versamento_template
                
                for keys,values in record.items():
                    query_canale_tipo_versamento = query_canale_tipo_versamento.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)

        #EXECUTE INSERT AND REPLACE FK CANALE TIPO VERSAMENTO
                cursor.execute(query_canale_tipo_versamento)
                obj_id = cursor.fetchone()[0]
                list_obj_id.append(obj_id)

            list_fk_canale_tipo_versamento.append(list_obj_id)

        i = 0
        for list_fk_canale_tv in dati_psp_canale_tipo_versamento:
            j = 0
            for record_fk_canale_tv in list_fk_canale_tv:
                record_fk_canale_tv['fk_canale_tipo_versamento'] = list_fk_canale_tipo_versamento[i][j]
                j += 1
            i += 1



        #PREPARE QUERY INSERT PSP CANALE TIPO VERSAMENTO
        for list_json in dati_psp_canale_tipo_versamento:
            for record in list_json:
                query_psp_canale_tipo_versamento = query_psp_canale_tipo_versamento_template
                
                for keys,values in record.items():
                    query_psp_canale_tipo_versamento = query_psp_canale_tipo_versamento.replace(f"${keys}", f"'{str(values)}'" if values is not None else 'NULL', 1)

                #EXECUTE INSERT
                cursor.execute(query_psp_canale_tipo_versamento)

        # SAVE INSERT
        conn.commit()
        print("Dati inseriti con successo!")
        for canale in dati_canali:
            print(f"Canale inserito -> id: {str(canale['id_canale'])}")

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
        dati_canale_tipo_versamento = []
        dati_psp_canale_tipo_versamento = []
        
        with open(file_path, 'r') as file:
            data = json.load(file)  #LOAD JSON IN DICT

        count_stazioni = 0
        count_pa_stazione_pa = 0
        count_canali = 0
        count_canali_nodo = 0
        count_canale_tipo_versamento = 0
        count_psp_canale_tipo_versamento = 0   

        if 'stazioni' in data:
            count_stazioni = len(data['stazioni'])
        if 'pa_stazione_pa' in data:
            count_pa_stazione_pa = len(data['pa_stazione_pa'])
        if 'canali' in data:
            count_canali = len(data['canali'])
        if 'canali_nodo' in data:
            count_canali_nodo = len(data['canali_nodo'])
        if 'canale_tipo_versamento' in data:
            count_canale_tipo_versamento = len(data['canale_tipo_versamento'])
        if 'psp_canale_tipo_versamento' in data:
            count_psp_canale_tipo_versamento = len(data['psp_canale_tipo_versamento'])

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

        if count_canale_tipo_versamento != 0:
            for keys,values in data['canale_tipo_versamento'].items():
                dati_canale_tipo_versamento.append(values)

        if count_psp_canale_tipo_versamento != 0:
            for keys,values in data['psp_canale_tipo_versamento'].items():
                dati_psp_canale_tipo_versamento.append(values)

        return dati_stazioni,dati_pa_stazione_pa,dati_canali,dati_canali_nodo,dati_canale_tipo_versamento,dati_psp_canale_tipo_versamento

    except AssertionError as e:
        # Stampiamo il messaggio di errore dell'assert
        print("----->>>> Assertion Error: ", e)
        # Interrompiamo il test
        raise AssertionError(str(e))


#MAIN
if __name__ == '__main__':
    file_dati_stazioni = "config_insert_data_test/data_to_insert.json"
    dati_stazioni,dati_pa_stazione_pa,dati_canali,dati_canali_nodo,dati_canale_tipo_versamento,dati_psp_canale_tipo_versamento = leggi_dati_da_file(file_dati_stazioni)
    print('Lettura json completata!')
    if len(dati_stazioni) != 0 and len(dati_pa_stazione_pa) != 0:
        insert_stazioni_data(dati_stazioni,dati_pa_stazione_pa)
    if len(dati_canali) != 0 and len(dati_canali_nodo) != 0:
        insert_canali_data(dati_canali,dati_canali_nodo,dati_canale_tipo_versamento,dati_psp_canale_tipo_versamento)

    ### FARE REFRESH MANUALMENTE DALLA PAGINA DI MONITORING #############################################################################