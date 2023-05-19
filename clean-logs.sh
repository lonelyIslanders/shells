#!/bin/bash

echo "开始任务"
echo $(date +%F%n%T)
LOGS_DIR="/home/skynet/.pm2/logs" #更改你的路径
MAX_LOG_SIZE=$((1024*1024*1024)) #1G

for LOG_FILE in $(find "${LOGS_DIR}" -type f) #普通文件
do
  LOG_SIZE=$(du -b "${LOG_FILE}" | cut -f1)
  
  if [[ ${LOG_SIZE} -gt ${MAX_LOG_SIZE} ]]
  then
    echo "清空日志文件：${LOG_FILE}"
    echo "" > "${LOG_FILE}"
  fi
done
echo $(date +%F%n%T)
echo "任务结束"
