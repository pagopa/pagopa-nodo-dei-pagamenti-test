Feature: classic happy flow test for NM1 

    Background:
        Given systems up

    @pippoalf
    Scenario: checkPosition
       # Given insert through the query insert_query into the table stazioni the fields OBJ_ID, ID_STAZIONE, ENABLED, IP, PASSWORD, PORTA, PROTOCOLLO, REDIRECT_IP, REDIRECT_PATH, REDIRECT_PORTA, REDIRECT_QUERY_STRING, SERVIZIO, RT_ENABLED, SERVIZIO_POF, FK_INTERMEDIARIO_PA, REDIRECT_PROTOCOLLO, PROTOCOLLO_4MOD, IP_4MOD, PORTA_4MOD, SERVIZIO_4MOD, PROXY_ENABLED, PROXY_HOST, PROXY_PORT, PROXY_USERNAME, PROXY_PASSWORD, PROTOCOLLO_AVV, IP_AVV, PORTA_AVV, SERVIZIO_AVV, TIMEOUT, NUM_THREAD, TIMEOUT_A, TIMEOUT_B, TIMEOUT_C, FLAG_ONLINE, VERSIONE, SERVIZIO_NMP, INVIO_RT_ISTANTANEO, VERSIONE_PRIMITIVE, TARGET_HOST, TARGET_PORT, TARGET_PATH, TARGET_HOST_POF, TARGET_PORT_POF, TARGET_PATH_POF with 16630, '66666666666_10', 'Y', '10.70.66.200', 'pwdpwdpwd', 80, 'HTTPS', 'siapagopa.rf.gd', 'ec', 80, 'qrstr=prova', 'mock-ec-sit/servizi/PagamentiTelematiciRPT', 'Y', 'mock-ec-sit/servizi/PagamentiTelematiciRPT', 16630, 'HTTP', 'HTTPS', 'api.dev.platform.pagopa.it', 443, 'mock-ec/api/v1', 'N', '10.97.20.33', 80, '', '', 'HTTP', '', 0, '', 10 , 0, 0, 0, 0, 'Y' , 10 , '', 'N' , 1, '', 0, '', '', 0, '' under macro update_query on db nodo_cfg
        Given delete by the query delete_query the table stazioni with the where OBJ_ID=16630 under macro update_query on db nodo_cfg