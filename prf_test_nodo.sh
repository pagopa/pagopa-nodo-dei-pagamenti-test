# find . -type d

env=prf
# rampingSel=rampa_1_1_10
rampingSel=rampa_1_1_10_SMOKE

<<USAGE_EX
USAGE_EX

#!/bin/bash
set -e

# ---------------

executeScript()
{
active_scenario=$1
active_test=$2
test_step=${rampingSel}

envTest="pagoPA_PERF_apim_REAL"

echo -----------------------------------------
echo *** Main K6 Perf Test Script ***
echo -----------------------------------------

echo configured active_scenario = $active_scenario
echo configured active_test = $active_test
echo configured test_step= $test_step
echo configured envTest= $envTest

filename=$(date +%m_%d_%y)$active_test.csv
debugParam="-v"

# K6_INFLUXDB_CONCURRENT_WRITES=6 K6_INFLUXDB_PUSH_INTERVAL=5s k6 run --out csv=src/perf-test/k6/scenarios/$active_scenario/test/output/$filename -e scenario=$scenario -e test=$active_test -e steps=$test_step -e env=$envTest src/perf-test/k6/scenarios/$active_scenario/test/$active_test.js -e outdir=src/perf-test/k6/scenarios/$active_scenario/test/output --out influxdb=http://k6nodo:siametricssiametricssiametrics@10.101.132.117:8086/k6nodo

K6_INFLUXDB_CONCURRENT_WRITES=6 K6_INFLUXDB_PUSH_INTERVAL=5s k6 run --out csv=src/perf-test/k6/scenarios/$active_scenario/test/output/$filename \
    -e scenario=$scenario -e test=$active_test -e steps=$test_step -e env=$envTest \
    src/perf-test/k6/scenarios/$active_scenario/test/$active_test.js \
    -e outdir=src/perf-test/k6/scenarios/$active_scenario/test/output \
    --out influxdb=http://localhost:8086/nodo_ndp_datastorek6 \
    -e SUBSCRIPTION_KEY=0f45790079eb45e0b526d15faaf58d95 -v

#     \
#     influxdb=http://k6nodo:siametricssiametricssiametrics@10.101.132.117:8086/k6nodo


}

# -----------------

echo $env
echo $rampingSel
scenarioToRun=CT

#clean and create output directory
rm -rf src/perf-test/k6/scenarios/CT/test/output

mkdir -p src/perf-test/k6/scenarios/CT/test/output

blacklistCT=""

#for each script
i=0
for d in src/perf-test/k6/scenarios/CT/test/*.js; do
        echo ${i}
        #removing prefix path: removing prefix ending with slash
        active_test=${d#src/perf-test/k6/scenarios/CT/test/*}

        #removing suffix js
        active_test=${active_test%.js}


        if [[ " ${blacklistCT[*]} " =~ " ${active_test} " ]]; then
                #skip script if it is blacklisted for CT
                echo $active_test blacklisted
        else
                if [[ $i == $1 ]] ; then
                        #call function to execute the script
                        echo "#####################################################################"
                        echo ${active_test}
                        echo "#####################################################################"
                        executeScript CT ${active_test}
                        exit 0
                fi
        fi
        ((i=i+1))


done
