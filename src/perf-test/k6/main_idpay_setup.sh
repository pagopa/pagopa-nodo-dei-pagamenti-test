#active_scenario=CT
active_scenario=PMCS_CT
active_test=idpay_setup
#active_test=TC01.01
test_step=rampa_1_1_10
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
  sh './scenarios/'$active_scenario'/idpay_setup_selector.sh' $active_scenario $active_test $test_step $env
#fi



