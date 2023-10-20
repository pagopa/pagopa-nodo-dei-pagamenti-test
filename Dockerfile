FROM toolbox.sia.eu/docker-pagopa/integration-test-base-image:1.0.0
 
ENV http_proxy=http://csproxy:8080
ENV https_proxy=http://csproxy:8080
ENV no_proxy=toolbox.sia.eu

#copy test script
ADD src/integ-test test/src/integ-test
ADD startIntTest.sh test/startIntTest.sh
ADD requirements.txt test/requirements.txt

#install requirements
RUN pip3 install -U -r test/requirements.txt

#setting env varialbes
ARG tags
ARG folder
ENV file_config=src/integ-test/bdd-test/resources/config_sit.json
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin:/allure-2.24.1/bin/

#set working directory
WORKDIR /test

RUN echo $tags
RUN echo $folder

ENTRYPOINT ["./startIntTest.sh"]