FROM toolbox.sia.eu/docker-pagopa/integration-test-base-image:1.0.0

ENV http_proxy=http://csproxy:8080
ENV https_proxy=http://csproxy:8080
ENV no_proxy=toolbox.sia.eu

#copy test script
ADD src/integ-test test/src/integ-test
ADD startIntTest.sh test/startIntTest.sh
ADD requirements.txt test/requirements.txt
ADD manualtrigger.py test/manualtrigger.py
ADD entrypoint.sh test/entrypoint.sh

#install requirements
RUN pip3 install -U -r test/requirements.txt
RUN apt-get install -y procps

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
RUN chmod +x entrypoint.sh
RUN chmod -R 777 src/integ-test
RUN mkdir /test/allure
RUN chmod 777 /test/allure
RUN mkdir /test/allure-result
RUN chmod 777 /test/allure-result

RUN echo $tags
RUN echo $folder


ENTRYPOINT ["./entrypoint.sh"]