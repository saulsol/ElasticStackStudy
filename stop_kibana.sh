#!/bin/bash

KIBANA_PATH_1="/Users/imsol/nospoon/elastic/cluster1/kibana-8.1.3/bin/"
KIBANA_PORT_1="5601"
KIBANA_NAME_1="kibana1"

if [ -f ${KIBANA_PATH_1}${KIBANA_PORT_1}.pid ]; then
        PID=$(cat ${KIBANA_PATH_1}${KIBANA_PORT_1}.pid)
        kill -15 $PID
        rm ${KIBANA_PATH_1}${KIBANA_PORT_1}.pid
        echo "${KIBANA_NAME_1}(pid:$PID) is stopped"
else
        echo "${KIBANA_NAME_1} is not running"
fi


#KIBANA_PATH_2="/Users/imsol/nospoon/elastic/cluster2/kibana-8.1.3/bin/"
#KIBANA_PORT_2="5602"
#KIBANA_NAME_2="kibana2"
#
#if [ -f ${KIBANA_PATH_2}${KIBANA_PORT_2}.pid ]; then
#        PID=$(cat ${KIBANA_PATH_2}${KIBANA_PORT_2}.pid)
#        kill -15 $PID
#        rm ${KIBANA_PATH_2}${KIBANA_PORT_2}.pid
#        echo "${KIBANA_NAME_2}(pid:$PID) is stopped"
#else
#        echo "${KIBANA_NAME_2} is not running"
#fi