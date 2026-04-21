#!/bin/bash

APP_PATH_1="/Users/imsol/nospoon/elastic/cluster1/elasticsearch-8.1.3/bin/"
APP_PORT_1="9200"
APP_NAME_1="node1"

if [ -f ${APP_PATH_1}${APP_PORT_1}.pid ]; then
        PID=$(cat ${APP_PATH_1}${APP_PORT_1}.pid)
        kill $PID
        rm ${APP_PATH_1}${APP_PORT_1}.pid
        echo "${APP_NAME_1}(pid:$PID) is stopped"
else
        echo "${APP_NAME_1} is not running"
fi


APP_PATH_2="/Users/imsol/nospoon/elastic/cluster2/elasticsearch-8.1.3/bin/"
APP_PORT_2="9204"
APP_NAME_2="node5"

if [ -f ${APP_PATH_2}${APP_PORT_2}.pid ]; then
        PID=$(cat ${APP_PATH_2}${APP_PORT_2}.pid)
        kill $PID
        rm ${APP_PATH_2}${APP_PORT_2}.pid
        echo "${APP_NAME_2}(pid:$PID) is stopped"
else
        echo "${APP_NAME_2} is not running"
fi