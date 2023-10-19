FROM toolbox.sia.eu/docker-pagopa/python:3.9
#FROM python:3.9

#install jq and openjdk-17
RUN apt-get update && \
	apt-get install -y jq && \
	apt-get install openjdk-17-jdk -y

#copy test script
ADD src/integ-test test/src/integ-test
ADD startIntTest.sh test/startIntTest.sh
ADD requirements.txt test/requirements.txt

#install requirements
RUN pip3 install -U -r test/requirements.txt

#install allure
RUN wget https://github.com/allure-framework/allure2/releases/download/2.24.1/allure-2.24.1.zip && \
	unzip allure-2.24.1.zip && \
	rm allure-2.24.1.zip

#setting env varialbes
ARG tags_arg
ARG folder_arg
ENV tags=$tags_arg
ENV folder=$folder_arg
ENV file_config=src/integ-test/bdd-test/resources/config_sit.json
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin:/allure-2.24.1/bin/

#set working directory
WORKDIR /test

ENTRYPOINT ["./startIntTest.sh"]