active_scenario=CT
active_test=TC01.03
test_step=rampa_30_300_10
env="pagoPA_DEV_apim"
echo -----------------------------------------
echo *** Main K6 Perf Test Script ***
echo -----------------------------------------

echo configured active_scenario = $active_scenario
echo configured active_test = $active_test
echo configured test_step= $test_step
echo configured env= $env
#if $active_scenario = CT
#then
  #sh test_selector.sh $active_scenario $active_test $test_step $env
#else 
  sh './scenarios/'$active_scenario'/test_selector.sh' $active_scenario $active_test $test_step $env
#fi



