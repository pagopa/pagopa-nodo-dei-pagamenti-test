# Build stage
FROM maven:3.6.0-jdk-11-slim
COPY pom.xml /tmp/
COPY src /tmp/src/
COPY log4j2.xml /tmp/log4j2.xml
COPY PA_List.dat /tmp/PA_List.dat
COPY TS_Config.conf /tmp/TS_Config.conf
COPY rpt.xml /tmp/rpt.xml
COPY apm.conf /tmp/apm.conf
COPY elastic-apm-agent-1.26.0.jar /tmp/elastic-apm-agent-1.26.0.jar
COPY startPAMock.sh /tmp/startPAMock.sh

WORKDIR /tmp/

RUN mvn package

RUN mv startPAMock.sh target/startPAMock.sh

WORKDIR target

RUN chmod +777 startPAMock.sh

EXPOSE 8484

ENTRYPOINT ["/bin/sh", "./startPAMock.sh"]