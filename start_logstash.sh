#!/bin/bash

# Logstash 홈 디렉토리
LOGSTASH_HOME="/Users/imsol/nospoon/logstash/logstash-8.1.3"

# 설정 파일
CONFIG_FILE="$LOGSTASH_HOME/config/logstash-sample.conf"

# 실행
echo "Starting Logstash..."
$LOGSTASH_HOME/bin/logstash -f $CONFIG_FILE