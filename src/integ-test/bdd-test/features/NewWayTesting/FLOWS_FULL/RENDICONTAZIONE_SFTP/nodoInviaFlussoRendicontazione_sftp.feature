Feature: nodoInviaFlussoRendicontazione_sftp

    Background:
        Given systems up



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
  @ALL @FLOW @FLOW_FULL @RENDICONTAZIONE @INVIARENDICONTAZIONE @SFG @INVIARENDICONTAZIONE_3
  Scenario: nodoInviaFlussoRendicontazione con modalità invio SFG e rendicontazione_zip Y (REND-3)
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

    # RENDICONTAZIONE (come REND-3)
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
     # Trigger manuale del batch ftpUpload - primo tentativo (fallisce ma continua)
     When job ftpUpload triggered after 2 seconds

     # Update del retry dopo il fallimento del primo tentativo
     Given update for table RENDICONTAZIONE_SFTP_SEND_QUEUE with parameter RETRY = 1 on db nodo_offline with where datatable horizontal
       | where_keys | where_values  |
       | ID         | $fk_sftp_file |

     # Attesa prima del retry
     And waiting after triggered refresh job ALL

     # Retry del batch ftpUpload - secondo tentativo (fallisce anche in SIT - no FTP connection)
     When job ftpUpload triggered after 2 seconds

     # Verifica che il file rimane in TO_UPLOAD (connessione FTP non disponibile in SIT)
     And execution query to get value result_query on the table RENDICONTAZIONE_SFTP_SEND_QUEUE, with the columns STATUS with db name nodo_offline with where datatable horizontal
       | where_keys | where_values  |
       | ID         | $fk_sftp_file |
     And through the query result_query retrieve param final_status at position 0 and save it under the key final_status
     And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
       | column | value      |
       | STATUS | TO_UPLOAD  |
     And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RENDICONTAZIONE_SFTP_SEND_QUEUE retrived by the query on db nodo_offline with where datatable horizontal
       | where_keys | where_values  |
       | ID         | $fk_sftp_file |

He
