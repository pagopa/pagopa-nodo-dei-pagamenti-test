# pagopa-nodo-dei-pagamenti-test
The repo contains Behavior-Driven Development ([BDD](https://cucumber.io/docs/bdd/)) test scenario based on [cucumber.io](https://cucumber.io/) for [nodo-dei-pagamenti](https://github.com/pagopa/pagopa-nodo4-nodo-dei-pagamenti)

## Prerequisites 
- [python](https://www.python.org/) and [pip](https://pip.pypa.io/en/stable/installation/)
- [behave](https://cucumber.io/docs/installation/python/)
  
## Run tests

>NOTE : require [mock services EC and PSP](https://github.com/pagopa/pagopa-mock-ec) up and nodo-dei-pagamenti application running 

Open terminal and typing the following commands : 

```py
python -m venv nodo-de-pagamenti-env
. nodo-de-pagamenti-env/bin/activate
pip install -r requirements.txt
behave src/integ-test/bdd-test/features/
```

>**NOTE**:\
-to obtain html report add `-f html -o behave-report.html` after `behave` command \
-Per default, behave captures stdout. This captured output is only shown if a failure occurs, if you want force it use [--no-capture](https://behave.readthedocs.io/en/stable/behave.html#cmdoption-no-capture) 
