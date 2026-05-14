#Scenari da testare
#Invio flusso verso PA con modalità invio SFG ok
#
#Invio flusso verso PA con modalità invio MPTS (non regression) ok
#
#Retry invio flusso verso SFG
#
#Retry invio flusso verso MPTS (non regression)
#
#Retry su server_1 di una PA configurata ormai con server_2
#
#Provare gli scenari anche con presenza contemporanea di PA configurate su MPTS e SFG nella cache.

Feature: nodoInviaFlussoRendicontazione_sftp

    Background:
        Given systems up


#Test :Invio flusso verso PA con modalità invio MPTS (non regression) zippato
    @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @INVIARENDICONTAZIONE_1
    Scenario: nodoInviaFlussoRendicontazione con rendicontazione_ftp Y e rendicontazione_zip Y (XML zippato) (REND-1)
        Given REND generation REND_generation with datatable vertical
            | identificativoFlusso             | #identificativoFlusso# |
            | dataOraFlusso                    | #timedate#             |
            | identificativoUnivocoRegolamento | #iuv#                  |
            | identificativoUnivocoVersamento  | #iuv#                  |
            | identificativoUnivocoRiscossione | #iuv#                  |
        And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
            | identificativoPSP              | #psp#                       |
            | identificativoIntermediarioPSP | #id_broker_psp#             |
            | identificativoCanale           | #canale#                    |
            | password                       | #password#                  |
            | identificativoDominio          | #creditor_institution_code# |
            | identificativoFlusso           | $identificativoFlusso       |
            | dataOraFlusso                  | $timedate                   |
        When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaFlussoRendicontazione response

        And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
            | where_keys | where_values                |
            | ID_FLUSSO  | $identificativoFlusso       |
            | DOMINIO    | #creditor_institution_code# |
        And through the query result_query retrieve param fk_sftp_file at position 0 and save it under the key fk_sftp_file

        # RENDICONTAZIONE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | OPTLOCK            | 0                           |
            | PSP                | #psp#                       |
            | INTERMEDIARIO      | #id_broker_psp#             |
            | CANALE             | #canale#                    |
            | PASSWORD           | None                        |
            | DOMINIO            | #creditor_institution_code# |
            | ID_FLUSSO          | $identificativoFlusso       |
            | DATA_ORA_FLUSSO    | NotNone                     |
            | FK_BINARY_FILE     | None                        |
            | FK_SFTP_FILE       | NotNone                     |
            | STATO              | VALID                       |
            | INSERTED_TIMESTAMP | NotNone                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE retrived by the query on db nodo_offline with where datatable horizontal
            | where_keys | where_values                |
            | ID_FLUSSO  | $identificativoFlusso       |
            | DOMINIO    | #creditor_institution_code# |

        # RENDICONTAZIONE_SFTP_SEND_QUEUE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                          |
            | ID                 | NotNone                        |
            | FILE_NAME          | NotNone                        |
            | STATUS             | TO_UPLOAD                      |
            | FILE_SIZE          | NotNone                        |
            | SERVER_ID          | 1                              |
            | HOST_NAME          | 10.6.97.46                     |
            | PORT               | 22                             |
            | PATH               | 66666666666                    |
            | HASH               | NotNone                        |
            | CONTENT            | NotNone                        |
            | SENDER             | None                           |
            | RECEIVER           | None                           |
            | INSERTED_TIMESTAMP | NotNone                        |
            | UPDATED_TIMESTAMP  | NotNone                        |
            | INSERTED_BY        | nodoInviaFlussoRendicontazione |
            | UPDATED_BY         | nodoInviaFlussoRendicontazione |
            | RETRY              | 0                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
            | where_keys | where_values  |
            | ID         | $fk_sftp_file |

