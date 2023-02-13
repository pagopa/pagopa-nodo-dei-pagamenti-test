# find . -type d

# ------------------


write_config () {

file_path=$1
ramp_rps=$2
ramp_total_time=$3

total_time_div_10=$(($ramp_total_time/10))
rps_div_10=$(($ramp_rps/10))

cat <<EOF > ${file_path}
[{
    "Scalino_CT_1": ${rps_div_10},
    "Scalino_CT_TIME_1": ${total_time_div_10},
    "Scalino_CT_2": ${rps_div_10},
    "Scalino_CT_TIME_2": ${total_time_div_10},
    "Scalino_CT_3": ${rps_div_10},
    "Scalino_CT_TIME_3": ${total_time_div_10},
    "Scalino_CT_4": ${rps_div_10},
    "Scalino_CT_TIME_4": ${total_time_div_10},
    "Scalino_CT_5": ${rps_div_10},
    "Scalino_CT_TIME_5": ${total_time_div_10},
    "Scalino_CT_6": ${rps_div_10},
    "Scalino_CT_TIME_6": ${total_time_div_10},
    "Scalino_CT_7": ${rps_div_10},
    "Scalino_CT_TIME_7": ${total_time_div_10},
    "Scalino_CT_8": ${rps_div_10},
    "Scalino_CT_TIME_8": ${total_time_div_10},
    "Scalino_CT_9": ${rps_div_10},
    "Scalino_CT_TIME_9": ${total_time_div_10},
    "Scalino_CT_10": ${rps_div_10},
    "Scalino_CT_TIME_10": ${total_time_div_10}
}]
EOF


file_path=${file_path}
echo "[{" > $file_path 
echo "\t\"Scalino_CT_1\": $((rps_div_10*2))," >> $file_path 
echo "\t\"Scalino_CT_TIME_1\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_2\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_2\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_3\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_3\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_4\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_4\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_5\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_5\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_6\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_6\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_7\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_7\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_8\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_8\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_9\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_9\": ${total_time_div_10}," >> $file_path
echo "\t\"Scalino_CT_10\": ${rps_div_10}," >> $file_path
echo "\t\"Scalino_CT_TIME_10\": ${total_time_div_10}" >> $file_path
echo "}]" >> $file_path


}

# ------------------

### Main ###
output=$(pwd)/src/perf-test/k6/cfg/rampa_custom.json

write_config ${output} 100 600

# test
cat ${output}
# ------------------

env=prf

rampingSel=$(basename $output)
rampingSel="${rampingSel%.*}"
rampingSel=rampa_30_300_10_1

echo "rampingSel>" $rampingSel


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

# blacklistCT=("TC02.03" "TC02.04" "TC03.05" "TC03.06" "TC03.07" "TC04.01" "TC04.05" "TC04.06" "TC04.07" "TC04.08" "TC04.09" "TC04.10" "TC05.02_new_new" "TC05.02_new_old" "TC05.03_new_new" "TC05.03_new_old" "TC05.04_new_new" "TC05.04_new_old") # "TC01.03"
blacklistCT=("TC01.03" "TC02.03" "TC02.04" "TC02.05" "TC03.06" "TC04.01" "TC04.05" "TC04.06" "TC04.07" "TC04.08" "TC04.09" "TC04.10" "TC05.02_new_new" "TC05.02_new_old" "TC05.03_new_new" "TC05.03_new_old" "TC05.04_new_new" "TC05.04_new_old") # "TC03.05"

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
                echo "${active_test} --------------------------------------------------------------------------------------------------------------blacklisted"
                echo "${active_test} --------------------------------------------------------------------------------------------------------------blacklisted"
                echo "${active_test} --------------------------------------------------------------------------------------------------------------blacklisted"
        else
                # if [[ $i == $1 ]] ; then
                #call function to execute the script
                echo "#####################################################################"
                echo ${active_test}
                echo "#####################################################################"
                executeScript CT ${active_test}
                        # exit 0
                # fi
        fi
        ((i=i+1))


done



