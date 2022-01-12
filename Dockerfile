FROM ubuntu:latest

# python and relevant tools
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    python3 \
    python3-pip \
    git

# clone the test repository
# TODO remove automation branch
RUN git clone --branch automation https://github.com/pagopa/pagopa-nodo-dei-pagamenti-test.git

# move to the test main folder
WORKDIR pagopa-nodo-dei-pagamenti-test

RUN git pull

# install python libs
RUN python3 -m pip install -r requirements.txt

# execute behave
RUN sh publish_report.sh