#      simulare il KO del batch che invia il file al server SFTP (il batch è schedulato ogni 5 minuti) e verificare che il file non venga inviato al server SFTP e che rimanga in stato TO_UPLOAD nella tabella RENDICONTAZIONE_SFTP_SEND_QUEUE
#
#      aspected KO --> UPDATE CFG_SERVER (INSTITUTE CREDITORE:AGGIUNGERE CODICE DELLA PA) -> CHIAMA AL BACHT TRAMITE REST(https://test.nexi.ndp.pagopa.it/nodo-p-sit.nexigroup.com/jobs/trigger/ftpUpload)
#      -> CI ASPETTIAMO CHE IL BATCH INVIA AL "PRIMO SERVER" (QUELLO CON CODICE DELLA PA)


#test: Invio flusso verso PA con modalità invio MPTS (non regression) non zippato
    @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @INVIARENDICONTAZIONE_2
    Scenario: nodoInviaFlussoRendicontazione con rendicontazione_ftp Y e rendicontazione_zip N (XML non zippato) (REND-2)
        Given update for table PA with parameter RENDICONTAZIONE_ZIP = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values |
            | OBJ_ID     | 16629      |
        And waiting after triggered refresh job ALL
        And REND generation REND_generation with datatable vertical
            | identificativoFlusso             | #identificativoFlusso# |
            | dataOraFlusso                    | #timedate#             |
            | identificativoUnivocoRegolamento | #iuv#                  |
            | identificativoUnivocoVersamento  | #iuv#                  |
            | identificativoUnivocoRiscossione | #iuv#                  |
        And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
            | identificativoPSP              | #psp#                       |
            | identificativoIntermediarioPSP | #id_broker_psp#             |
            | identificativoCanale           | #canale#                    |
            | password                       | #password#                  |
            | identificativoDominio          | #creditor_institution_code# |
            | identificativoFlusso           | $identificativoFlusso       |
            | dataOraFlusso                  | $timedate                   |
        When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaFlussoRendicontazione response

        And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
            | where_keys | where_values                |
            | ID_FLUSSO  | $identificativoFlusso       |
            | DOMINIO    | #creditor_institution_code# |
        And through the query result_query retrieve param fk_sftp_file at position 0 and save it under the key fk_sftp_file

        # RENDICONTAZIONE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | OPTLOCK            | 0                           |
            | PSP                | #psp#                       |
            | INTERMEDIARIO      | #id_broker_psp#             |
            | CANALE             | #canale#                    |
            | PASSWORD           | None                        |
            | DOMINIO            | #creditor_institution_code# |
            | ID_FLUSSO          | $identificativoFlusso       |
            | DATA_ORA_FLUSSO    | NotNone                     |
            | FK_BINARY_FILE     | None                        |
            | FK_SFTP_FILE       | NotNone                     |
            | STATO              | VALID                       |
            | INSERTED_TIMESTAMP | NotNone                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE retrived by the query on db nodo_offline with where datatable horizontal
            | where_keys | where_values                |
            | ID_FLUSSO  | $identificativoFlusso       |
            | DOMINIO    | #creditor_institution_code# |

        # RENDICONTAZIONE_SFTP_SEND_QUEUE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                          |
            | ID                 | NotNone                        |
            | FILE_NAME          | NotNone                        |
            | STATUS             | TO_UPLOAD                      |
            | FILE_SIZE          | NotNone                        |
            | SERVER_ID          | 2                              |
            | HOST_NAME          | 10.6.97.46                     |
            | PORT               | 22                             |
            | PATH               | 66666666666                    |
            | HASH               | NotNone                        |
            | CONTENT            | NotNone                        |
            | SENDER             | None                           |
            | RECEIVER           | None                           |
            | INSERTED_TIMESTAMP | NotNone                        |
            | UPDATED_TIMESTAMP  | NotNone                        |
            | INSERTED_BY        | nodoInviaFlussoRendicontazione |
            | UPDATED_BY         | nodoInviaFlussoRendicontazione |
            | RETRY              | 0                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
            | where_keys | where_values  |
            | ID         | $fk_sftp_file |
        Given update for table PA with parameter RENDICONTAZIONE_ZIP = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values |
            | OBJ_ID     | 16629      |
        And waiting after triggered refresh job ALL



 #  Rendicontazione SFTP con modalità di invio SFG (REND-3) zip
  #Test: Invio flusso verso PA con modalità invio SFG zippato
  @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @SFG @INVIARENDICONTAZIONE_3
  Scenario: nodoInviaFlussoRendicontazione con modalità invio SFG e rendicontazione_zip Y (REND-3)
    # Setup: Verifica FTP_SERVERS PRIMA dell'INSERT
