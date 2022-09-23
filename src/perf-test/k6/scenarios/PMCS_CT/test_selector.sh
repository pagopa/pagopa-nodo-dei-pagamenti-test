
echo -----------------------------------------
echo *** Test Selector K6 Perf Test Script ***
echo -----------------------------------------
scenario=$1
echo retrieved $scenario scenario
test=$2
echo retrieved $test test
steps=$3
echo retrieved $steps steps
env=$4
echo retrieved $env env

progDir=`pwd`
echo PROG:   $progDir

echo calling 'k6 run -e scenario='$scenario' -e test='$test' -e steps='$steps' -e env='$env '"'$progDir'/scenarios/'$scenario'/test/'$test'.js"' command...

 k6 run --out csv=$progDir/scenarios/$scenario/test/output/$test.csv -e scenario=$scenario -e test=$test -e steps=$steps -e env=$env $progDir/scenarios/$scenario/test/$test.js
#k6 run --out xk6-influxdb=http://localhost:8086/k6database -e scenario=$scenario -e test=$test -e steps=$steps -e env=$env './scenarios/'$scenario'/test/'$test'.js'
#k6 run -e scenario=$scenario -e test=$test -e steps=$steps -e env=$env './scenarios/'$scenario'/test/'$test'.js' --out influxdb=http://127.0.0.1:8086/k6database
#./k6 run --out csv='.\scenarios\'$scenario'\test\output\'$test'.csv' -e scenario=$scenario -e test=$test -e steps=$steps -e env=$env '.\scenarios\'$scenario'\test\'$test'.js'

echo Performance Test terminated.

#run local
#k6 run --out csv=src/perf-test/k6/scenarios/PMCS_CT/test/output/TC01.01.csv -e scenario=PMCS_CT -e test=TC01.01 -e steps=rampa_1_1_10 -e env=pagoPA_PERF_apim src/perf-test/k6/scenarios/PMCS_CT/test/TC01.01.js
