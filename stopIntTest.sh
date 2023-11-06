#!/bin/bash
ps -aef | grep startIntTest | grep -v grep | awk '{ print $1 }' | xargs kill -9 & \
ps -aef | grep behave | grep -v grep | awk '{ print $1 }' | xargs kill -9 & \
ps -aef