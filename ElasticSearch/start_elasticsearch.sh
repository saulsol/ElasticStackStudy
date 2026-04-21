APP_PATH_1="/Users/imsol/nospoon/elastic/cluster1/elasticsearch-8.1.3/bin/"
APP_PORT_1="9200"
APP_NAME_1="node1"

if [ -f ${APP_PATH_1}${APP_PORT_1}.pid ]; then
        PID=$(cat ${APP_PATH_1}${APP_PORT_1}.pid)
        echo "${APP_NAME_1}(pid:$PID) is running"
else
        nohup ${APP_PATH_1}elasticsearch > ${APP_PATH_1}${APP_PORT_1}.log 2>&1 & echo $! > ${APP_PATH_1}${APP_PORT_1}.pid
        PID=$(cat ${APP_PATH_1}${APP_PORT_1}.pid)
        echo "${APP_NAME_1}(pid:$PID) is start"
fi


APP_PATH_2="/Users/imsol/nospoon/elastic/cluster2/elasticsearch-8.1.3/bin/"
APP_PORT_2="9204"
APP_NAME_2="node5"

if [ -f ${APP_PATH_2}${APP_PORT_2}.pid ]; then
        PID=$(cat ${APP_PATH_2}${APP_PORT_2}.pid)
        echo "${APP_NAME_2}(pid:$PID) is running"
else
        nohup ${APP_PATH_2}elasticsearch > ${APP_PATH_2}${APP_PORT_2}.log 2>&1 & echo $! > ${APP_PATH_2}${APP_PORT_2}.pid
        PID=$(cat ${APP_PATH_2}${APP_PORT_2}.pid)
        echo "${APP_NAME_2}(pid:$PID) is start"
fi