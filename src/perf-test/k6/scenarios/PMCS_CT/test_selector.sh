
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

k6 run --out csv='./scenarios/'$scenario'/test/output/'$test'.csv' -e scenario=$scenario -e test=$test -e steps=$steps -e env=$env './scenarios/'$scenario'/test/'$test'.js'
#./k6 run --out csv='.\scenarios\'$scenario'\test\output\'$test'.csv' -e scenario=$scenario -e test=$test -e steps=$steps -e env=$env '.\scenarios\'$scenario'\test\'$test'.js'

echo Performance Test terminated.


