
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

#local run:
#k6 run --out csv=scenarios/CT/test/output/TC01.03.csv -e scenario=CT -e test=TC01.03 -e steps=rampa_1_1_10_SMOKE -e env=pagoPA_PERF_apim scenarios/CT/test/TC01.03.js -e outdir=scenarios/CT/test/output -v --iterations=1
#k6 run --out xk6-influxdb=http://localhost:8086/k6database -e scenario=$scenario -e test=$test -e steps=$steps -e env=$env './scenarios/'$scenario'/test/'$test'.js'
k6 run --out csv=$progDir/scenarios/$scenario/test/output/$test.csv -e scenario=$scenario -e test=$test -e steps=$steps -e env=$env $progDir/scenarios/$scenario/test/$test.js
echo Performance Test terminated.


