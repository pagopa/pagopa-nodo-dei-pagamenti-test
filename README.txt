## PARAMS ##

-PROGRAM
--address=http://10.6.189.194:8082/servizio --enableRPTv2=true --RPTv2ConfFile=TS_Config.conf

-VM
-Xmx2G -Dlog4j.configurationFile=log4j2.xml -DLog4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector 


## TAGS ##
Nella nuova metodologia di test, i tag seguiranno le seguenti modalità:

@ALL            -> questo tag viene utilizzato per eseguire una run totale di tutti i test scritti nella nuova metodologia
@FLOW_FULL      -> questo tag viene utilizzato per eseguire una run di soli i test di flusso nella nuova metodologia
@NM3            -> questo tag viene utilizzato per eseguire una run di soli i test inerenti al nuovo modello 3 nella nuova metodologia (flusso e primitiva)
    - @NM3PANEW -> il modello di pagamento è suddiviso per nuova e vecchia PA

        - @NM3PANEWATTIVAZIONEFALLITA -> suddivisione per tipologia di scenario

            - @NM3ATTFALLITAPAOLD_FULL_1, NM3ATTFALLITAPAOLD_FULL_2, NM3ATTFALLITAPAOLD_FULL_3 ..... -> suddivisione per numero di scenario (valida anche per tutte le altre tipologie di scenario e modelli di pagamento)

        - @NM3PANEWPARALLEL
        - @NM3PANEWPAGKO
        - @NM3PANEWRETRYSPONEG
        - @NM3PANEWRETRY
        - @NM3PANEWSESSCAD

    - @NM3PAOLD -> il modello di pagamento è suddiviso per nuova e vecchia PA
        - @NM3ATTFALLITAPAOLD
        - @NM3PAOLDPARALLEL
        - @NM3PAOLDPAGKO
        - @NM3PAOLDPAGOK
        - @NM3PAOLDRETRY
        - @NM3PAOLDSESSCADUTA

@NMU            -> questo tag viene utilizzato per eseguire una run di soli i test inerenti al nuovo modello unico nella nuova metodologia (metodoliga analoga a NM3 (vedi sopra))
    - @NMUPANEW
        - @.....

    - @NMUPAOLD
        - @.....

@NM4            -> questo tag viene utilizzato per eseguire una run di soli i test inerenti al nuovo modello 4 nella nuova metodologia (suddivisione analoga a NM3)

@PRIMITIVE      ->      questo tag viene utilizzato per eseguire solo i test di primitiva inerenti alla nuova metodologia



## COMANDO BEHAVE PER ESEGUIRE LA RUN ##
behave src/integ-test/bdd-test/features/NewWayTesting/FLOWS_FULL/NewMod3/paNew/pagamento_KO.feature --tags=NM3PANEWPAGKO_FULL_40 --no-capture --no-capture-stderr --format=progress -D conffile=src/integ-test/bdd-test/resources/config_sit_postgres.json
     -> PATH DELLA FOLDER DA RUNNARE                                                               -> TAG DEL TEST CHE VOGLIO LANCIARE                                               -> FILE DI CONFIG CON LE PROPRIETA' DELL'AMBIENTE SU CUI SI DESIDERA ESEGUIRE
