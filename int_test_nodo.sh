# find . -type d

pip install -U -r ./requirements.txt

<<USAGE_EX
NODOPGDB=true SUBSCRIPTION_KEY=9b211c9e90a74fcc8115b64a924219df sh int_test_nodo.sh \
https://api.dev.platform.pagopa.it/nodo-replica-ndp \
https://api.dev.platform.pagopa.it/nodo-replica-ndp/monitoring/v1/config/refresh/CONFIG \
https://api.dev.platform.pagopa.it/mock-ec-replica-ndp/service/v1/mock \
https://api.dev.platform.pagopa.it/mock-ec-replica-secondary-ndp/service/v1/mock \
https://api.dev.platform.pagopa.it/mock-psp-replica-ndp/service/v1/mock \
https://api.dev.platform.pagopa.it/mock-psp-secondary-replica-ndp/service/v1/mock \
https://api.dev.platform.pagopa.it/mock-pm-replica-ndp/service/v1 \
password
USAGE_EX

#!/bin/bash
set -e

# Vars definition
URL_NODO=$1
URL_NODO_CFG=$2
URL_MOCK_EC1=$3
URL_MOCK_EC2=$4
URL_MOCK_PSP1=$5
URL_MOCK_PSP2=$6
URL_MOCK_PM=$7
DB_PWD=$8
#FEATURES_PATH=/PrimitiveAccessorie/primitives
#FEATURES_PATH=/Mod1/flows/nodoInviaRT
FEATURES_PATH=/NewMod3/primitives/verifyPaymentNotice_syntax_ok.feature

if [ "$#" -lt 9 ] && [ "$#" -gt 0 ]; then
    echo "Yeaaah 🚀"
else
    echo "Input parameter error 👎 "
fi
# -----------------------

function replace {
    file=$1
    key=$2
    value=$3

    contents=$(jq "$key = \"$value\"" $file) && echo "${contents}" > $file
}

# -----------------------

file=./src/integ-test/bdd-test/resources/config.json

replace $file ".services.\"nodo-dei-pagamenti\".url"           $URL_NODO
replace $file ".services.\"nodo-dei-pagamenti\".healthcheck"   ""
replace $file ".services.\"nodo-dei-pagamenti\".soap_service"  " "
replace $file ".services.\"nodo-dei-pagamenti\".rest_service"  " "
replace $file ".services.\"nodo-dei-pagamenti\".refresh_config_service"  $URL_NODO_CFG

replace $file ".services.\"mock-ec\".url"           $URL_MOCK_EC1
replace $file ".services.\"mock-ec\".healthcheck"   "/info"
replace $file ".services.\"mock-ec\".soap_service"  ""
replace $file ".services.\"mock-ec\".rest_service"  ""

replace $file ".services.\"secondary-mock-ec\".url"           $URL_MOCK_EC2
replace $file ".services.\"secondary-mock-ec\".healthcheck"   "/info"
replace $file ".services.\"secondary-mock-ec\".soap_service"  ""
replace $file ".services.\"secondary-mock-ec\".rest_service"  ""

replace $file ".services.\"mock-psp\".url"           $URL_MOCK_PSP1
replace $file ".services.\"mock-psp\".healthcheck"   "/info"
replace $file ".services.\"mock-psp\".soap_service"  ""
replace $file ".services.\"mock-psp\".rest_service"  ""

replace $file ".services.\"secondary-mock-psp\".url"           $URL_MOCK_PSP2
replace $file ".services.\"secondary-mock-psp\".healthcheck"   "/info"
replace $file ".services.\"secondary-mock-psp\".soap_service"  ""
replace $file ".services.\"secondary-mock-psp\".rest_service"  ""

replace $file ".services.\"mock-pm\".url"           $URL_MOCK_PM
replace $file ".services.\"mock-pm\".healthcheck"   "/"
replace $file ".services.\"mock-pm\".soap_service"  ""
replace $file ".services.\"mock-pm\".rest_service"  ""

replace $file ".db_configuration.nodo_cfg.host"     "pagopa-d-weu-nodo-flexible-postgresql.postgres.database.azure.com"
replace $file ".db_configuration.nodo_cfg.database" "nodo"
replace $file ".db_configuration.nodo_cfg.user"     "cfg"
replace $file ".db_configuration.nodo_cfg.password" $DB_PWD
replace $file ".db_configuration.nodo_cfg.port"     "5432"

replace $file ".db_configuration.nodo_online.host"      "pagopa-d-weu-nodo-flexible-postgresql.postgres.database.azure.com"
replace $file ".db_configuration.nodo_online.database"  "nodo"
replace $file ".db_configuration.nodo_online.user"      "online"
replace $file ".db_configuration.nodo_online.password"  $DB_PWD
replace $file ".db_configuration.nodo_online.port"      "5432"

replace $file ".db_configuration.nodo_offline.host"       "pagopa-d-weu-nodo-flexible-postgresql.postgres.database.azure.com"
replace $file ".db_configuration.nodo_offline.database"   "nodo"
replace $file ".db_configuration.nodo_offline.user"       "offline"
replace $file ".db_configuration.nodo_offline.password"   $DB_PWD
replace $file ".db_configuration.nodo_offline.port"       "5432"

replace $file ".db_configuration.re.host"       "pagopa-d-weu-nodo-flexible-postgresql.postgres.database.azure.com"
replace $file ".db_configuration.re.database"   "nodo"
replace $file ".db_configuration.re.user"       "re"
replace $file ".db_configuration.re.password"   $DB_PWD
replace $file ".db_configuration.re.port"       "5432"

replace $file ".db_configuration.wfesp.host"      "pagopa-d-weu-nodo-flexible-postgresql.postgres.database.azure.com"
replace $file ".db_configuration.wfesp.database"  "nodo"
replace $file ".db_configuration.wfesp.user"      "wfesp"
replace $file ".db_configuration.wfesp.password"  $DB_PWD
replace $file ".db_configuration.wfesp.port"      "5432"



echo "Run test ......."
rm -rf report report-nodo reports
# -f html -o report/index.html
behave --junit-directory=./report-nodo --junit ./src/integ-test/bdd-test/features$FEATURES_PATH --tags=runnable,midRunnable --summary --show-timings -v
