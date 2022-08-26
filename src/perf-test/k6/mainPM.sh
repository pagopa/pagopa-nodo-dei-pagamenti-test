active_scenario=PMCS_CT
active_test=TC01.04
test_step=rampa_1_1_10
env="pagoPA_DEV_apim"
echo -----------------------------------------
echo *** Main K6 Perf Test Script ***
echo -----------------------------------------

echo configured active_scenario = $active_scenario
echo configured active_test = $active_test
echo configured test_step= $test_step
echo configured env= $env
sh './scenarios/'$active_scenario'/test_selector.sh' $active_scenario $active_test $test_step $env



