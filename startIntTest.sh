#!/bin/bash
fromAPI=$1
argTags=$2
argFolder=$3
history=false

function replace {
	file=$1
    key=$2
    value=$3
                  
    contents=$(jq "$key = \"$value\"" $file) && echo "${contents}" > $file
}

file=$file_config

if [ -n "$4" ]; then
    file="$4"
    echo "replace config file param"
fi
 
echo "replace config file $file START"

######################## PUNTAMENTI VIA APIM #####################

replace $file ".services.\"nodo-dei-pagamenti\".url"           "https://api.dev.platform.pagopa.it/nodo"
replace $file ".services.\"nodo-dei-pagamenti\".healthcheck"   "/monitoring/v1/monitor/health"
replace $file ".services.\"nodo-dei-pagamenti\".soap_service"  ""
replace $file ".services.\"nodo-dei-pagamenti\".rest_service"  ""
replace $file ".services.\"nodo-dei-pagamenti\".refresh_config_service"  "https://test.nexi.ndp.pagopa.it/nodo-p-sit.nexigroup.com/config/refresh/ALL"
replace $file ".services.\"nodo-dei-pagamenti\".subscription_key_name"  "N"

# replace $file ".services.\"mock-ec\".url"           "https://api.dev.platform.pagopa.it/mock-ec/api/v1"
# replace $file ".services.\"mock-ec\".healthcheck"   "/info"
# replace $file ".services.\"mock-ec\".soap_service"  ""
# replace $file ".services.\"mock-ec\".rest_service"  ""
# replace $file ".services.\"mock-ec\".subscription_key_name"  "Y"

# replace $file ".services.\"secondary-mock-ec\".url"           "https://api.dev.platform.pagopa.it/secondary-mock-ec/api/v1"
# replace $file ".services.\"secondary-mock-ec\".healthcheck"   "/info"
# replace $file ".services.\"secondary-mock-ec\".soap_service"  ""
# replace $file ".services.\"secondary-mock-ec\".rest_service"  ""
# replace $file ".services.\"secondary-mock-ec\".subscription_key_name"  "Y"

# replace $file ".services.\"mock-psp\".url"           "https://api.dev.platform.pagopa.it/mock-psp-service/api/v1"
# replace $file ".services.\"mock-psp\".healthcheck"   "/info"
# replace $file ".services.\"mock-psp\".soap_service"  ""
# replace $file ".services.\"mock-psp\".rest_service"  ""
# replace $file ".services.\"mock-psp\".subscription_key_name"  "Y"

# replace $file ".services.\"secondary-mock-psp\".url"           "https://api.dev.platform.pagopa.it/secondary-mock-psp-service/api/v1"
# replace $file ".services.\"secondary-mock-psp\".healthcheck"   "/info"
# replace $file ".services.\"secondary-mock-psp\".soap_service"  ""
# replace $file ".services.\"secondary-mock-psp\".rest_service"  ""
# replace $file ".services.\"secondary-mock-psp\".subscription_key_name"  "Y"


# replace $file ".services.\"mock-pm\".url"           "https://api.dev.platform.pagopa.it/mock-pm-sit/api/v1"
# replace $file ".services.\"mock-pm\".healthcheck"   "/info"
# replace $file ".services.\"mock-pm\".soap_service"  ""
# replace $file ".services.\"mock-pm\".rest_service"  ""
# replace $file ".services.\"mock-pm\".subscription_key_name"  "Y"


######################### PUNTAMENTI SENZA APIM #####################


#replace $file ".services.\"nodo-dei-pagamenti\".url"           "https://nodo-p-sit.tst-npc.sia.eu"
# replace $file ".services.\"nodo-dei-pagamenti\".url"           "https://test.nexi.ndp.pagopa.it/nodo-p-sit.nexigroup.com"
# replace $file ".services.\"nodo-dei-pagamenti\".healthcheck"   "/monitor/health"
# replace $file ".services.\"nodo-dei-pagamenti\".soap_service"  "/webservices/input"
# replace $file ".services.\"nodo-dei-pagamenti\".rest_service"  "rest"
# replace $file ".services.\"nodo-dei-pagamenti\".refresh_config_service"  "https://test.nexi.ndp.pagopa.it/nodo-p-sit.nexigroup.com/config/refresh/ALL"
# replace $file ".services.\"nodo-dei-pagamenti\".subscription_key_name"  "N"


replace $file ".services.\"mock-ec\".url"           "https://test.nexi.ndp.pagopa.it/mock-ec-primary-sit.nexigroup.com/servizi/PagamentiTelematiciRPT"
replace $file ".services.\"mock-ec\".healthcheck"   "/info"
replace $file ".services.\"mock-ec\".soap_service"  ""
replace $file ".services.\"mock-ec\".rest_service"  ""
replace $file ".services.\"mock-ec\".subscription_key_name"  "Y"


replace $file ".services.\"secondary-mock-ec\".url"           "https://test.nexi.ndp.pagopa.it/mock-ec-secondary-sit.nexigroup.com/secondary-mock-ec"
replace $file ".services.\"secondary-mock-ec\".healthcheck"   "/info"
replace $file ".services.\"secondary-mock-ec\".soap_service"  ""
replace $file ".services.\"secondary-mock-ec\".rest_service"  ""
replace $file ".services.\"secondary-mock-ec\".subscription_key_name"  "Y"


