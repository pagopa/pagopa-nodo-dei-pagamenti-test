#!/bin/bash
ps -aef | grep startPerfTest | grep -v grep | awk '{ print $1 }' | xargs kill -9 & \
ps -aef | grep k6 | grep -v grep | awk '{ print $1 }' | xargs kill -9 & \
ps -aef