FROM ubuntu:latest

## python and relevant tools
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    python3 \
    python3-pip \
    git

## clone the test repository
RUN git clone https://github.com/pagopa/pagopa-nodo-dei-pagamenti-test.git

## move to the test main folder
WORKDIR pagopa-nodo-dei-pagamenti-test

RUN git pull

# copy config.json from local env to docker image
COPY ./src/integ-test/bdd-test/resources/config.json ./src/integ-test/bdd-test/resources/config.json

# install python libs
RUN python3 -m pip install -r requirements.txt

# execute behave
CMD mkdir report && behave -f html -o report/index.html src/integ-test/bdd-test/features/
