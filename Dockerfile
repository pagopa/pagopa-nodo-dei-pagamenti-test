FROM toolbox.sia.eu/docker-pagopa/integration-test-base-image:1.0.0

ENV http_proxy=http://csproxy:8080
ENV https_proxy=http://csproxy:8080
ENV no_proxy=toolbox.sia.eu


#FROM python:3.9
#
##install jq and openjdk-17                                          
#RUN apt-get update && \                                             
#	apt-get install -y jq && \                                     
#	apt-get install openjdk-17-jdk -y && \                             
#	apt-get install libpq-dev python3-dev build-essential wget unzip -y
##install allure
#RUN wget https://github.com/allure-framework/allure2/releases/download/2.24.1/allure-2.24.1.zip && \
#	unzip allure-2.24.1.zip && \
#	rm allure-2.24.1.zip

#copy test script	
ADD src/integ-test test/src/integ-test	
ADD startIntTest.sh test/startIntTest.sh
ADD stopIntTest.sh test/stopIntTest.sh
ADD requirements.txt test/requirements.txt
ADD manualtrigger.py test/manualtrigger.py
ADD entrypoint.sh test/entrypoint.sh

#install requirements
RUN pip3 install -U -r test/requirements.txt

#install python-dotenv
RUN pip3 install python-dotenv

#install ps 
RUN apt-get update && \
	apt-get install -y procps
	
#setting env varialbes
ARG ARG_TAGS
ARG ARG_FOLDER
ENV tags=$ARG_TAGS
ENV folder=$ARG_FOLDER
ENV file_config=src/integ-test/bdd-test/resources/config_sit.json
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin:/allure-2.24.1/bin/

#set working directory
WORKDIR /test

RUN chmod +x startIntTest.sh
RUN chmod +x stopIntTest.sh
RUN chmod +x entrypoint.sh
RUN chmod -R 777 src/integ-test
RUN mkdir /test/allure
RUN chmod 777 /test/allure
RUN mkdir /test/allure/allure-result
RUN chmod 777 /test/allure/allure-result

RUN echo $tags
RUN echo $folder

ENV http_proxy=http://10.79.20.33:80
ENV https_proxy=http://10.79.20.33:80

ENTRYPOINT ["./entrypoint.sh"]
