#!/bin/bash
debugEnabled=$1
rampingSel=$2
blacklistCT=$3
echo "params: ${debugEnabled} ${rampingSel} ${blacklistCT}"
executeScript()
{
	active_scenario=$1
	active_test=$2
	test_step=$3
	
	envTest="pagoPA_PERF_apim"
	
	echo -----------------------------------------
	echo *** Main K6 Perf Test Script ***
	echo -----------------------------------------
	
	echo configured active_scenario = $active_scenario
	echo configured active_test = $active_test
	echo configured test_step= $test_step
	echo configured envTest= $envTest
	
	filename=$(date +%m_%d_%y)$active_test.csv
	echo "debugEnabled: [${debugEnabled}]"
	debugParam=""
	if echo "${debugEnabled}" | grep -q "True"; then
	  echo "debugParam is True" 
	  debugParam="-v"
	fi
	echo "debugParam is [${debugParam}]"
	
	echo "k6 run --out csv=src/perf-test/k6/scenarios/$active_scenario/test/output/$filename -e scenario=$active_scenario -e test=$active_test -e steps=$test_step -e env=$envTest src/perf-test/k6/scenarios/$active_scenario/test/$active_test.js -e outdir=src/perf-test/k6/scenarios/$active_scenario/test/output --out influxdb=http://k6nodo:siametricssiametricssiametrics@10.101.132.118:8086/k6nodo $debugParam"
	
	k6 run --out csv=src/perf-test/k6/scenarios/$active_scenario/test/output/$filename -e scenario=$active_scenario -e test=$active_test -e steps=$test_step -e env=$envTest src/perf-test/k6/scenarios/$active_scenario/test/$active_test.js -e outdir=src/perf-test/k6/scenarios/$active_scenario/test/output --out influxdb=http://k6nodo:siametricssiametricssiametrics@10.101.132.118:8086/k6nodo $debugParam

}

echo ramping selected:
echo ${rampingSel}
scenarioToRun=CT

#clean and create output directory
rm -rf src/perf-test/k6/scenarios/CT/test/output

mkdir -p src/perf-test/k6/scenarios/CT/test/output
              
#for each script
for d in src/perf-test/k6/scenarios/CT/test/*.js; do

	#removing prefix path: removing prefix ending with slash
	active_test=${d#src/perf-test/k6/scenarios/CT/test/*}
	
	#removing suffix js
	active_test=${active_test%.js}
	
	
	if echo "${blacklistCT[*]}" | grep -q "${active_test}"; then
	        #skip script if it is blacklisted for CT
	        echo ${active_test} blacklisted
	else
			echo "else block"
	        #call function to execute the script
	        executeScript CT ${active_test} ${rampingSel}
	fi
    
done