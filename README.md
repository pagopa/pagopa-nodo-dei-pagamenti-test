# pagopa-nodo-dei-pagamenti-test

- [pagopa-nodo-dei-pagamenti-test](#pagopa-nodo-dei-pagamenti-test)
  - [Prerequisites](#prerequisites)
  - [Documentation](#documentation)
  - [Run tests 🧪](#run-tests-)
    - [BDD test 🥒](#bdd-test-)
    - [API test ✅](#api-test-)
  - [Reports 🧾](#reports-)


The repo contains : 
-  Behavior-Driven Development ([BDD](https://cucumber.io/docs/bdd/)) test scenario based 
  on [cucumber.io](https://cucumber.io/) for [nodo-dei-pagamenti](https://github.com/pagopa/pagopa-nodo4-nodo-dei-pagamenti)
- and api test integration using [postman](https://www.postman.com/) and [newman](https://www.npmjs.com/package/newman-run)

## Prerequisites 
- [python](https://www.python.org/) and [pip](https://pip.pypa.io/en/stable/installation/)
- [behave cucumber](https://cucumber.io/docs/installation/python/)
- [newman-run](https://www.npmjs.com/package/newman-run)
  
>NOTE : BDD tests require [mock services EC and PSP](https://github.com/pagopa/pagopa-mock-ec) up

## Documentation

See [here](src/integ-test/bdd-test/README.md) how to write feature.

## Run tests 🧪

### BDD test 🥒

Open terminal and typing the following commands : 

```py
python -m venv nodo-de-pagamenti-env
. nodo-de-pagamenti-env/bin/activate
pip install -r requirements.txt
behave src/integ-test/bdd-test/features/
```

if all right you'll see something like that 

```sh
11 features passed, 0 failed, 0 skipped
82 scenarios passed, 0 failed, 0 skipped
483 steps passed, 0 failed, 0 skipped, 0 undefined
Took 0m17.014s
```

>**NOTE**:\
-to obtain html report add `-f html -o behave-report.html` after `behave` command \
-Per default, behave captures stdout. This captured output is only shown if a failure occurs, if you want force it use [--no-capture](https://behave.readthedocs.io/en/stable/behave.html#cmdoption-no-capture) 

### API test ✅

In order run api test using postman collection simply typing : 

```sh
bash src/integ-test/api-test/run_test.sh <NUMBER_OF_ITERATION>
```

if all right you'll see something like that 


```sh

┌─────────────────────────┬────────────────────┬───────────────────┐
│                         │           executed │            failed │
├─────────────────────────┼────────────────────┼───────────────────┤
│              iterations │                  1 │                 0 │
├─────────────────────────┼────────────────────┼───────────────────┤
│                requests │                  9 │                 0 │
├─────────────────────────┼────────────────────┼───────────────────┤
│            test-scripts │                  9 │                 0 │
├─────────────────────────┼────────────────────┼───────────────────┤
│      prerequest-scripts │                  9 │                 0 │
├─────────────────────────┼────────────────────┼───────────────────┤
│              assertions │                  9 │                 0 │
├─────────────────────────┴────────────────────┴───────────────────┤
│ total run duration: 5.5s                                         │
├──────────────────────────────────────────────────────────────────┤
│ total data received: 9.32kB (approx)                             │
├──────────────────────────────────────────────────────────────────┤
│ average response time: 586ms [min: 92ms, max: 2.6s, s.d.: 735ms] │
└──────────────────────────────────────────────────────────────────┘
```

## Reports 🧾

Behave Test Report available [here](https://pagopa.github.io/pagopa-nodo-dei-pagamenti-test/)