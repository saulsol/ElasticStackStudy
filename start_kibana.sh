KIBANA_PATH_1="/Users/imsol/nospoon/elastic/cluster1/kibana-8.1.3/bin/"
KIBANA_PORT_1="5601"
KIBANA_NAME_1="kibana1"

if [ -f ${KIBANA_PATH_1}${KIBANA_PORT_1}.pid ]; then
        PID=$(cat ${KIBANA_PATH_1}${KIBANA_PORT_1}.pid)
        echo "${KIBANA_NAME_1}(pid:$PID) is running"
else
        nohup ${KIBANA_PATH_1}kibana > ${KIBANA_PATH_1}${KIBANA_PORT_1}.log 2>&1 & echo $! > ${KIBANA_PATH_1}${KIBANA_PORT_1}.pid
        PID=$(cat ${KIBANA_PATH_1}${KIBANA_PORT_1}.pid)
        echo "${KIBANA_NAME_1}(pid:$PID) is start"
fi


#KIBANA_PATH_2="/Users/imsol/nospoon/elastic/cluster2/kibana-8.1.3/bin/"
#KIBANA_PORT_2="5602"
#KIBANA_NAME_2="kibana2"
#
#if [ -f ${KIBANA_PATH_2}${KIBANA_PORT_2}.pid ]; then
#        PID=$(cat ${KIBANA_PATH_2}${KIBANA_PORT_2}.pid)
#        echo "${KIBANA_NAME_2}(pid:$PID) is running"
#else
#        nohup ${KIBANA_PATH_2}kibana > ${KIBANA_PATH_2}${KIBANA_PORT_2}.log 2>&1 & echo $! > ${KIBANA_PATH_2}${KIBANA_PORT_2}.pid
#        PID=$(cat ${KIBANA_PATH_2}${KIBANA_PORT_2}.pid)
#        echo "${KIBANA_NAME_2}(pid:$PID) is start"
#fi