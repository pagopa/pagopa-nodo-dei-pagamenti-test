mv PA_Mock-*.jar PA_MOCK.jar

java -Xmx500m -Dlog4j.configurationFile=log4j2.xml -DLog4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector -jar PA_MOCK.jar --address=http://0.0.0.0:8080/servizio