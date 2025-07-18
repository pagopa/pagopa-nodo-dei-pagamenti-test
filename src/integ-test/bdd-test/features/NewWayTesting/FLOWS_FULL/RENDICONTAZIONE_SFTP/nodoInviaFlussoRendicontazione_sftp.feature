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
