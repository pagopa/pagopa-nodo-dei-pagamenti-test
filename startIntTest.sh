#!/bin/bash
fromAPI=$1
argTags=$2
argFolder=$3

function replace {
	file=$1
    key=$2
    value=$3
                  
    contents=$(jq "$key = \"$value\"" $file) && echo "${contents}" > $file
}

file=$file_config
 
echo "replace config file $file START"

# replace $file ".services.\"nodo-dei-pagamenti\".url"           "https://10.230.8.5:443/nodo-pagamenti/api/v1"
# replace $file ".services.\"nodo-dei-pagamenti\".healthcheck"   "/monitor/health"
# replace $file ".services.\"nodo-dei-pagamenti\".soap_service"  "/webservices/input"
# replace $file ".services.\"nodo-dei-pagamenti\".rest_service"  "/nodo-per-pm/v1"
# replace $file ".services.\"nodo-dei-pagamenti\".refresh_config_service"  "/config/refresh/ALL"

replace $file ".services.\"nodo-dei-pagamenti\".url"           "$NODO_URL"
replace $file ".services.\"nodo-dei-pagamenti\".healthcheck"   "/monitoring/v1/monitor/health"
replace $file ".services.\"nodo-dei-pagamenti\".soap_service"  ""
replace $file ".services.\"nodo-dei-pagamenti\".rest_service"  ""
replace $file ".services.\"nodo-dei-pagamenti\".refresh_config_service"  "-monitoring/monitoring/v1/config/refresh/ALL"

replace $file ".services.\"mock-ec\".url"           "https://api.dev.platform.pagopa.it/mock-ec/api/v1"
replace $file ".services.\"mock-ec\".healthcheck"   "/info"
replace $file ".services.\"mock-ec\".soap_service"  ""
replace $file ".services.\"mock-ec\".rest_service"  ""

replace $file ".services.\"secondary-mock-ec\".url"           "https://api.dev.platform.pagopa.it/secondary-mock-ec/api/v1"
replace $file ".services.\"secondary-mock-ec\".healthcheck"   "/info"
replace $file ".services.\"secondary-mock-ec\".soap_service"  ""
replace $file ".services.\"secondary-mock-ec\".rest_service"  ""

replace $file ".services.\"mock-psp\".url"           "https://api.dev.platform.pagopa.it/mock-psp-service/api/v1"
replace $file ".services.\"mock-psp\".healthcheck"   "/info"
replace $file ".services.\"mock-psp\".soap_service"  ""
replace $file ".services.\"mock-psp\".rest_service"  ""

replace $file ".services.\"secondary-mock-psp\".url"           "https://api.dev.platform.pagopa.it/secondary-mock-psp-service/api/v1"
replace $file ".services.\"secondary-mock-psp\".healthcheck"   "/info"
replace $file ".services.\"secondary-mock-psp\".soap_service"  ""
replace $file ".services.\"secondary-mock-psp\".rest_service"  ""

replace $file ".services.\"mock-pm\".url"           "https://api.dev.platform.pagopa.it/mock-pm-sit/api/v1"
replace $file ".services.\"mock-pm\".healthcheck"   "/info"
replace $file ".services.\"mock-pm\".soap_service"  ""
replace $file ".services.\"mock-pm\".rest_service"  ""

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

echo "replace config file END"

if [ "$fromAPI" = true ]; then
    echo "Setting tags and folder from args..."
    folder=$argFolder
    tags=$argTags
fi

echo "executing command: behave -f allure_behave.formatter:AllureFormatter -o /test/allure $folder --tags=$tags --no-capture --no-capture-stderrhelpcls -D conffile=$file_config"
behave -f allure_behave.formatter:AllureFormatter -o /test/allure $folder --tags=$tags --no-capture --no-capture-stderr -D conffile=$file_config

ls -lash /test/allure

export PORT=8081
export allure.resultsDir=/test/allure
export allure.reports.dir=/test/allure

java -jar allure-server.jar

# if [ "$fromAPI" = true ]; then
#     echo "Allure already started"
#     allure generate /test/allure
# else
#     echo "Starting Allure server"
# 	allure serve /test/allure -p 8081
# fi