#    Given execution query to get value result_query_before on the table FTP_SERVERS, with the columns OBJ_ID, HOST, PORT, USERNAME, ROOT_PATH, SERVICE, TYPE, ENABLED with db name nodo_cfg with where datatable horizontal
#      | where_keys | where_values |
#    And through the query result_query_before retrieve data and print query result ftp_servers_before
#
#    # Insert FTP_SERVERS record for SFG (server_2)
#    Given insert into table FTP_SERVERS with datatable horizontal on db nodo_cfg
#      | column_name  | value              |
#      | OBJ_ID       | 2                  |
#      | HOST         | 10.101.38.180      |
#      | PORT         | 20022              |
#      | USERNAME     | NODOPA             |
#      | PASSWORD     |                    |
#      | ROOT_PATH    | /Inbox             |
#      | SERVICE      | rendicontazioni    |
#      | TYPE         | userKey            |
#      | IN_PATH      |                    |
#      | OUT_PATH     |                    |
#      | HISTORY_PATH |                    |
#      | ENABLED      | Y                  |
#    And waiting after triggered refresh job ALL

    # Verifica FTP_SERVERS DOPO dell'INSERT
#    Given execution query to get value result_query_after on the table FTP_SERVERS, with the columns OBJ_ID, HOST, PORT, USERNAME, ROOT_PATH, SERVICE, TYPE, ENABLED with db name nodo_cfg with where datatable horizontal
#      | where_keys | where_values |
#    And through the query result_query_after retrieve data and print query result ftp_servers_after

#    Given execution query to get value result_query on the table CONFIGURATION_KEYS, with the columns CONFIG_DESCRIPTION, CONFIG_KEY, CONFIG_CATEGORY with db name nodo_cfg with where datatable horizontal
#      | where_keys | where_values |
#      | CONFIG_KEY | FTP2
#    And through the query result_query retrieve data and print query result ftp_servers_result

    Given update for table CONFIGURATION_KEYS with parameter config_value ='88888888888' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | CONFIG_KEY | creditorInstitutions.FTP2 |
    And waiting after triggered refresh job ALL

    Given REND generation REND_generation with datatable vertical
      | identificativoFlusso             | #identificativoFlusso# |
      | dataOraFlusso                    | #timedate#             |
      | identificativoUnivocoRegolamento | #iuv#                  |
      | identificativoUnivocoVersamento  | #iuv#                  |
      | identificativoUnivocoRiscossione | #iuv#                  |
    And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
      | identificativoPSP              | #psp#                       |
      | identificativoIntermediarioPSP | #id_broker_psp#             |
      | identificativoCanale           | #canale#                    |
      | password                       | #password#                  |
      | identificativoDominio          | #creditor_institution_code_secondary# |
      | identificativoFlusso           | $identificativoFlusso       |
      | dataOraFlusso                  | $timedate                   |
    When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaFlussoRendicontazione response

    And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code_secondary# |
    And through the query result_query retrieve param fk_sftp_file at position 0 and save it under the key fk_sftp_file

    # RENDICONTAZIONE (come REND-3)
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                       |
      | ID                 | NotNone                     |
      | OPTLOCK            | 0                           |
      | PSP                | #psp#                       |
      | INTERMEDIARIO      | #id_broker_psp#             |
      | CANALE             | #canale#                    |
      | PASSWORD           | None                        |
      | DOMINIO            | #creditor_institution_code_secondary# |
      | ID_FLUSSO          | $identificativoFlusso       |
      | DATA_ORA_FLUSSO    | NotNone                     |
      | FK_BINARY_FILE     | None                        |
      | FK_SFTP_FILE       | NotNone                     |
      | STATO              | VALID                       |
      | INSERTED_TIMESTAMP | NotNone                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code_secondary# |

    # RENDICONTAZIONE_SFTP_SEND_QUEUE (attesi SFG)
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                          |
      | ID                 | NotNone                        |
      | FILE_NAME          | NotNone                        |
      | STATUS             | UPLOADED                       |
      | FILE_SIZE          | NotNone                        |
      | SERVER_ID          | 2                              |
      | HOST_NAME          | 10.101.38.180                  |
      | PORT               | 20022                          |
      | PATH               | /Inbox                         |
      | HASH               | NotNone                        |
      | CONTENT            | NotNone                        |
      | SENDER             | None                           |
      | RECEIVER           | None                           |
      | INSERTED_TIMESTAMP | NotNone                        |
      | UPDATED_TIMESTAMP  | NotNone                        |
      | INSERTED_BY        | nodoInviaFlussoRendicontazione |
      | UPDATED_BY         | nodoInviaFlussoRendicontazione |
      | RETRY              | 0                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values  |
      | ID         | $fk_sftp_file |

    Given update for table PA with parameter RENDICONTAZIONE_FTP_TYPE = 'SFG' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | OBJ_ID     | 16629        |
    And waiting after triggered refresh job ALL

    Given update for table CONFIGURATION_KEYS with parameter configValue = '00488410010,97532760580' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | CONFIG_KEY | creditorInstitutions.FTP2 |
    And waiting after triggered refresh job ALL
