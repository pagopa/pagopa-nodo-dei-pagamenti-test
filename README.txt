## PARAMS ##

-PROGRAM
--address=http://10.6.189.194:8082/servizio --enableRPTv2=true --RPTv2ConfFile=TS_Config.conf

-VM
-Xmx2G -Dlog4j.configurationFile=log4j2.xml -DLog4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector 