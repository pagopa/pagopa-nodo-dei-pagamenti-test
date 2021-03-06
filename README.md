# pagopa-nodo-dei-pagamenti-test

- [pagopa-nodo-dei-pagamenti-test](#pagopa-nodo-dei-pagamenti-test)
  - [Prerequisites](#prerequisites)
  - [Documentation](#documentation)
  - [Run tests ๐งช](#run-tests-)
    - [BDD test ๐ฅ](#bdd-test-)
    - [API test โ](#api-test-)
  - [Reports ๐งพ](#reports-)


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

## Run tests ๐งช

### BDD test ๐ฅ

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

### API test โ

In order run api test using postman collection simply typing : 

```sh
bash src/integ-test/api-test/run_test.sh <NUMBER_OF_ITERATION>
```

if all right you'll see something like that 


```sh

โโโโโโโโโโโโโโโโโโโโโโโโโโโฌโโโโโโโโโโโโโโโโโโโโโฌโโโโโโโโโโโโโโโโโโโโ
โ                         โ           executed โ            failed โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโค
โ              iterations โ                  1 โ                 0 โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโค
โ                requests โ                  9 โ                 0 โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโค
โ            test-scripts โ                  9 โ                 0 โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโค
โ      prerequest-scripts โ                  9 โ                 0 โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโโผโโโโโโโโโโโโโโโโโโโโค
โ              assertions โ                  9 โ                 0 โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโดโโโโโโโโโโโโโโโโโโโโโดโโโโโโโโโโโโโโโโโโโโค
โ total run duration: 5.5s                                         โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโค
โ total data received: 9.32kB (approx)                             โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโค
โ average response time: 586ms [min: 92ms, max: 2.6s, s.d.: 735ms] โ
โโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโโ
```

## Reports ๐งพ

Behave Test Report available [here](https://pagopa.github.io/pagopa-nodo-dei-pagamenti-test/)