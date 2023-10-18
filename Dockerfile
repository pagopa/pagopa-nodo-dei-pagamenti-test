#FROM toolbox.sia.eu/docker-pagopa/python:3.9
FROM python:3.9
#set required env variable from args
ARG tags_arg
ARG folder_arg
ENV tags=$tags_arg
ENV folder=$folder_arg

#install jq
RUN apt-get update && \
	apt-get install -y jq

# install behave TODO remove!!!
#RUN pip install behave

#copy test script
ADD src/integ-test test/src/integ-test
ADD startIntTest.sh test/startIntTest.sh
ADD requirements.txt test/requirements.txt

#install requirements
RUN pip3 install -U -r test/requirements.txt

WORKDIR /test

ENTRYPOINT ["./startIntTest.sh"]