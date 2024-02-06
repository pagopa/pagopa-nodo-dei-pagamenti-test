#!/bin/bash
ps -aef | grep startIntTest | grep -v grep | awk '{ print $2 }' | xargs kill -9 & \
ps -aef | grep behave | grep -v grep | awk '{ print $2 }' | xargs kill -9 & \
ps -aef

mkdir -p /test/allure/allure-result/history || echo "history folder already in place...continuing :)" && cp /test/allure/allure-report/history/* /test/allure/allure-result/history && echo "Allure trends updated!"

ls -lash /test/allure/allure-result

allure generate /test/allure/allure-result --clean -o /test/allure/allure-report