#est: Invio flusso verso PA con modalità invio SFG non zippato
  @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @INVIARENDICONTAZIONE_4
  Scenario: nodoInviaFlussoRendicontazione con modalità invio SFG e rendicontazione_zip N (XML non zippato) (REND-4)
    Given update for table PA with parameter RENDICONTAZIONE_ZIP = 'N' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | OBJ_ID     | 16629      |
    And waiting after triggered refresh job ALL
    And REND generation REND_generation with datatable vertical
      | identificativoFlusso             | #identificativoFlusso# |
      | dataOraFlusso                    | #timedate#             |
      | identificativoUnivocoRegolamento | #iuv#                  |
      | identificativoUnivocoVersamento  | #iuv#                  |
      | identificativoUnivocoRiscossione | #iuv#                  |
    And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
      | identificativoPSP              | #psp#                       |
      | identificativoIntermediarioPSP | #id_broker_psp#             |
      | identificativoCanale           | #canale#                    |
      | password                       | #password#                  |
      | identificativoDominio          | #creditor_institution_code2# |
      | identificativoFlusso           | $identificativoFlusso       |
      | dataOraFlusso                  | $timedate                   |
    When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaFlussoRendicontazione response

    And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code2# |
    And through the query result_query retrieve param fk_sftp_file at position 0 and save it under the key fk_sftp_file

        # RENDICONTAZIONE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                       |
      | ID                 | NotNone                     |
      | OPTLOCK            | 0                           |
      | PSP                | #psp#                       |
      | INTERMEDIARIO      | #id_broker_psp#             |
      | CANALE             | #canale#                    |
      | PASSWORD           | None                        |
      | DOMINIO            | #creditor_institution_code2# |
      | ID_FLUSSO          | $identificativoFlusso       |
      | DATA_ORA_FLUSSO    | NotNone                     |
      | FK_BINARY_FILE     | None                        |
      | FK_SFTP_FILE       | NotNone                     |
      | STATO              | VALID                       |
      | INSERTED_TIMESTAMP | NotNone                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code2# |

        # RENDICONTAZIONE_SFTP_SEND_QUEUE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                          |
      | ID                 | NotNone                        |
      | FILE_NAME          | NotNone                        |
      | STATUS             | UPLOADED                       |
      | FILE_SIZE          | NotNone                        |
      | SERVER_ID          | 2                              |
      | HOST_NAME          | 10.101.38.180                  |
      | PORT               | 20022                          |
      | PATH               | /Inbox                    |
      | HASH               | NotNone                        |
      | CONTENT            | NotNone                        |
      | SENDER             | None                           |
      | RECEIVER           | None                           |
      | INSERTED_TIMESTAMP | NotNone                        |
      | UPDATED_TIMESTAMP  | NotNone                        |
      | INSERTED_BY        | nodoInviaFlussoRendicontazione |
      | UPDATED_BY         | nodoInviaFlussoRendicontazione |
      | RETRY              | 0                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values  |
      | ID         | $fk_sftp_file |
    Given update for table PA with parameter RENDICONTAZIONE_ZIP = 'Y' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | OBJ_ID     | 16629      |
    And waiting after triggered refresh job ALL

  @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @SFG @INVIARENDICONTAZIONE_5
  Scenario: nodoInviaFlussoRendicontazione con modalità invio SFG e rendicontazione_zip Y (REND-5)
    Given REND generation REND_generation with datatable vertical
      | identificativoFlusso             | #identificativoFlusso# |
      | dataOraFlusso                    | #timedate#             |
      | identificativoUnivocoRegolamento | #iuv#                  |
      | identificativoUnivocoVersamento  | #iuv#                  |
      | identificativoUnivocoRiscossione | #iuv#                  |
    And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
      | identificativoPSP              | #psp#                       |
      | identificativoIntermediarioPSP | #id_broker_psp#             |
      | identificativoCanale           | #canale#                    |
      | password                       | #password#                  |
      | identificativoDominio          | #creditor_institution_code2# |
      | identificativoFlusso           | $identificativoFlusso       |
      | dataOraFlusso                  | $timedate                   |
    When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaFlussoRendicontazione response

    And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code2# |
    And through the query result_query retrieve param fk_sftp_file at position 0 and save it under the key fk_sftp_file

    # RENDICONTAZIONE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                       |
      | ID                 | NotNone                     |
      | OPTLOCK            | 0                           |
      | PSP                | #psp#                       |
      | INTERMEDIARIO      | #id_broker_psp#             |
      | CANALE             | #canale#                    |
      | PASSWORD           | None                        |
      | DOMINIO            | #creditor_institution_code2# |
      | ID_FLUSSO          | $identificativoFlusso       |
      | DATA_ORA_FLUSSO    | NotNone                     |
      | FK_BINARY_FILE     | None                        |
      | FK_SFTP_FILE       | NotNone                     |
      | STATO              | VALID                       |
      | INSERTED_TIMESTAMP | NotNone                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code# |

    # RENDICONTAZIONE_SFTP_SEND_QUEUE (attesi SFG)
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                          |
      | ID                 | NotNone                        |
      | FILE_NAME          | NotNone                        |
      | STATUS             | TO_UPLOAD                      |
      | FILE_SIZE          | NotNone                        |
      | SERVER_ID          | 1                              |
      | HOST_NAME          | 10.6.97.46                     |
      | PORT               | 22                             |
      | PATH               | 66666666666                    |
      | HASH               | NotNone                        |
      | CONTENT            | NotNone                        |
      | SENDER             | None                           |
      | RECEIVER           | None                           |
      | INSERTED_TIMESTAMP | NotNone                        |
      | UPDATED_TIMESTAMP  | NotNone                        |
      | INSERTED_BY        | nodoInviaFlussoRendicontazione |
      | UPDATED_BY         | nodoInviaFlussoRendicontazione |
      | RETRY              | 0                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values  |
      | ID         | $fk_sftp_file |

      # Trigger manuale del batch ftpUpload (fallisce l'invio FTP ma ritorna 200)
      When job ftpUpload triggered after 2 seconds
      Then verify the HTTP status code of ftpUpload response is 200

      # Verifica che il file rimane in TO_UPLOAD con RETRY = 1 (il codice auto-incrementa il retry)
      And execution query to get value result_query on the table RENDICONTAZIONE_SFTP_SEND_QUEUE, with the columns STATUS, RETRY with db name nodo_offline with where datatable horizontal
        | where_keys | where_values  |
        | ID         | $fk_sftp_file |
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column | value      |
        | STATUS | TO_UPLOAD  |
        | RETRY  | 1          |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
        | where_keys | where_values  |
        | ID         | $fk_sftp_file |

  @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @SFG @INVIARENDICONTAZIONE_6
  Scenario: nodoInviaFlussoRendicontazione con modalità invio SFG, rendicontazione_zip Y e retry invio SFTP (REND-6)
    # Setup: metti indirizzo FTP sbagliato nella cache
    Given update for table FTP_SERVERS with parameter HOST = 'wrong.host.example.com' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | OBJ_ID     | 2            |
    And waiting after triggered refresh job ALL

    Given REND generation REND_generation with datatable vertical
      | identificativoFlusso             | #identificativoFlusso# |
      | dataOraFlusso                    | #timedate#             |
      | identificativoUnivocoRegolamento | #iuv#                  |
      | identificativoUnivocoVersamento  | #iuv#                  |
      | identificativoUnivocoRiscossione | #iuv#                  |
    And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
      | identificativoPSP              | #psp#                       |
      | identificativoIntermediarioPSP | #id_broker_psp#             |
      | identificativoCanale           | #canale#                    |
      | password                       | #password#                  |
      | identificativoDominio          | #creditor_institution_code2# |
      | identificativoFlusso           | $identificativoFlusso       |
      | dataOraFlusso                  | $timedate                   |
    When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaFlussoRendicontazione response

    And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code2# |
    And through the query result_query retrieve param fk_sftp_file at position 0 and save it under the key fk_sftp_file

    # RENDICONTAZIONE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                       |
      | ID                 | NotNone                     |
      | OPTLOCK            | 0                           |
      | PSP                | #psp#                       |
      | INTERMEDIARIO      | #id_broker_psp#             |
      | CANALE             | #canale#                    |
      | PASSWORD           | None                        |
      | DOMINIO            | #creditor_institution_code2# |
      | ID_FLUSSO          | $identificativoFlusso       |
      | DATA_ORA_FLUSSO    | NotNone                     |
      | FK_BINARY_FILE     | None                        |
      | FK_SFTP_FILE       | NotNone                     |
      | STATO              | VALID                       |
      | INSERTED_TIMESTAMP | NotNone                     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code# |

    # RENDICONTAZIONE_SFTP_SEND_QUEUE (con indirizzo sbagliato rimane in TO_UPLOAD)
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                          |
      | ID                 | NotNone                        |
      | FILE_NAME          | NotNone                        |
      | STATUS             | TO_UPLOAD                      |
      | FILE_SIZE          | NotNone                        |
      | SERVER_ID          | 2                              |
      | HOST               | wrong.host.example.com         |
      | PORT               | 20022                          |
      | PATH               | /Inbox                         |
      | HASH               | NotNone                        |
      | CONTENT            | NotNone                        |
      | SENDER             | None                           |
      | RECEIVER           | None                           |
      | INSERTED_TIMESTAMP | NotNone                        |
      | UPDATED_TIMESTAMP  | NotNone                        |
      | INSERTED_BY        | nodoInviaFlussoRendicontazione |
      | UPDATED_BY         | nodoInviaFlussoRendicontazione |
      | RETRY              | 0                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values  |
      | ID         | $fk_sftp_file |

      # Correggi l'indirizzo FTP con il valore corretto
      Given update for table FTP_SERVERS with parameter HOST = '10.101.38.180' on db nodo_cfg with where datatable horizontal
        | where_keys | where_values |
        | OBJ_ID     | 2            |
      And waiting after triggered refresh job ALL

      # Trigger manuale del batch ftpUpload (retry con indirizzo corretto)
      When job ftpUpload triggered after 2 seconds
      Then verify the HTTP status code of ftpUpload response is 200

      # Verifica che il file è stato inviato con successo (STATUS = UPLOADED)
      And execution query to get value result_query on the table RENDICONTAZIONE_SFTP_SEND_QUEUE, with the columns STATUS with db name nodo_offline with where datatable horizontal
        | where_keys | where_values  |
        | ID         | $fk_sftp_file |
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column | value      |
        | STATUS | UPLOADED   |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
        | where_keys | where_values  |
        | ID         | $fk_sftp_file |

  @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @SFG @INVIARENDICONTAZIONE_7
  Scenario: nodoInviaFlussoRendicontazione con retry su server_1 di una PA riconfigurala da server_2 (REND-7)

    # PA configurata inizialmente con server_1 (MPTS)
      | identificativoFlusso             | #identificativoFlusso# |
      | dataOraFlusso                    | #timedate#             |
      | identificativoUnivocoRegolamento | #iuv#                  |
      | identificativoUnivocoVersamento  | #iuv#                  |
      | identificativoUnivocoRiscossione | #iuv#                  |
    And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
      | identificativoPSP              | #psp#                       |
      | identificativoIntermediarioPSP | #id_broker_psp#             |
      | identificativoCanale           | #canale#                    |
      | password                       | #password#                  |
      | identificativoDominio          | #creditor_institution_code# |
      | identificativoFlusso           | $identificativoFlusso       |
      | dataOraFlusso                  | $timedate                   |
    When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaFlussoRendicontazione response

    And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code# |
    And through the query result_query retrieve param fk_sftp_file at position 0 and save it under the key fk_sftp_file

    # File va in TO_UPLOAD con server_1 (MPTS)
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                          |
      | ID                 | NotNone                        |
      | FILE_NAME          | NotNone                        |
      | STATUS             | TO_UPLOAD                      |
      | FILE_SIZE          | NotNone                        |
      | SERVER_ID          | 1                              |
      | HOST_NAME          | 10.6.97.46                     |
      | PORT               | 22                             |
      | PATH               | 66666666666                    |
      | HASH               | NotNone                        |
      | CONTENT            | NotNone                        |
      | RETRY              | 0                              |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values  |
      | ID         | $fk_sftp_file |

    # Riconfigura la PA da server_2 (SFG) a server_1 (MPTS) aggiungendo il codice dell'ente alla configurazione
    Given update for table CONFIGURATION_KEYS with parameter configValue = concat(configValue,',00488410010') on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | CONFIG_KEY | creditorInstitutions.FTP2 |
    And waiting after triggered refresh job ALL

    # Trigger manuale del batch ftpUpload (fallisce con indirizzo sbagliato ma ritorna 200)
    When job ftpUpload triggered after 2 seconds
    Then verify the HTTP status code of ftpUpload response is 200

    # Trigger manuale del batch ftpUpload (retry con indirizzo corretto su server_1)
    When job ftpUpload triggered after 2 seconds
    Then verify the HTTP status code of ftpUpload response is 200

    # Verifica che il file è stato inviato con successo (STATUS = TO_UPLOAD)
    And execution query to get value result_query on the table RENDICONTAZIONE_SFTP_SEND_QUEUE, with the columns STATUS with db name nodo_offline with where datatable horizontal
      | where_keys | where_values  |
      | ID         | $fk_sftp_file |
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column | value      |
      | STATUS | TO_UPLOAD   |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values  |
      | ID         | $fk_sftp_file |

  @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @SFG @INVIARENDICONTAZIONE_8
  Scenario: nodoInviaFlussoRendicontazione con PA contemporanea su MPTS e SFG nella cache (REND-8)
    # Setup: Configura PA con server_2 (SFG)
    Given update for table PA with parameter RENDICONTAZIONE_FTP_TYPE = 'SFG' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | OBJ_ID     | 16629        |
    And waiting after triggered refresh job ALL

    # Scenario 1: Invia rendicontazione per creditor_institution_code (MPTS - server_1)
    Given REND generation REND_generation with datatable vertical
      | identificativoFlusso             | #identificativoFlusso# |
      | dataOraFlusso                    | #timedate#             |
      | identificativoUnivocoRegolamento | #iuv#                  |
      | identificativoUnivocoVersamento  | #iuv#                  |
      | identificativoUnivocoRiscossione | #iuv#                  |
    And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
      | identificativoPSP              | #psp#                       |
      | identificativoIntermediarioPSP | #id_broker_psp#             |
      | identificativoCanale           | #canale#                    |
      | password                       | #password#                  |
      | identificativoDominio          | #creditor_institution_code# |
      | identificativoFlusso           | $identificativoFlusso       |
      | dataOraFlusso                  | $timedate                   |
    When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaFlussoRendicontazione response

    And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code# |
    And through the query result_query retrieve param fk_sftp_file_1 at position 0 and save it under the key fk_sftp_file_1

    # Verifica che il file di MPTS va con server_1
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column     | value      |
      | SERVER_ID  | 1          |
      | STATUS     | TO_UPLOAD  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values   |
      | ID         | $fk_sftp_file_1 |

    # Scenario 2: Invia rendicontazione per creditor_institution_code2 (SFG - server_2) contemporaneamente
    And REND generation REND_generation with datatable vertical
      | identificativoFlusso             | #identificativoFlusso# |
      | dataOraFlusso                    | #timedate#             |
      | identificativoUnivocoRegolamento | #iuv#                  |
      | identificativoUnivocoVersamento  | #iuv#                  |
      | identificativoUnivocoRiscossione | #iuv#                  |
    And from body with datatable vertical nodoInviaFlussoRendicontazione initial XML nodoInviaFlussoRendicontazione
      | identificativoPSP              | #psp#                       |
      | identificativoIntermediarioPSP | #id_broker_psp#             |
      | identificativoCanale           | #canale#                    |
      | password                       | #password#                  |
      | identificativoDominio          | #creditor_institution_code2# |
      | identificativoFlusso           | $identificativoFlusso       |
      | dataOraFlusso                  | $timedate                   |
    When EC sends SOAP nodoInviaFlussoRendicontazione to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaFlussoRendicontazione response

    And execution query to get value result_query on the table RENDICONTAZIONE, with the columns FK_SFTP_FILE with db name nodo_offline with where datatable horizontal
      | where_keys | where_values                |
      | ID_FLUSSO  | $identificativoFlusso       |
      | DOMINIO    | #creditor_institution_code2# |
    And through the query result_query retrieve param fk_sftp_file_2 at position 0 and save it under the key fk_sftp_file_2

    # Verifica che il file di SFG va con server_2
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column     | value              |
      | SERVER_ID  | 2                  |
      | STATUS     | UPLOADED           |
      | HOST_NAME  | 10.101.38.180      |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
      | where_keys | where_values   |
      | ID         | $fk_sftp_file_2 |

    # Verifica contemporanea: entrambi i file sono nella cache con server diversi
    And execution query to get value result_query on the table RENDICONTAZIONE_SFTP_SEND_QUEUE, with the columns COUNT(*) with db name nodo_offline with where datatable horizontal
      | where_keys | where_values |
    And verify that result_query contains at least 2 records





#  def isPAConfiguredForFTP2(idDominio: String, ddataMap: ConfigData)(implicit log: NodoLogger): Boolean = {
#  // RF01-A: PA nella lista CSV
#  val ftp2List = Try(DDataChecks.getConfigurationKeys(ddataMap, "creditorInstitutions.FTP2")).toOption.filter(_.nonEmpty)
#  log.debug(s"[FTP2Helper] RF01-A: creditorInstitutions.FTP2=${ftp2List.getOrElse("ASSENTE")}")
#  val paInList = ftp2List.exists(_.split(",").map(_.trim).contains(idDominio))
#  if (!paInList) {
#  log.debug(s"[FTP2Helper] PA $idDominio usa FTP/MPTS standard (non in lista FTP2)")
#  return false
#  }