replace $file ".services.\"mock-psp\".url"           "https://test.nexi.ndp.pagopa.it/mock-psp-primary-sit.nexigroup.com/servizi/MockPSP"
replace $file ".services.\"mock-psp\".healthcheck"   "/info"
replace $file ".services.\"mock-psp\".soap_service"  ""
replace $file ".services.\"mock-psp\".rest_service"  ""
replace $file ".services.\"mock-psp\".subscription_key_name"  "Y"


replace $file ".services.\"secondary-mock-psp\".url"           "https://test.nexi.ndp.pagopa.it/mock-psp-secondary-sit.nexigroup.com/psp-sec-mock"
replace $file ".services.\"secondary-mock-psp\".healthcheck"   "/info"
replace $file ".services.\"secondary-mock-psp\".soap_service"  ""
replace $file ".services.\"secondary-mock-psp\".rest_service"  ""
replace $file ".services.\"secondary-mock-psp\".subscription_key_name"  "Y"


replace $file ".services.\"mock-pm\".url"           "https://test.nexi.ndp.pagopa.it/mock-pm-sit.nexigroup.com/PerfPMMock"
replace $file ".services.\"mock-pm\".healthcheck"   "/actuator/health"
replace $file ".services.\"mock-pm\".soap_service"  ""
replace $file ".services.\"mock-pm\".rest_service"  ""
replace $file ".services.\"mock-pm\".subscription_key_name"  "Y"


######################## PUNTMANETI SERVIZIO APICONFIGCACHE #####################

replace $file ".services.\"apicfg-testing-support\".url"           "https://api.dev.platform.pagopa.it/apiconfig/testing-support/pnexi/v1"
replace $file ".services.\"apicfg-testing-support\".healthcheck"   "/info"
replace $file ".services.\"apicfg-testing-support\".soap_service"  ""
replace $file ".services.\"apicfg-testing-support\".rest_service"  ""
replace $file ".services.\"apicfg-testing-support\".subscription_key_name"  "Y"

##################### DB CONFIG #####################


replace $file ".db_configuration.nodo_cfg.host"     $db_cfg_host_sit
replace $file ".db_configuration.nodo_cfg.database" $db_cfg_service_name_sit
replace $file ".db_configuration.nodo_cfg.user"     $db_cfg_username_sit
replace $file ".db_configuration.nodo_cfg.password" $db_cfg_password_sit
replace $file ".db_configuration.nodo_cfg.port"     $db_cfg_port_sit

replace $file ".db_configuration.nodo_online.host"      $db_online_host_sit
replace $file ".db_configuration.nodo_online.database"  $db_online_service_name_sit
replace $file ".db_configuration.nodo_online.user"      $db_online_username_sit
replace $file ".db_configuration.nodo_online.password"  $db_online_password_sit
replace $file ".db_configuration.nodo_online.port"      $db_online_port_sit

replace $file ".db_configuration.nodo_offline.host"       $db_offline_host_sit
replace $file ".db_configuration.nodo_offline.database"   $db_offline_service_name_sit
replace $file ".db_configuration.nodo_offline.user"       $db_offline_username_sit
replace $file ".db_configuration.nodo_offline.password"   $db_offline_password_sit  
replace $file ".db_configuration.nodo_offline.port"       $db_offline_port_sit

replace $file ".db_configuration.re.host"       $db_re_host_sit
replace $file ".db_configuration.re.database"   $db_re_service_name_sit
replace $file ".db_configuration.re.user"       $db_re_username_sit
replace $file ".db_configuration.re.password"   $db_re_password_sit  
replace $file ".db_configuration.re.port"       $db_re_port_sit

replace $file ".db_configuration.wfesp.host"      $db_wfesp_host_sit 
replace $file ".db_configuration.wfesp.database"  $db_wfesp_service_name_sit 
replace $file ".db_configuration.wfesp.user"      $db_wfesp_username_sit 
replace $file ".db_configuration.wfesp.password"  $db_wfesp_password_sit     
replace $file ".db_configuration.wfesp.port"      $db_wfesp_port_sit

replace $file ".env.SUBKEY"      $APICFG_SUBSCRIPTION_KEY

echo "replace config file END"

if [ "$fromAPI" = true ]; then
    echo "Setting tags and folder from args..."
    folder=$argFolder
    tags=$argTags
fi

echo "Clearing allure-result folder"
find /test/allure/allure-result/ -type f -delete

echo "executing command: behave -f allure_behave.formatter:AllureFormatter -o /test/allure-result $folder --tags=$tags --no-capture --no-capture-stderr -D conffile=$file"
behave -f allure_behave.formatter:AllureFormatter -o /test/allure/allure-result $folder --tags=$tags --no-capture --no-capture-stderr -D conffile=$file

if [ "$history" = false ]; then
    echo "Removing history folders..."
    rm -rf /test/allure/allure-result/history*
    rm -rf /test/allure/allure-report/history
else
    mkdir -p /test/allure/allure-result/history || echo "history folder already in place...continuing :)" 														   
    find /test/allure/allure-report/history/* -type f -exec sh -c 'cp "{}" "/test/allure/allure-result/history""/"' \;
    echo "Allure trends updated!"
fi

ls -lash /test/allure/allure-result
[ -e allure-result.zip ] && rm -f allure-result.zip
allure generate /test/allure/allure-result --clean -o /test/allure/allure-report

if [ "$fromAPI" = false ]; then
	echo "starting allure..."
    allure open /test/allure/allure-report -p 8081
fi

