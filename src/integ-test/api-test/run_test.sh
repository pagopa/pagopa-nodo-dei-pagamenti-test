#!/bin/bash

set -e

NUM_OF_ITERATIONS=$1

newman run src/integ-test/api-test/Apim4Nodo.postman_collection.json -n $NUM_OF_ITERATIONS --reporters cli,htmlextra --reporter-htmlextra-title=“Platform-API-TestReport” --reporter-htmlextra-export
