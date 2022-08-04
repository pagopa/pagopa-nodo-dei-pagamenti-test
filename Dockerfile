# Build stage
FROM maven:3.6.0-jdk-11-slim
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/

RUN mvn package

ENTRYPOINT ["java", "-Dlog4j.configurationFile","/tmp/target/log4j2.xml", "-DLog4jContextSelector","org.apache.logging.log4j.core.async.AsyncLoggerContextSelector ",  "-jar","/tmp/target/PA_Mock-1.1.1.jar"]
EXPOSE 8484
