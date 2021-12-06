# pagopa-nodo-dei-pagamenti-test
The repo contains Behavior-Driven Development ([BDD](https://cucumber.io/docs/bdd/)) test scenario based on [cucumber.io](https://cucumber.io/) for [nodo-dei-pagamenti](https://github.com/pagopa/pagopa-nodo4-nodo-dei-pagamenti)

## Prerequisites 
- [python](https://www.python.org/) and [pip](https://pip.pypa.io/en/stable/installation/)
  
## Run tests

Open tearminal and typing the following commands : 
```
python -m venv nodo-de-pagamenti-env
. nodo-de-pagamenti-env/bin/activate
pip install -r requirements.txt
behave src/integ-test/bdd-test/features/
```
