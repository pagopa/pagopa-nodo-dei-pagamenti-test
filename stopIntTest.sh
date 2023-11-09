#!/bin/bash
ps -aef | grep startIntTest | grep -v grep | awk '{ print $2 }' | xargs kill -9 & \
ps -aef | grep behave | grep -v grep | awk '{ print $2 }' | xargs kill -9 & \
ps -aef